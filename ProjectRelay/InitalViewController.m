//
//  InitalViewController.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 1/2/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "InitalViewController.h"
#import "SignupViewController.h"
#import "LoginViewController.h"
#import "kColorConstants.h"

@interface InitalViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation InitalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *loginButton = _loginButton;
    UIButton *signupButton = _signupButton;
    loginButton.backgroundColor = [kColorConstants pomogranateWithAlpha:1.0];
    signupButton.backgroundColor = [kColorConstants pomogranateWithAlpha:1.0];
    UIImage *image = [UIImage imageNamed:@"logo"];
    _imageView.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}


@end
