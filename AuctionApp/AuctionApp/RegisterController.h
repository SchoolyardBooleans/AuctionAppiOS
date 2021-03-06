// View Controller for the Register page

#import <UIKit/UIKit.h>
#import "RegisterModel.h"

@interface RegisterController : UIViewController
@property (nonatomic) RegisterModel *model;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
- (IBAction)confirmAction:(UIButton *)sender;
- (IBAction)registerAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *bottomErrorLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

