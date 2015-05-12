#import "RegisterModel.h"
#import "ServerConnection.h"
#import "Constants.h"

@implementation RegisterModel

-(void)registerAccountwithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email callback:(void (^)(BOOL, NSString *)) callback {
    NSString *registerUrl = REGISTER_URL;
    NSDictionary *body = [[NSMutableDictionary alloc] init];
    
    [body setValue:firstName forKey:@"first"];
    [body setValue:lastName forKey:@"last"];
    [body setValue:email forKey:@"email"];
    
    [ServerConnection httpPOST:registerUrl :body :^(id JSON, NSString *error) {
        NSDictionary *dict = (NSDictionary *) JSON;
        BOOL success = [[dict valueForKey:SUCCESS_KEY] boolValue];
        
        // Error present
        if (error != nil || success == NO) {
            callback(NO, error);
        } else { // Success
            callback(YES, nil);
        }
    }];
}

-(void)confirmAccountwithCode:(NSString *)code callback:(void (^)(NSDictionary * , NSString *))callback {
    NSString *registerUrl = BIDDER_URL;
    NSDictionary *body = [[NSMutableDictionary alloc] init];
    
    [body setValue:code forKey:@"code"];
    
    [ServerConnection httpPOST:registerUrl :body :^(id jsonDict, NSString *error) {
        NSDictionary *dict = [[NSMutableDictionary alloc] init];
        // Error present
        if (error != nil) {
            callback(dict, error);
        } else {
            if (jsonDict) {
                // Valid return type
                if ([jsonDict isKindOfClass:[NSDictionary class]]) {
                    dict = (NSDictionary *) jsonDict;
                } // ServerSide error if not true
            }
            
            callback(dict, nil);
        }
    }];
}

-(void)loginWithEmail:(NSString *)email callback:(void (^)(NSDictionary *, NSString *))callback {
    NSMutableString *registerUrl = [NSMutableString stringWithString: LOGIN_URL];
    [registerUrl appendString:@"/"];
    [registerUrl appendString:email];
    
    [ServerConnection httpGET:registerUrl : ^(id jsonDict, NSString *error) {
        NSDictionary *dict = [[NSMutableDictionary alloc] init];
        
        // Error present
        if (error != nil) {
            callback(dict, error);
        } else {
            if (jsonDict) {
                // Valid return type
                if ([jsonDict isKindOfClass:[NSDictionary class]]) {
                    dict = (NSDictionary *) jsonDict;
                } // ServerSide error if not true 
            }
            
            callback(dict, nil);
        }
    }];
}

-(BOOL)validatefirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email {
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
