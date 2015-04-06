#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject

// Send a GET request to the specified URL
// The callback passed in will be populated with a JSON object and an optional
// error message
+ (void) httpGET:(NSString *) urlStr :(void (^)(id json, NSString *error)) callback;

// Send a POST request to the specified URL with the specified body
// The callback passed in will be populated with a JSON object and an optional
// error message
+ (void) httpPOST:(NSString *) urlStr :(NSDictionary *) mapBody :(void (^)(id json, NSString *error)) callback;

@end
