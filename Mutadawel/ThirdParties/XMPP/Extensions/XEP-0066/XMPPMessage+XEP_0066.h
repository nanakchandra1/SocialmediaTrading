#import "XMPPMessage.h"

@interface XMPPMessage (XEP_0066)

- (void)addOutOfBandURL:(NSURL *)URL desc:(NSString *)desc;
- (void)addOutOfBandURI:(NSString *)URI desc:(NSString *)desc;
- (void)addOutOfBandURI:(NSString *)URI desc:(NSString *)desc businessId:(NSString*)businessId;
- (BOOL)hasOutOfBandData;
- (NSXMLElement *)OutOfBandData;
- (NSURL *)outOfBandURL;
- (NSString *)outOfBandURI;
- (NSString *)outOfBandDesc;
- (NSString *)outOfBandBusinessId;

@end
