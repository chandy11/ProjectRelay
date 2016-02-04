//
//  RootNavigationController.m
//  
//
//  Created by Irwin Gonzales on 12/8/15.
//
//

#import "RootNavigationController.h"
#import "DailyRitualViewController.h"
#import "NewsFeedViewController.h"
#import "SearchViewController.h"
#import "SettingsViewController.h"
#import "AddNewsViewController.h"
#import <M13InfiniteTabBar/M13InfiniteTabBarController.h>

@interface RootNavigationController () <M13InfiniteTabBarControllerDelegate>

@end

@implementation RootNavigationController


#pragma
#pragma mark - Loading Stuff
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    M13InfiniteTabBarController *tbc = self.viewControllers[0];
    tbc.delegate = self;
}

#pragma
#pragma mark - Delegate Methods
-(NSArray *)infiniteTabBarControllerRequestingViewControllersToDisplay:(M13InfiniteTabBarController *)tabBarController
{
    UIStoryboard *storyBoard = self.storyboard;

    NewsFeedViewController *vc1 = [storyBoard instantiateViewControllerWithIdentifier:@"SearchVC"];
    SearchViewController *vc2 = [storyBoard instantiateViewControllerWithIdentifier:@"NewsfeedVC"];
    SettingsViewController *vc3 = [storyBoard instantiateViewControllerWithIdentifier:@"SettingsVC"];
    AddNewsViewController *vc4 = [storyBoard instantiateViewControllerWithIdentifier:@"AddNewsVC"];

    UINavigationController *nc5 = [storyBoard instantiateViewControllerWithIdentifier:@"NavigationVC"];
    DailyRitualViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"DailyRitualVC"];
    [nc5 pushViewController:vc animated:NO];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Go Home" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, ([UIScreen mainScreen].bounds.size.height / 2.0), [UIScreen mainScreen].bounds.size.width - 40, 30);
    button.backgroundColor = [UIColor colorWithWhite:1 alpha:3];
    //[button addTarget:vc action:@selector(gotoWorld:) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:button];
    vc.infiniteTabBarController = tabBarController;

    [nc5 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Rituals" selectedIconMask:[UIImage imageNamed:@"tab3solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab3Line.png"]]];

    [vc1 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Search" selectedIconMask:[UIImage imageNamed:@"tab2solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab2Line.png"]]];

    [vc3 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Settings" selectedIconMask:[UIImage imageNamed:@"Settings Filled-25.png"] unselectedIconMask:[UIImage imageNamed:@"Settings-25.png"]]];

    [vc2 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"News" selectedIconMask:[UIImage imageNamed:@"Google News-25.png"] unselectedIconMask:[UIImage imageNamed:@"Google News Filled-25.png"]]];
    
    [vc4 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Add News" selectedIconMask:[UIImage imageNamed:@"Plus Filled-25.png"] unselectedIconMask:[UIImage imageNamed:@"Plus 50.png"]]];

    return @[vc1, vc2, vc3, vc4, nc5];
}

- (BOOL)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController shouldSelectViewContoller:(UIViewController *)viewController
{
    if ([viewController.title isEqualToString:@"Search"]) { //Prevent selection of first view controller
        return NO;
    } else {
        return YES;
    }
}

-(void)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

}

#pragma
#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
