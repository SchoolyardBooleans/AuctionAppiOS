//
//  RegisterController.h
//  AuctionApp
//
//  Created by James Fazio on 2/16/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

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
@end

