//
//  Login.h
//  AuctionApp
//
//  Created by James Fazio on 2/16/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterModel : NSObject

-(BOOL) validate:(NSString *)firstName :(NSString *)lastName :(NSString *) email;
-(void) registerAccount:(NSString *) firstName :(NSString *)lastName :(NSString*) email :(void (^)(BOOL, NSString *)) callback;
-(void) confirmAccount:(NSString *) code :(void (^)(NSDictionary *, NSString *)) callback;

@end
