#ifndef Test_ServerConnection_h
#define Test_ServerConnection_h

#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject

//+ (id)getJSONData:(NSString*)urlStr;
+ (void) httpGET:(NSString *) urlStr :(void (^)(id, NSString *)) callback;
+ (void) httpPOST:(NSString *) urlStr :(NSDictionary *) mapBody :(void (^)(id, NSString *)) callback;


@end

#endif
