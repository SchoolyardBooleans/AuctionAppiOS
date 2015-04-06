// Contains methods related to registering accounts and logging int

#import <Foundation/Foundation.h>

@interface RegisterModel : NSObject

// Make sure registration information is valid for sending.
-(BOOL) validatefirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *) email;

// Register an account, takes in the account information and a callback
// that populates a boolean if the operation was successful and an optional error message.
-(void) registerAccountwithFirstName:(NSString *) firstName lastName:(NSString *)lastName email:(NSString*) email callback:(void (^)(BOOL, NSString *)) callback;

// Make sure the code for a newly created account matches the code provided.
// Takes in the code and a callback that populates a dictionary with the id, name, and last name
// of the registered user along with an optional error message.
-(void) confirmAccountwithCode:(NSString *) code callback:(void (^)(NSDictionary *, NSString *)) callback;

// Log the user in based off of the email provided. Takes in a callback that
// populates a dictionary with the id, name, and last name of the registered user
// along with an optional error message.
-(void) loginWithEmail:(NSString *) email callback:(void (^)(NSDictionary *, NSString *)) callback;

@end
