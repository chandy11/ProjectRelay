//
//  LoginViewController.m
//  
//
//  Created by Irwin Gonzales on 12/9/15.
//
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "BackendFunctions.h"
#import "RKDropDownAlert.h"
#import "User.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) UIAlertController *alert;
@property (strong, nonatomic) User *user;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDelegates];
    [self hideKeyboard];


    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

//------------------------------------------- User Login Methods ---------------------------------------

#pragma
#pragma mark - Return Pressed Logic
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loginLogic];
    [self hideKeyboard];
    return YES;
}

- (IBAction)loginUserOnButtonPressed:(UIButton *)sender
{
    [self loginLogic];
}

//------------------------------------------- Navigation -----------------------------------------------

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (IBAction)toSignUpViewControllerOnButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"toSignUpSegue" sender:sender];
}

//------------------------------------------- Helper Methods --------------------------------------------

#pragma
#pragma mark - Hide Keyboard
- (void)hideKeyboard
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    self.passwordTextField.secureTextEntry = YES;
}

#pragma
#pragma mark - Delegate Setter
- (void)setDelegates
{
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

//- (void)showLoggedOutMessage
//{
//    if (![User currentUser])
//    {
//        [RKDropdownAlert show];
//        [RKDropdownAlert title:@"You Logged Out" message:@"Come Back Soon!" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor]];
//    }
//}

#pragma
#pragma mark - Login
- (void)loginLogic
{
    if ([_usernameTextField.text isEqualToString:@""])
    {
        _alert = [BackendFunctions showDataEntryError:@"Error" withMessage:@"You Forgot To Put A Username"];
        [self presentViewController:_alert animated:YES completion:nil];
    }
    else if ([_passwordTextField.text isEqualToString:@""])
    {
        _alert = [BackendFunctions showDataEntryError:@"Error" withMessage:@"You Forgot To Put A Password"];
        [self presentViewController:_alert animated:YES completion:nil];
    }
    else
    {
        [PFUser logInWithUsernameInBackground:_usernameTextField.text password:_passwordTextField.text block:^(PFUser *user, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"Signed In As %@", [PFUser currentUser].username);
                 [self performSegueWithIdentifier:@"fromLoginSegue" sender:self];
             }
             else
             {
                 NSString *errorString = [error userInfo][@"error"];
                 NSLog(@"%@", errorString);
                 [RKDropdownAlert title:@"Problem Logging In!"
                                message:error.localizedDescription
                        backgroundColor:[UIColor redColor]
                              textColor:[UIColor whiteColor]
                                   time:1.0];
             }
         }];
    }
}

//------------------------------------------- Memory Warning --------------------------------------------

#pragma
#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
