#import "AccountUtility.h"
#import "Constants.h"

@implementation AccountUtility

+ (void) setCode :(NSString *) code {
    [[NSUserDefaults standardUserDefaults] setValue:code forKey:USER_CODE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) login:(NSDictionary *)accountInfo {
    [[NSUserDefaults standardUserDefaults] setValue:[accountInfo valueForKey:@"Id"] forKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:[accountInfo valueForKey:@"first"] forKey:USER_FIRST_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:[accountInfo valueForKey:@"last"] forKey:USER_LAST_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_FIRST_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_LAST_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) getCode {
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_CODE_KEY];
}

+ (void) removeCode {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_CODE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) getId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY];
}

+(NSString *) getName {
    NSMutableString *name = [NSMutableString stringWithString:
                             [[NSUserDefaults standardUserDefaults] objectForKey:USER_FIRST_KEY]];
    
    [name appendString:@" "];
    [name appendString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_LAST_KEY]];
    
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
