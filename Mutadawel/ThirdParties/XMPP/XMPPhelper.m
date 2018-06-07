//
//  Last Updated by Alok on 06/05/14.
//  Copyright (c) 2014 Aryansbtloe. All rights reserved.
//

#import "XMPPhelper.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import <CFNetwork/CFNetwork.h>
#import "Mutadawel-Swift.h"
#import "DDLog.h"
#define XMPP_LOG_FLAG_SEND      (1 << 5)
#define XMPP_LOG_FLAG_RECV_PRE  (1 << 6) // Prints data before it goes to the parser
#define XMPP_LOG_FLAG_RECV_POST (1 << 7) // Prints data as it comes out of the parser

#define XMPP_LOG_FLAG_SEND_RECV (XMPP_LOG_FLAG_SEND | XMPP_LOG_FLAG_RECV_POST)
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

//XMPPJID *friendReq;
XMPPvCardTemp *fr_VcardTemp;

@implementation XMPPhelper

@synthesize xmppmuc;
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize xmppMessageArchivingStorage, xmppMessageArchivingModule;
@synthesize xmppMulti;


static XMPPhelper *singletonInstance = nil;

+ (XMPPhelper *)sharedInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (singletonInstance == nil) {
            singletonInstance = [[XMPPhelper alloc]init];
        }
    });
    return singletonInstance;
}

#pragma mark -- xmpp methods

- (void)dealloc {
    [self teardownStream];
}

