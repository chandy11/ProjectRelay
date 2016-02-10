//
//  EditProfileViewController.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/13/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import "EditProfileViewController.h"
#import "BackendFunctions.h"
#import "User.h"
#import <Parse/Parse.h>
#import "kColorConstants.h"


@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) UIImage *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) UIAlertController *alert;

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) User *user;

@end

@implementation EditProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _imagePicker = [UIImagePickerController new];
    _imagePicker.delegate = self;
    UIButton *submitButton = _submitButton;
    submitButton.backgroundColor = [kColorConstants pomogranateWithAlpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitChangesOnButtonPressed:(UIButton *)sender
{
    [BackendFunctions saveChangesOnUserProfile:_usernameTextField.text email:_emailTextField.text password:_passwordTextField.text onCompletion:^(BOOL success, NSError *error)
    {
        if (!error)
        {
            NSLog(@"Yay! It Worked");
            if (_profileImageView.image == _profileImage)
            {
                NSData *imageData = UIImagePNGRepresentation(_profileImage);
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
                NSLog(@"Nothing is saved");
            }
            _alert = [BackendFunctions showSuccessEntrywithMessage:@"Geat!"];
            [self presentViewController:_alert animated:YES completion:nil];
        }
        else
        {
            NSLog(@"Something Went Wrong %@", error.localizedDescription);
            _alert = [BackendFunctions showDataEntryError:@"Uh Oh" withMessage:error.localizedDescription];
            [self presentViewController:_alert animated:YES completion:nil];
        }
    }];
}

- (IBAction)changeUserProfileImage:(UIButton *)sender
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
    _profileImage = image;
    _profileImageView.image = _profileImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a litt preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
