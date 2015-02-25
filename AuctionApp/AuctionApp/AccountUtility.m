//
//  AccountUtility.m
//  AuctionApp
//
//  Created by James Fazio on 2/24/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "AccountUtility.h"

@implementation AccountUtility

+ (void) setCode :(NSString *) code {
    [[NSUserDefaults standardUserDefaults] setValue:code forKey:@"code"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) login:(NSDictionary *)accountInfo {
    [[NSUserDefaults standardUserDefaults] setValue:[accountInfo valueForKey:@"Id"] forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setValue:[accountInfo valueForKey:@"first"] forKey:@"firstName"];
    [[NSUserDefaults standardUserDefaults] setValue:[accountInfo valueForKey:@"last"] forKey:@"lastName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"firstName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) getCode {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"code"];
}

+ (void) removeCode {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"code"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) getId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}

+(NSString *) getName {
    NSMutableString *name = [NSMutableString stringWithString:
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"firstName"]];
    
    [name appendString:@" "];
    [name appendString:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastName"]];
    
    return name;
}

+(BOOL) loggedIn {
    if ([self getId] != nil) {
        return YES;
    } else {
        return NO;
    }
}





@end
