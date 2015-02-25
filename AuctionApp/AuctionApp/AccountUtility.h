//
//  AccountUtility.h
//  AuctionApp
//
//  Created by James Fazio on 2/24/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountUtility : NSObject

+ (void)login :(NSDictionary *) accountInfo;
+ (void)logout;
+ (void)setCode :(NSString *) code;
+ (NSString *)getCode;
+ (void)removeCode;
+ (NSString *)getName;
+ (NSString *)getId;
+ (BOOL) loggedIn;



@end