- (NSManagedObjectContext *)managedObjectContext_roster {
    return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities {
    return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_messageArchive {
    return [xmppMessageArchivingStorage mainThreadManagedObjectContext];
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator_messageArchive {
    return [xmppMessageArchivingStorage persistentStoreCoordinator];
}
- (NSManagedObjectModel *)managedObjectModel_messageArchive;
{
    return [xmppMessageArchivingStorage managedObjectModel];
}
/////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream {
    self.userPassword = @"123456";
    
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
    
    
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
    // Setup xmpp stream
    //
    // The XMPPStream is the base class for all activity.
    // Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
    xmppStream = [[XMPPStream alloc] init];
    //xmppStream.autoStartTLS=YES;
    
#if !TARGET_IPHONE_SIMULATOR
    {
        // Want xmpp to run in the background?
        //
        // P.S. - The simulator doesn't support backgrounding yet.
        //        When you try to set the associated property on the simulator, it simply fails.
        //        And when you background an app on the simulator,
        //        it just queues network traffic til the app is foregrounded again.
        //        We are patiently waiting for a fix from Apple.
        //        If you do enableBackgroundingOnSocket on the simulator,
        //        you will simply see an error message from the xmpp stack when it fails to set the property.
        
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    
    // Setup reconnect
    //
    // The XMPPReconnect module monitors for "accidental disconnections" and
    // automatically reconnects the stream for you.
    // There's a bunch more information in the XMPPReconnect header file.
    
    xmppReconnect = [[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    
    // Setup roster
    //
    // The XMPPRoster handles the xmpp protocol stuff related to the roster.
    // The storage for the roster is abstracted.
    // So you can use any storage mechanism you want.
    // You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
    // or setup your own using raw SQLite, or create your own storage mechanism.
    // You can do it however you like! It's your application.
    // But you do need to provide the roster with some storage facility.
    
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
    
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    // Setup vCard support
    //
    // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
    // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
    
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
    // Setup capabilities
    //
    // The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
    // Basically, when other clients broadcast their presence on the network
    // they include information about what capabilities their client supports (audio, video, file transfer, etc).
    // But as you can imagine, this list starts to get pretty big.
    // This is where the hashing stuff comes into play.
    // Most people running the same version of the same client are going to have the same list of capabilities.
    // So the protocol defines a standardized way to hash the list of capabilities.
    // Clients then broadcast the tiny hash instead of the big list.
    // The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
    // and also persistently storing the hashes so lookups aren't needed in the future.
    //
    // Similarly to the roster, the storage of the module is abstracted.
    // You are strongly encouraged to persist caps information across sessions.
    //
    // The XMPPCapabilitiesCoreDataStorage is an ideal solution.
    // It can also be shared amongst multiple streams to further reduce hash lookups.
    
    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = YES;
    xmppCapabilities.autoFetchMyServerCapabilities = YES;
    
    // xmppmuc = [[XMPPMUC alloc]initWithDispatchQueue:dispatch_get_main_queue()];
    
    // Activate xmpp modules
    //[xmppmuc activate:xmppStream];
    [xmppReconnect activate:xmppStream];
    [xmppRoster activate:xmppStream];
    [xmppvCardTempModule activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];
    [xmppCapabilities activate:xmppStream];
    
    // Add ourself as a delegate to anything we may be interested in
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //[xmppmuc addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // Optional:
    //
    // Replace me with the proper domain and port.
    // The example below is setup for a typical google talk account.
    //
    // If you don't supply a hostName, then it will be automatically resolved using the JID (below).
    // For example, if you supply a JID like 'user@quack.com/rsrc'
    // then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
    //
    // If you don't specify a hostPort, then the default (5222) will be used.
    
    xmppStream.hostName = xmppHostName;
    [xmppStream setHostPort:xmppHostPort];
    
    
    // You may need to alter these settings depending on the server you're connecting to
    allowSelfSignedCertificates = YES;
    allowSSLHostNameMismatch = NO;
    
    //msg archiving
    xmppMessageArchivingStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingStorage];
    [xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    
    [xmppMessageArchivingModule activate:xmppStream];
    [xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    /*
    xmppMessageDR = [[XMPPMessageDeliveryReceipts alloc]init];
    [xmppMessageDR activate:xmppStream];
    xmppMessageDR.autoSendMessageDeliveryReceipts = YES;
    xmppMessageDR.autoSendMessageDeliveryRequests = YES;
    
    */
    xmppMulti = [[XMPPMultiCast alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    
    [xmppMulti activate:xmppStream];
    
    /////////
    
    //_xmppTimeVar = [[XMPPTime alloc]initWithDispatchQueue:dispatch_get_main_queue()];
    //_xmppTimeVar.respondsToQueries=YES;
    //_autoTImeModule =[[XMPPAutoTime alloc]initWithDispatchQueue:dispatch_get_main_queue()];
    //_autoTImeModule.respondsToQueries=YES;
    //_autoTImeModule.recalibrationInterval = 60;
    //_autoTImeModule.targetJID = nil;
    
    
    
    //[_xmppTimeVar activate:xmppStream];
    //[_autoTImeModule     activate:xmppStream];
    
    
    
    //[_autoTImeModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    _xmppAutoPing =  [[XMPPAutoPing alloc] init];
    
    _xmppAutoPing.pingInterval = 120.0;
    [_xmppAutoPing          activate:xmppStream];
    _xmppAutoPing.respondsToQueries=YES;
    [_xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    XMPPStreamManagementMemoryStorage *streamMem=[[XMPPStreamManagementMemoryStorage alloc]init];
    
    _streamManagement=[[XMPPStreamManagement alloc]initWithStorage:streamMem dispatchQueue:dispatch_get_main_queue()];;
    
    [self.xmppStream registerModule:_streamManagement];
    [_streamManagement activate:self.xmppStream];
    
    [_streamManagement addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_streamManagement enableStreamManagementWithResumption:YES maxTimeout:20.0];
    _streamManagement.autoResume=YES;
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
    
    NSString *documentsSubpath;
    NSLog(@"doc path--->>>%@",documentsDirectory);
}

#pragma ping
- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender{
    DDLogVerbose(@"auto ping   %@: %@ ", [self class], THIS_METHOD);
}
- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender{
    DDLogVerbose(@"auto ping   %@: %@ ", [self class], THIS_METHOD);
}

- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender{
    DDLogVerbose(@"auto ping   %@: %@ ", [self class], THIS_METHOD);
}


#pragma stream management
- (void)xmppStreamManagement:(XMPPStreamManagement *)sender wasEnabled:(NSXMLElement *)enabled{
    DDLogVerbose(@"stream management   %@: %@ ", [self class], THIS_METHOD);
}
- (void)xmppStreamManagement:(XMPPStreamManagement *)sender wasNotEnabled:(NSXMLElement *)failed{
    DDLogVerbose(@"stream management      %@: %@ ", [self class], THIS_METHOD);
}
- (void)xmppAutoTime:(XMPPAutoTime *)sender didUpdateTimeDifference:(NSTimeInterval)timeDifference{
    DDLogVerbose(@"%@: %@ %f <<<<<<<============", [self class], THIS_METHOD, timeDifference);
    // myTime = [givenTimeFromRemoteParty dateByAddingTimeInterval:diff];
    
}
- (void)changeAutoTimeInterval:(NSTimer *)aTimer
{
    DDLogVerbose(@"%@: %@", [self class], THIS_METHOD);
    NSLog(@"time_2");
    //autoTImeModule.recalibrationInterval = 30;
}

- (void)teardownStream {
    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    [xmppReconnect         deactivate];
    [xmppRoster            deactivate];
    [xmppvCardTempModule   deactivate];
    [xmppvCardAvatarModule deactivate];
    [xmppCapabilities      deactivate];
    [xmppStream disconnect];
    xmppStream = nil;
    xmppReconnect = nil;
    xmppRoster = nil;
    xmppRosterStorage = nil;
    xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
    xmppvCardAvatarModule = nil;
    xmppCapabilities = nil;
    xmppCapabilitiesStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect {
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    //
    // If you don't want to use the Settings view to set the JID,
    // uncomment the section below to hard code a JID and password.
    //c
    if (_userName == nil || _userPassword == nil) {
        return NO;
    }
    NSString *myJID =[NSString stringWithFormat:@"%@@%@",_userName,xmppHostNameJidSubString];
    [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    
    XMPPMessageDeliveryReceipts* xmppMessageDeliveryRecipts = [[XMPPMessageDeliveryReceipts alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    xmppMessageDeliveryRecipts.autoSendMessageDeliveryReceipts = YES;
    xmppMessageDeliveryRecipts.autoSendMessageDeliveryRequests = YES;
    [xmppMessageDeliveryRecipts activate:xmppStream];
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        DDLogError(@"Error connecting: %@", error);
        
        return NO;
    }
    
    return YES;
}

- (void)disconnect {
    [self goOffline];
    [xmppStream disconnect];
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if (allowSelfSignedCertificates) {
        [settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
    }
    
    if (allowSSLHostNameMismatch) {
        [settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
    }
    else {
        // Google does things incorrectly (does not conform to RFC).
        // Because so many people ask questions about this (assume xmpp framework is broken),
        // I've explicitly added code that shows how other xmpp clients "do the right thing"
        // when connecting to a google server (gmail, or google apps for domains).
        
        NSString *expectedCertName = nil;
        if (expectedCertName) {
            [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
        }
    }
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"connect in apppdelegate");
    isXmppConnected = YES;
    if (self.chatViewController) {
        //[self setScreenTitle:self.chatViewController];
    }
    NSError *error = nil;
    
    if (![[self xmppStream] authenticateWithPassword:_userPassword error:&error]) {
        DDLogError(@"Error authenticating: %@", error);
    }
    
    NSError *errorF = nil;
    
    BOOL result = NO;
    if (result == NO) {
        DDLogError(@"%@: Error in xmpp auth: %@", THIS_FILE, errorF);
        
    }
}

- (void)xmppStreamWillConnect:(XMPPStream *)sender {
    NSLog(@"willll connect");
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    DDLogVerbose(@"%@: %@", [self class], THIS_METHOD);
    
    NSLog(@"Authenticated succesfully");
    
    if (sender == xmppStream) {
        
        XMPPvCardTemp *myVcardTemp = [self.xmppvCardTempModule myvCardTemp];
        
        // UIImage *avatarImage = [UIImage imageWithData:myVcardTemp.photo];
        
        // UIImage *photoData = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[UtilClass getDataFromNSUserDefault:@"current_user_image"]];
        UIImage *photoData = nil;
        if (photoData) {
            
            
            [myVcardTemp setPhoto:UIImageJPEGRepresentation(photoData, 0.5)];
        }
        [self.xmppvCardTempModule updateMyvCardTemp:myVcardTemp];
        
        //NSLog(@"vaaaaa------%@----%@",UIImageJPEGRepresentation(photoData, 0.1),myVcardTemp.photo);
        
        [self goOnline];
        //        [_streamManagement enableStreamManagementWithResumption:YES maxTimeout:10.0];
        //        _streamManagement.autoResume=YES;
        //        if ([self.xmppStream supportsStreamManagement]) {
        //            NSLog(@"stream management ---->>>>");
        //        }else{
        //            NSLog(@"not stream management ---->>>>");
        //
        //
        //        }
    }
    
    //[self goOnline_fb];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    //NSError *err = nil;
    
    if (sender==xmppStream) {
        if (![xmppStream supportsInBandRegistration]) {
            NSLog(@"in band ambrish no");
        }
        else{
            NSLog(@"in band ambrish yes");
            
            NSError *error = nil;
            
            //NSString *myJID =[NSString stringWithFormat:@"%@@%s",_userName,"gmail.com"];
            
            
            if (![xmppStream registerWithPassword:_userPassword error:&error])
            {
                NSLog(@"Oops, I forgot something: %@", error);
            }else{
                NSLog(@"No Error registered successfully");
            }
        }
        [self goOnline];
    }
    
    if (sender == xmppStream) {
        [self goOnline];
    }
}
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    
    //NSLog(@"message sent-------->>>>>>>>> %@",message);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SEND_PUSH_CHAT" object:message];
}
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    //NSLog(@"message recieved-------->>>>>>>>> %@",message);
//    if message.hasMarkableChatMarker() {
//        if message.from().user == self.other_user_id {
//            let message : XMPPMessage  = message.generateDisplayedChatMarker()
//            sender.send(message)hjbjk
//        }
//    }
    /*
     if message.hasDisplayedChatMarker() {
     
     for item in self.chatObjectsArray {
     if let ids = item.message.elementID() {
     if ids == message.chatMarkerID() {
     item.message = message
     saveContext()
     
     break
     }
     }
     }
     }
     */
    
    
    
    
    if ([message hasMarkableChatMarker]){
        if ([message.from.user isEqualToString:self.currentOtherUser]) {
            return;
        }
        XMPPMessage *messageObj = [message generateReceivedChatMarker];
        [sender sendElement:messageObj];
    }
    
    if ([message hasReceivedChatMarker] || [message hasDisplayedChatMarker]) {
        NSString *ele_id ;
        
        if (message.elementID) {
            ele_id = message.elementID ;
        }else{
            ele_id = message.chatMarkerID ;
        }
        
        NSArray *arr = [self getMessagesForUserId:message.from.user withElementId:ele_id];
        for (XMPPMessageArchiving_Message_CoreDataObject *item in arr) {
            /*
             if let ids = item.message.elementID() {
             if ids == message.chatMarkerID() {
             item.message = message
             saveContext()
             
             break
             }
             }
             */
            
            if (item.message.elementID) {
                
                if ([item.message.elementID isEqualToString:message.chatMarkerID]) {
                    //item.message = message;
                    NSError *err;
                    if ([message hasDisplayedChatMarker]) {
                        item.markStatus = [NSNumber numberWithInteger:2];

                    }else if ([message hasReceivedChatMarker]){
                        item.markStatus = [NSNumber numberWithInteger:1];
                    }
                    if (![self.managedObjectContext_messageArchive save:&err]){
                        NSLog(@"fail");

                    }else{
                        NSLog(@"success");
                        
                    }
                    break;
                }
            }
            else if (item.message.chatMarkerID){
                if ([item.message.chatMarkerID isEqualToString:message.chatMarkerID]) {
                    //item.message = message;
                    if ([message hasDisplayedChatMarker]) {
                        item.markStatus = [NSNumber numberWithInteger:2];
                        
                    }else if ([message hasReceivedChatMarker]){
                        item.markStatus = [NSNumber numberWithInteger:1];
                    }
                    NSError *err;
                    if (![self.managedObjectContext_messageArchive save:&err]){
                        NSLog(@"fail");
                        
                    }else{
                        NSLog(@"success");
                    }
                    break;
                }
            }
        }
        
    }

    
}
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    NSLog(@"registering....");
    
    [self performSelector:@selector(connect1) withObject:nil afterDelay:2.0];
}
-(void)connect1
{
    
    NSError *error = nil;
    [xmppStream authenticateWithPassword:_userPassword error:&error];
    
}
/**
 * This method is called if registration fails.
 **/
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"problem occured in registering.......");
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    DDLogVerbose(@"%@: %@  :%@", THIS_FILE, THIS_METHOD,error);
    
    if (self.chatViewController) {
        // [self setScreenTitle:self.chatViewController];
    }
    if (!xmppStream.isConnected)
    {
        DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
        NSLog(@"Unable to connect to server. Check xmppStream.hostName");
        
        //[self performSelector:@selector(reconnect) withObject:nil afterDelay:10];
        //XMPPLogTrace();
        //[xmppRosterStorage clearAllUsersAndResourcesForXMPPStream:xmppStream];
        //[xmppRosterStorage clearAllUsersAndResourcesForXMPPStream:xmppStreamFacebook];
        //[xmppRosterStorage_fb clearAllUsersAndResourcesForXMPPStream:xmppStreamFacebook];
        
        //[self _setRequestedRoster:NO];
        //        [self _setHasRoster:NO];
        //
        //        [earlyPresenceElements removeAllObjects];
    }
}

-(void)reconnect{
    if ([self connect]) {
        NSLog(@"connecting......");
    }else{
        NSLog(@"trying to connect again....");
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    XMPPJID *friendReq=[presence from];
    fr_VcardTemp = [self.xmppvCardTempModule vCardTempForJID:friendReq shouldFetch:YES];
    
    
    
    //NSLog(@"freind req ---%@",fr_VcardTemp);
    //NSString *displayName = [fr_VcardTemp nickname];
    //NSString *jidStrBare = [presence fromStr];
    // [xmppRoster addUser:friendReq withNickname:fr_VcardTemp.nickname];
    [xmppRoster addUser:presence.from withNickname:fr_VcardTemp.nickname groups:nil subscribeToPresence:YES];
    
    //NSString *body = nil;
    
    /*
     if (![displayName isEqualToString:jidStrBare])
     {
     body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
     }
     else
     {
     body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
     }
     
     
     if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
     {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
     message:body
     delegate:nil
     cancelButtonTitle:@"Not Now"
     otherButtonTitles:@"Add as buddy",@"NO", nil];
     //alertView.delegate=self;
     [alertView show];
     
     
     }
     else
     {
     // We are not active, so use a local notification instead
     UILocalNotification *localNotification = [[UILocalNotification alloc] init];
     localNotification.alertAction = @"Not implemented";
     localNotification.alertBody = body;
     
     [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
     }
     */
}



- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence {
    NSLog(@"%@", [presence from]);
}
-(XMPPUserCoreDataStorageObject *)getUserCoreDataObjectForUserId:(NSString*)userId{
    NSManagedObjectContext *moc = [[XMPPhelper sharedInstance] managedObjectContext_roster];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"jidStr contains[cd] %@", [NSString stringWithFormat:@"%@@%@",userId,xmppHostNameJidSubString]];
    
    
    
    NSPredicate *compound_predicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate]];
    
    [request setPredicate:compound_predicate];
    
    NSError *error;
    NSArray *user_cd_arr = [moc executeFetchRequest:request error:&error];
    if (user_cd_arr.count==0) {
        return nil;
    }
    XMPPUserCoreDataStorageObject *userObj=user_cd_arr[0];
    
    return userObj;
}
-(NSString*)getXmppHostNameJidSubString{
    return [NSString stringWithFormat:@"%@",xmppHostNameJidSubString];
}
-(NSString*)getXmppHostName{
    return [NSString stringWithFormat:@"%@",xmppHostName];
}

-(void)setScreenTitle:(__weak UIViewController*)vc{
    
    vc.navigationItem.titleView = nil;
    self.chatViewController = vc;
    
    UIView *navView;
    UILabel *titleLbl;
    
    if ([vc isKindOfClass:[ChatViewControllerSwift class]]) {
        navView = ((ChatViewControllerSwift*)vc).headerView;
        titleLbl = ((ChatViewControllerSwift*)vc).otherUserNameLbl;
    }
    else  if ([vc isKindOfClass:[MessagesVC class]]) {
       // navView = ((MessagesVC*)vc).headerView;
       // titleLbl = ((MessagesVC*)vc).tableHeaderViewLbl;
    }
    else{
        return;
    }
    if (![[[XMPPhelper sharedInstance] xmppStream] isConnected] || ![[[XMPPhelper sharedInstance] xmppStream] isAuthenticated]) {
        if ([[[XMPPhelper sharedInstance] xmppStream] isConnecting]) {
            //self.title = @"Connecting...";
            
            UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,180,32)];
            iv.tag = 5432;
            [iv setBackgroundColor:[UIColor clearColor]];
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [indicator  startAnimating];
            [iv addSubview:indicator];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(indicator.bounds) + 10, 0, 160, 25)];
            lab.text = @"connecting...";
            //lab.font = [UIFont fontWithName:globalFont_bold size:13];
            lab.textColor = [UIColor whiteColor];
            [iv addSubview:lab];
            [navView addSubview:iv];
            titleLbl.hidden = YES;
            
        }else{
            //self.title = @"Not Connected";
            
            
            UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,180,32)];
            iv.tag = 5432;
            [iv setBackgroundColor:[UIColor clearColor]];
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [indicator  startAnimating];
            [iv addSubview:indicator];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(indicator.bounds) + 10, 0, 160, 25)];
            lab.text = @"waiting for network";
            // lab.font = [UIFont fontWithName:globalFont_bold size:13];
            lab.textColor = [UIColor whiteColor];
            [iv addSubview:lab];
            [navView addSubview:iv];
            titleLbl.hidden = YES;
        }
    }else{
        if([navView viewWithTag:5432]){
            [[navView viewWithTag:5432] removeFromSuperview];
        }
    }
}
-(NSInteger)getUnreadMessageContactForHome{
    
    NSManagedObjectContext *moc = [[XMPPhelper sharedInstance] managedObjectContext_messageArchive];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate1;
    predicate1 = [NSPredicate predicateWithFormat:@"isReadStr == 0"];
    
    NSPredicate *predicate2;
    predicate2 = [NSPredicate predicateWithFormat:@"mostRecentMessageOutgoing == 0"];
    
    // let predicate1 = NSPredicate(format: "NOT (ids contains[cd] '\(self.user_id)')")
    NSPredicate *predicate3;
    
    
    NSPredicate *predicate4;
    
    predicate4 = [NSPredicate predicateWithFormat:@"(streamBareJidStr == %@)", [NSString stringWithFormat:@"%@@%@",self.userName,xmppHostNameJidSubString]];
    
    
    NSPredicate *compound_predicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[ predicate1,predicate2,predicate4]];
    
    [request setPredicate:compound_predicate];
    
    NSError *error;
    NSArray *messages_cd = [moc executeFetchRequest:request error:&error];
    
    //[self print:[[NSMutableArray alloc]initWithArray:messages_cd]];
    
    return  messages_cd.count;
}




