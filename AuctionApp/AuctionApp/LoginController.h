// View Controller for the Loign page

#import <UIKit/UIKit.h>
#import "RegisterModel.h"

@interface LoginController : UIViewController

@property (nonatomic) RegisterModel *model;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *invalidEmail;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)login:(id)sender;

@end
