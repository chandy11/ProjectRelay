//
//  SignupViewController.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/9/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import "SignupViewController.h"
#import "BackendFunctions.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "User.h"
#import "IonIcons.h"
#import "RKDropdownAlert.h"
#import "kColorConstants.h"

@interface SignupViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *goToLoginButton;
@property (strong, nonatomic) UIAlertController *alert;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) IBOutlet UIImageView *addPhotoImageView;
@property (strong, nonatomic) UIImage *addPhotoImage;
@property (strong, nonatomic) NSURL *documents;
@property (strong, nonatomic) NSURL *filePath;

@property (strong, nonatomic) User *user;

@end


@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imagePicker = [UIImagePickerController new];
    
    [self setDelegates];
    [self hideKeyboard];
    [self.view bringSubviewToFront:_addPhotoImageView];
    
//    _addPhotoImageView.layer.cornerRadius = _addPhotoImageView.frame.size.width / 2;
//    _addPhotoImageView.clipsToBounds = YES;
    
    _addPhotoImageView.image = [UIImage imageNamed:@"profile"];
    
    [_addPhotoImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]]; // For border color
    [_addPhotoImageView.layer setBorderWidth:4.3]; // For Border width
    [_addPhotoImageView.layer setCornerRadius:45.0f]; // For Corner radious
    [_addPhotoImageView.layer setMasksToBounds:YES];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;

    UIButton *goToLoginButton = _goToLoginButton;
    UIButton *signUpButton = _signUpButton;
    goToLoginButton.backgroundColor = [kColorConstants pomogranateWithAlpha:1.0];
    signUpButton.backgroundColor = [kColorConstants pomogranateWithAlpha:1.0];
}

//------------------------------------------- User Signup Methods ---------------------------------------

#pragma
#pragma mark - Return Pressed Logic
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self signupLogic];
    [self hideKeyboard];
    return YES;
}

- (IBAction)signUpOnButtonPressed:(id)sender
{
    [self signupLogic];
    [self hideKeyboard];
}


//------------------------------------------- Navigation -----------------------------------------------

#pragma
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (IBAction)goToLogInViewControllerOnButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"toLoginSegue" sender:sender];
}


//------------------------------------------- Helper Methods --------------------------------------------

#pragma
#pragma mark - Hide Keyboard
- (void)hideKeyboard
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_confirmPasswordTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    _passwordTextField.secureTextEntry = YES;
    _confirmPasswordTextField.secureTextEntry = YES;
}

#pragma
#pragma mark - Delegate Setter
- (void)setDelegates
{
    _usernameTextField.delegate = self;
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
    _confirmPasswordTextField.delegate = self;
    _imagePicker.delegate = self;
}

#pragma
#pragma mark - Helper Methods
- (void)signupLogic
{
    if ([_emailTextField.text isEqualToString:@""])
    {
        _alert = [BackendFunctions showDataEntryError:@"Error" withMessage:@"You Forgot To Put A Email"];
        [self presentViewController:_alert animated:YES completion:nil];
    }
    else if ([_usernameTextField.text isEqualToString:@""])
    {
        _alert = [BackendFunctions showDataEntryError:@"Error" withMessage:@"You Forgot To Put A Username"];
        [self presentViewController:_alert animated:YES completion:nil];
    }
    else if([_passwordTextField.text isEqualToString:@""])
    {
        _alert = [BackendFunctions showDataEntryError:@"Error" withMessage:@"You Forgot To Put In Your Password"];
        [self presentViewController:_alert animated:YES completion:nil];
    }
    else if ([_confirmPasswordTextField.text isEqualToString:_passwordTextField.text] == [_confirmPasswordTextField.text isEqualToString:@""])
    {
        _alert = [BackendFunctions showDataEntryError:@"Error" withMessage:@"Passwords Don't Match Yo!"];
        [self presentViewController:_alert animated:YES completion:nil];
    }
    else
    {
        [BackendFunctions signupUser:_usernameTextField.text password:_passwordTextField.text email:_emailTextField.text onCompletion:^(BOOL success, NSError *error)
            {
                if (!error)
                {
                    NSLog(@"Signed up as %@", [User currentUser].username);
                    [self performSegueWithIdentifier:@"toMainSegue" sender:self];
                    NSLog(@"Shit Works");
                    
                    NSData *imageData = UIImagePNGRepresentation(_addPhotoImage);
                    PFFile *imageFile = [PFFile fileWithName:@"RelayProfilePicture.png" data:imageData];
                    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
                     {
                         if (!error || succeeded == YES)
                         {
                             User *user = [User currentUser];
                             user.profileImage = imageFile;
                             [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
                             {
                                 if (!error)
                                 {
                                     NSLog(@"Saving Images Work!");
                                 }
                                 else
                                 {
                                     NSLog(@"%@",error.localizedDescription);
                                 }
                             }];
                         }
                     }];
                }
                else
                {
                    NSString *errorString = [error userInfo][@"error"];
                    [BackendFunctions showDataEntryError:@"Error"
                                             withMessage:errorString];
                    
                    [RKDropdownAlert title:@"Problem Signing Up!"
                                   message:error.localizedDescription
                           backgroundColor:[UIColor redColor]
                                 textColor:[UIColor whiteColor]
                                      time:1.0];

                }
            }];
    }
}

//--------------------------------------- IMAGES & PICKER CONTROLLER ------------------------------------


- (IBAction)addPhotoOnButtonPressed:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take A Photo"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action)
                                      {
                                          [_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                                          [self presentViewController:_imagePicker animated:YES completion:nil];
                                      }];
    
    UIAlertAction *chooseFromLibrary = [UIAlertAction actionWithTitle:@"Choose From Library"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action)
                                        {
                                            [_imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                            [self presentViewController:_imagePicker animated:YES completion:nil];
                                        }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [alert addAction:takePhotoAction];
    [alert addAction:chooseFromLibrary];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    _addPhotoImage = image;
    _addPhotoImageView.image = _addPhotoImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

//------------------------------------------- Memory Warning --------------------------------------------

#pragma
#pragma mark - Alert View & Memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