-(NSArray*)getMessagesForUserId:(NSString*)userId{
    NSManagedObjectContext *moc = [[XMPPhelper sharedInstance] managedObjectContext_messageArchive];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    
    NSPredicate *predicate2;
    predicate2 = [NSPredicate predicateWithFormat:@"outgoing == 1"];
    
    // let predicate1 = NSPredicate(format: "NOT (ids contains[cd] '\(self.user_id)')")
    NSPredicate *predicate3;
    
    predicate3 = [NSPredicate predicateWithFormat:@"(bareJidStr contains[cd] %@)", [NSString stringWithFormat:@"%@",userId]];
    
    
    
    NSPredicate *compound_predicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate2]];
    
    [request setPredicate:compound_predicate];
    
    NSError *error;
    NSArray *messages_cd = [moc executeFetchRequest:request error:&error];
    
    //[self print:[[NSMutableArray alloc]initWithArray:messages_cd]];
    
    return  messages_cd;
}
-(NSArray*)getMessagesForUserId:(NSString*)userId withElementId:(NSString*)elementId{
    NSManagedObjectContext *moc = [[XMPPhelper sharedInstance] managedObjectContext_messageArchive];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    
    NSPredicate *predicate2;
    predicate2 = [NSPredicate predicateWithFormat:@"outgoing == 1"];
    
    // let predicate1 = NSPredicate(format: "NOT (ids contains[cd] '\(self.user_id)')")
    NSPredicate *predicate3;
    
    predicate3 = [NSPredicate predicateWithFormat:@"(bareJidStr contains[cd] %@)", [NSString stringWithFormat:@"%@",userId]];
    
    NSPredicate *predicate4;
    
    predicate4 = [NSPredicate predicateWithFormat:@"(element_id contains[cd] %@)", [NSString stringWithFormat:@"%@",elementId]];
    
    NSPredicate *compound_predicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate2,predicate3,predicate4]];
    
    [request setPredicate:compound_predicate];
    
    NSError *error;
    NSArray *messages_cd = [moc executeFetchRequest:request error:&error];
    
    //[self print:[[NSMutableArray alloc]initWithArray:messages_cd]];
    
    return  messages_cd;
}

