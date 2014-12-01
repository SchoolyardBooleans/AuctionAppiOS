//
//  ServerConnection.h
//  Test
//
//  Created by Jon Vazquez on 11/30/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#ifndef Test_ServerConnection_h
#define Test_ServerConnection_h

#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject

+ (id)getJSONData:(NSString*)urlStr;

@end

#endif
