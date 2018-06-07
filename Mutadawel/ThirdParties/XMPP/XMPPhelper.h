//

//

#import "XMPPFramework.h"
#import "XMPP.h"

#define xmppHostPort 5222
#define xmppHostName @"tridder.net"
#define xmppHostNameJidSubString @"tridder.net"

//#define xmppHostName @"glubbr.com"
//#define xmppHostNameJidSubString @"glubbr.com"

@protocol sendUnreadCount <NSObject>
@optional
-(void)receiveCount:(int)count;
@end

@interface XMPPhelper : NSObject <XMPPRosterDelegate,XMPPStreamDelegate> {
    
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;
    XMPPMessageDeliveryReceipts *xmppMessageDR;
    XMPPMUC *xmppmuc;
    
    XMPPMultiCast *xmppMulti;
    BOOL allowSelfSignedCertificates;
    BOOL allowSSLHostNameMismatch;
    BOOL isXmppConnected;
}

@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *currentOtherUser;

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, strong, readonly) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;
@property (nonatomic, strong, readonly) XMPPMessageArchiving *xmppMessageArchivingModule;
@property (nonatomic, strong) XMPPMUC *xmppmuc;
@property (nonatomic, strong, readonly) XMPPMultiCast *xmppMulti;

@property(nonatomic,strong,readonly)XMPPAutoTime *autoTImeModule;
@property(nonatomic,strong,readonly)XMPPTime *xmppTimeVar;
@property (nonatomic, strong)XMPPStreamManagement *streamManagement;
@property (nonatomic, strong)XMPPAutoPing *xmppAutoPing;
@property(weak,nonatomic)UIViewController* chatViewController;
+ (XMPPhelper *)sharedInstance;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (NSManagedObjectContext *)managedObjectContext_messageArchive;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator_messageArchive;
- (NSManagedObjectModel *)managedObjectModel_messageArchive;
-(XMPPUserCoreDataStorageObject *)getUserCoreDataObjectForUserId:(NSString*)userId;
- (bool)connect;
- (void)disconnect;
- (void)setupStream;
- (void)teardownStream;
- (void)goOnline;
- (void)goOffline;
-(NSString*)getXmppHostNameJidSubString;
-(NSString*)getXmppHostName;
-(void)setScreenTitle:(__weak UIViewController*)vc;
-(NSInteger)getUnreadMessageContactForHome;
-(NSArray*)getMessagesForUserId:(NSString*)userId;
-(void)sendStatusAsDisplayedForMessagesForUserId:(NSString*)userId;
-(void)sendStatusAsDisplayedForMessagesForUserId:(NSString*)userId forBusiness:(NSString*)busId;
-(void)deleteOtherBusinessThread:(NSString*) businessID;
-(void)setReadForIDS:(NSString*)ids;
    
@end