-(void)sendStatusAsDisplayedForMessagesForUserId:(NSString*)userId {
    
    NSManagedObjectContext *moc = [[XMPPhelper sharedInstance] managedObjectContext_messageArchive];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    
    NSPredicate *predicate2;
    predicate2 = [NSPredicate predicateWithFormat:@"outgoing == 0"];
    
    // let predicate1 = NSPredicate(format: "NOT (ids contains[cd] '\(self.user_id)')")
    NSPredicate *predicate3;
    
    predicate3 = [NSPredicate predicateWithFormat:@"(bareJidStr contains[cd] %@)", [NSString stringWithFormat:@"%@",userId]];
    
    NSPredicate *predicate4;
    predicate4 = [NSPredicate predicateWithFormat:@"(markStatus == %d)", 0];
    
    NSPredicate *predicate5;
    predicate5 = [NSPredicate predicateWithFormat:@"(markStatus == %d)", 1];
    
    

    //NSPredicate *compound_predicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate3]];
    NSPredicate *compound_predicate1 = [NSCompoundPredicate orPredicateWithSubpredicates: @[predicate4,predicate5]];
    NSPredicate *compound_predicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate3,compound_predicate1,predicate2]];

    [request setPredicate:compound_predicate];
    
    NSError *error;
    NSArray *messages_cd = [moc executeFetchRequest:request error:&error];
    
    for (XMPPMessageArchiving_Message_CoreDataObject *obj in messages_cd) {
        NSLog(@"messsage Status: %@", obj.markStatus);
        obj.markStatus = [NSNumber numberWithInteger:2];
        /*
        let message : XMPPMessage  = obj.message.generateDisplayedChatMarker()
        XMPPhelper.sharedInstance().xmppStream.send(message)
*/
        if (obj.message.hasChatMarker == true ){

        XMPPMessage *message = obj.message.generateDisplayedChatMarker ;
        [self.xmppStream sendElement:message];
            
        }
    }
}
-(void)sendStatusAsDisplayedForMessagesForUserId:(NSString*)userId forBusiness:(NSString*)busId {
    
    NSManagedObjectContext *moc = [[XMPPhelper sharedInstance] managedObjectContext_messageArchive];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    
    NSPredicate *predicate2;
    predicate2 = [NSPredicate predicateWithFormat:@"outgoing == 0"];
    
    // let predicate1 = NSPredicate(format: "NOT (ids contains[cd] '\(self.user_id)')")
    NSPredicate *predicate3;
    
    predicate3 = [NSPredicate predicateWithFormat:@"(bareJidStr contains[cd] %@)", [NSString stringWithFormat:@"%@",userId]];
    
    NSPredicate *predicate4;
    predicate4 = [NSPredicate predicateWithFormat:@"(markStatus == %d)", 0];
    
    NSPredicate *predicate5;
    predicate5 = [NSPredicate predicateWithFormat:@"(markStatus == %d)", 1];
    
    

    
    //NSPredicate *compound_predicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate3]];
    NSPredicate *compound_predicate1 = [NSCompoundPredicate orPredicateWithSubpredicates: @[predicate4,predicate5]];
    NSPredicate *compound_predicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate3,compound_predicate1,predicate2]];
    
    [request setPredicate:compound_predicate];
    
    NSError *error;
    NSArray *messages_cd = [moc executeFetchRequest:request error:&error];
    
    for (XMPPMessageArchiving_Message_CoreDataObject *obj in messages_cd) {
        NSLog(@"messsage Status: %@", obj.markStatus);
        obj.markStatus = [NSNumber numberWithInteger:2];
        /*
         let message : XMPPMessage  = obj.message.generateDisplayedChatMarker()
         XMPPhelper.sharedInstance().xmppStream.send(message)
         */
        if (obj.message.hasChatMarker == true ){
            
            XMPPMessage *message = obj.message.generateDisplayedChatMarker ;
            [self.xmppStream sendElement:message];
            
        }
    }
}

