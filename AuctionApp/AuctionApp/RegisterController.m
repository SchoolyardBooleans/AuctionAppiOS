#import "RegisterController.h"
#import "AccountUtility.h"
#import "AppDelegate.h"
#import "Constants.h"
#import <SalesforceSDKCore/SFPushNotificationManager.h>

@implementation RegisterController {
    UITextField *activeField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // For now creates own model, will change
    self.model = [[RegisterModel alloc] init];
    self.confirmView.hidden = YES;
    self.errorLabel.hidden = YES;
    self.bottomErrorLabel.hidden = YES;
    
    self.registerButton.backgroundColor = UIColorFromRGB(0x067AB5);
    self.registerButton.layer.cornerRadius = 5;
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.confirmButton.backgroundColor = UIColorFromRGB(0x067AB5);
    self.confirmButton.layer.cornerRadius = 5;
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self registerForKeyboardNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadCodeIfPresent)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Keyboard Events

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

// Register for keyboard notifications
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    // When user clicks on screen close keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

// Close keyboard on click
-(void)dismissKeyboard {
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.codeField resignFirstResponder];
    [self.emailField resignFirstResponder];
}

//Close keyboard on return/done press
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


#pragma TextField Delegate

// Set active textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

// Release active textfield
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

#pragma Actions

- (IBAction)confirmAction:(UIButton *)sender {
    NSString *code = self.codeField.text;
    
    [self.model confirmAccountwithCode:code callback:^(NSDictionary *dict, NSString *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL success = [[dict valueForKey:@"success"] boolValue];
            if (error != nil || success == NO) {
                self.bottomErrorLabel.text = error != nil ? error : @"Invalid code";
                self.bottomErrorLabel.hidden = NO;
            } else {
                AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [AccountUtility removeCode];
                [AccountUtility login: dict];
                
                NSLog(@"Trying to register for notifications...");
                [[SFPushNotificationManager sharedInstance]
                 registerForRemoteNotifications];
                [appdelegate switchToAccountView];
                NSLog(@"Success logging in");
            }
        });
        
    }];
}

- (IBAction)registerAction:(UIButton *)sender {
    NSString *firstName = self.firstNameField.text;
    NSString *lastName = self.lastNameField.text;
    NSString *email = self.emailField.text;
    
    if ([self.model validatefirstName:firstName lastName:lastName email:email]) {
        [self.emailField resignFirstResponder];
        self.errorLabel.hidden = true;
        
        [self.model registerAccountwithFirstName:firstName lastName:lastName email:email callback:^(BOOL success, NSString *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error != nil || success == NO) {
                    self.errorLabel.text = error != nil ? error : @"An account with this email already exists";
                    self.errorLabel.hidden = NO;
                } else {
                    self.errorLabel.hidden = YES;
                    self.confirmView.hidden = NO;
                }
            });
        }];
        
    } else {
        self.errorLabel.text = @"Error: Invalid name or email";
        self.errorLabel.hidden = false;
    }
    
}

#pragma Other

-(void)loadCodeIfPresent {
    NSString *code = [AccountUtility getCode];
    
    if (code != nil) {
        [self.codeField setText:code];
    }
}

@end
