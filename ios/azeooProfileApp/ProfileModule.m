#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ProfileModule, NSObject)

RCT_EXTERN_METHOD(openProfileScreen:(NSInteger)userId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

@end
