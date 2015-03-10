#import "ServerConnection.h"

int const TIMEOUT = 30;

@implementation ServerConnection

// Send a GET request to the specified URL
// The callback passed in will be populated with a JSON object and an optional error message
+(void) httpGET:(NSString *) urlStr :(void (^)(id json, NSString *error)) callback {
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUT];
    [request setHTTPMethod:@"GET"];
    [self httpSendRequest:request :callback];
}

// Send a POST request to the specified URL with the specified body
// The callback passed in will be populated with a JSON object and an optional error message
+(void) httpPOST:(NSString *) urlStr :(NSDictionary *) mapBody :(void (^)(id json, NSString *error)) callback {
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUT];
    NSError *error;
    // No error checking on this
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapBody options:0 error:&error];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    [self httpSendRequest:request :callback];
    
}

// Send a request and return the JSON response
// The callback passed in will be populated with a JSON object and an optional error message
+(void) httpSendRequest:(NSMutableURLRequest *) request :(void (^)(id json, NSString *error)) callback {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            callback(@"", [error localizedDescription]);
        } else {
            NSError *jsonError;
            id json = [NSJSONSerialization JSONObjectWithData:data
                                                      options:0
                                                        error:&jsonError];
            
            if (jsonError != nil) {
                callback(@"", @"Error parsing json response!");
            } else {
                callback(json, nil);
            }
        }
    }];
    
    [task resume];
}


@end