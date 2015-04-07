// Utility class for saving app preferences

#import <Foundation/Foundation.h>

@interface AccountUtility : NSObject

// Takes in accountInfo containing the user Id, first, and last
// name and saves these fields.
+ (void)login :(NSDictionary *) accountInfo;

// Remove id, first, and last name from preferences.
+ (void)logout;

// Takes in the registration code and sets it.
+ (void)setCode :(NSString *) code;

// Retrieve the registration code from preferences
+ (NSString *)getCode;

// Remove the registration code from preferences
+ (void)removeCode;

// Retrieve the user's first and last name from preferences
+ (NSString *)getName;

// Retrieve the user's id from preferences
+ (NSString *)getId;

// Check whether a user is logged in or not
+ (BOOL) loggedIn;

@end
