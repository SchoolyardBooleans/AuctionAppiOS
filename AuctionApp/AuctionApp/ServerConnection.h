#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject

extern int const TIMEOUT;

+ (void) httpGET:(NSString *) urlStr :(void (^)(id json, NSString *error)) callback;
+ (void) httpPOST:(NSString *) urlStr :(NSDictionary *) mapBody :(void (^)(id json, NSString *error)) callback;

@end