-(void)deleteOtherBusinessThread:(NSString*) businessID {
    
    
    NSManagedObjectContext *moc = [[XMPPhelper sharedInstance] managedObjectContext_messageArchive];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    NSPredicate *predicate;
    //predicate = [NSPredicate predicateWithFormat:@"bareJidStr contains[cd] %@", [NSString stringWithFormat:@"%@@%@",_userProfile.glubbrUserId,xmppHostNameJidSubString]];
    
    
    
    
    NSPredicate *compound_predicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate]];
    [request setPredicate:compound_predicate];
    
    
    //[request setPredicate:predicate];
    
    NSError *error;
    NSArray *messages_cd = [moc executeFetchRequest:request error:&error];
    if (messages_cd.count==0) {
        
    }else{
        XMPPMessageArchiving_Contact_CoreDataObject *message = messages_cd.firstObject;
        
        [moc deleteObject:message];
        NSError *error;
        if ([moc save:(&error)]) {
            NSLog(@"contact deleted");
        }
        
    }
    
    
    
}

-(void)setReadForIDS:(NSString*)ids{
    
    
    NSLog(@"contact updated to read");
    
    
    
    
    NSManagedObjectContext *moc = [[XMPPhelper sharedInstance] managedObjectContext_messageArchive];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    NSPredicate *predicate;
    //predicate = [NSPredicate predicateWithFormat:@"bareJidStr contains[cd] %@", [NSString stringWithFormat:@"%@@%@",_userProfile.glubbrUserId,xmppHostNameJidSubString]];
    
    
    predicate = [NSPredicate predicateWithFormat:@"(bareJidStr contains[cd] %@)", [NSString stringWithFormat:@"%@",ids]];
    
    NSPredicate *predicate1;
    predicate1 = [NSPredicate predicateWithFormat:@"isReadStr == 0"];
    
    NSPredicate *compound_predicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate,predicate1]];
    [request setPredicate:compound_predicate];
    
    
    //[request setPredicate:predicate];
    
    NSError *error;
    NSArray *messages_cd = [moc executeFetchRequest:request error:&error];
    if (messages_cd.count==0) {
        
    }else{
        XMPPMessageArchiving_Contact_CoreDataObject *message = messages_cd.firstObject;
        
        if ([message.isReadStr isEqualToString:@"0"]) {
            message.isReadStr= @"1";
            if ([[[XMPPhelper sharedInstance] managedObjectContext_messageArchive] hasChanges]) {
                [[[XMPPhelper sharedInstance] managedObjectContext_messageArchive] performBlock:^{
                    NSError *error1;
                    if ([[[XMPPhelper sharedInstance] managedObjectContext_messageArchive] save:&error1]) {
                        NSLog(@"contact updated to read");
                    }
                }];
                
            }
        }
    }
    
    
    
}


@end
