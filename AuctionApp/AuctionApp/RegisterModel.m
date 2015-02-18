//
//  Login.m
//  AuctionApp
//
//  Created by James Fazio on 2/16/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "RegisterModel.h"
#import "ServerConnection.h"

@implementation RegisterModel

-(void)registerAccount:(NSString *)firstName :(NSString *)lastName :(NSString *)email :(void (^)(BOOL, NSString *)) callback {
    NSString *registerUrl = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/register";
    NSDictionary *body = [[NSMutableDictionary alloc] init];
    
    [body setValue:firstName forKey:@"first"];
    [body setValue:lastName forKey:@"last"];
    [body setValue:email forKey:@"email"];
    
    [ServerConnection httpPOST:registerUrl :body :^(id JSON, NSString *error) {
        if (error != nil) {
            callback(NO, error);
        } else {
            callback(YES, nil);
        }
    }];
}

-(void)confirmAccount:(NSString *)code :(void (^)(BOOL, NSString *))callback {
    NSString *registerUrl = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/bidders";
    NSDictionary *body = [[NSMutableDictionary alloc] init];
    
    [body setValue:code forKey:@"code"];
    
    [ServerConnection httpPOST:registerUrl :body :^(id JSON, NSString *error) {
        if (error != nil) {
            callback(NO, error);
        } else {
            callback(YES, nil);
        }
    }];
}

-(BOOL)validate:(NSString *)firstName :(NSString *)lastName :(NSString *)email {
    return [self isValidName:firstName]
        && [self isValidName:lastName]
        && [self isValidEmail:email];
    
}

-(BOOL) isValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL ret = [checkString length] != 0 && [emailTest evaluateWithObject:checkString];
    
    return ret;
}

-(BOOL) isValidName:(NSString *) checkString {
    NSString *nameRegex = @"^[\\p{L}\\s'.-]+$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    
    BOOL ret = [checkString length] != 0 && [nameTest evaluateWithObject:checkString];
    
    return ret;
}

@end
