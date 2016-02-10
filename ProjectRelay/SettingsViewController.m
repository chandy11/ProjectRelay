//
//  SettingsViewController.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/8/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import "SettingsViewController.h"
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>
#import "BackendFunctions.h"
#import "kColorConstants.h"


@interface SettingsViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UIButton *privacyButton = _privacyButton;
    UIButton *contactButton = _contactButton;
    UIButton *editProfileButton = _editProfileButton;
    UIButton *logOutButton = _logOutButton;

    [privacyButton setTitleColor:[kColorConstants pomogranateWithAlpha:1.0] forState:UIControlStateNormal];
    [privacyButton setTitleColor:[kColorConstants pomogranateWithAlpha:1.0] forState:UIControlStateHighlighted];
    [contactButton setTitleColor:[kColorConstants pomogranateWithAlpha:1.0] forState:UIControlStateNormal];
    [contactButton setTitleColor:[kColorConstants pomogranateWithAlpha:1.0] forState:UIControlStateHighlighted];
    [editProfileButton setTitleColor:[kColorConstants pomogranateWithAlpha:1.0] forState:UIControlStateNormal];
    [editProfileButton setTitleColor:[kColorConstants pomogranateWithAlpha:1.0] forState:UIControlStateHighlighted];
    [logOutButton setTitleColor:[kColorConstants pomogranateWithAlpha:1.0] forState:UIControlStateNormal];
    [logOutButton setTitleColor:[kColorConstants pomogranateWithAlpha:1.0] forState:UIControlStateHighlighted];

}

- (IBAction)sendEmailAction:(UIButton *)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Talk To Us!"];
        [mail setMessageBody:@"Reporting a problem? Have something great to say? Want to say hi? Just drop your line here!" isHTML:NO];
        [mail setToRecipients:@[@"irwin@newdesto.com"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)userLoggedOutOnButtonPressed:(UIButton *)sender
{
    //[BackendFunctions logoutUser];
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error)
    {
        if (!error)
        {
            [self performSegueWithIdentifier:@"loggedOutSegue" sender:sender];

        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
