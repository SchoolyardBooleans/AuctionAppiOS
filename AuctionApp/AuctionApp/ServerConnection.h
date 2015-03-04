#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject

+ (void) httpGET:(NSString *) urlStr :(void (^)(id, NSString *)) callback;
+ (void) httpPOST:(NSString *) urlStr :(NSDictionary *) mapBody :(void (^)(id, NSString *)) callback;


@end
