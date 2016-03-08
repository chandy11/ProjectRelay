//
//  PrivacyViewController.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/13/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import "PrivacyViewController.h"
#import "kColorConstants.h"
#import "UIAssets.h"

@interface PrivacyViewController ()

@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    // Do any additional setup after loading the view.
}

- (void)setNavBar
{
    [UIAssets setupNavbarOnNavbar:self.navigationController onNavigationItem:self.navigationItem];
}

- (void)didReceiveMemoryWarning {
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
