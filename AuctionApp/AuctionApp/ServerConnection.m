//
//  ServerConnection.m
//  Test
//
//  Created by Jon Vazquez on 11/30/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import "ServerConnection.h"

@implementation ServerConnection

+ (id)getJSONData:(NSString*)urlStr
{
    // URL vars
    NSURL * url = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [urlRequest setHTTPMethod:@"GET"];
    
    // JSON vars
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    return urlData;
}

@end