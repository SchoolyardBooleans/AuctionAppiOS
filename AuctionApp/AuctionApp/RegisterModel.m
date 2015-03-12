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

-(void)confirmAccount:(NSString *)code :(void (^)(NSDictionary * , NSString *))callback {
    NSString *registerUrl = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/bidders";
    NSDictionary *body = [[NSMutableDictionary alloc] init];
    
    [body setValue:code forKey:@"code"];
    
    [ServerConnection httpPOST:registerUrl :body :^(id jsonDict, NSString *error) {
        NSDictionary *dict = [[NSMutableDictionary alloc] init];
        if (error != nil) {
            callback(dict, error);
        } else {
            if (jsonDict) {
                if ([jsonDict isKindOfClass:[NSDictionary class]]) {
                    dict = (NSDictionary *) jsonDict;
                } // ServerSide error if not true
            }
            
            callback(dict, nil);
        }
    }];
}

-(void)login:(NSString *)email :(void (^)(NSDictionary *, NSString *))callback {
    NSMutableString *registerUrl = [NSMutableString stringWithString: @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/login/"];
    [registerUrl appendString:email];
    
    [ServerConnection httpGET:registerUrl : ^(id jsonDict, NSString *error) {
        NSDictionary *dict = [[NSMutableDictionary alloc] init];
        
        if (error != nil) {
            callback(dict, error);
        } else {
            if (jsonDict) {
                if ([jsonDict isKindOfClass:[NSDictionary class]]) {
                    dict = (NSDictionary *) jsonDict;
                } // ServerSide error if not true 
            }
            
            callback(dict, nil);
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
