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

@interface InitalViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end

@implementation InitalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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
