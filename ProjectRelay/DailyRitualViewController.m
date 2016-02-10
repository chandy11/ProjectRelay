//
//  ViewController.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 11/23/15.
//  Copyright (c) 2015 Irwin Gonzales. All rights reserved.
//

#import "DailyRitualViewController.h"
#import "M13InfiniteTabBarController.h"
#import "M13InfiniteTabBarItem.h"
#import "SearchWebViewController.h"
#import "WebArticleViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Article.h"
#import "MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "ArticleTableViewCell.h"
#import "kColorConstants.h"
#import "ProfileViewController.h"

@interface DailyRitualViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) UIImage *articleImage;
@property (strong, nonatomic) NSMutableArray *likesArray;
@property (strong, nonatomic) NSMutableArray *followingArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSData *userProfileData;
@property (strong, nonatomic) Article *articles;
@property (strong, nonatomic) User *user;

@end

@implementation DailyRitualViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _likesArray = [[NSMutableArray alloc]init];
    _followingArray = [[NSMutableArray alloc]init];
    
    //[_profileImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]]; // For border color
    [_profileImageView.layer setBorderColor:[[kColorConstants silverWithAlpha:1.0] CGColor]];
    [_profileImageView.layer setBorderWidth:4.3]; // For Border width
    [_profileImageView.layer setCornerRadius:45.0f]; // For Corner radious
    [_profileImageView.layer setMasksToBounds:YES];
    
    [self getUserImage];
    [self userLikesQuery];
    [self userFollowingQuery];
    [_tableView reloadData];
    [self setNavBar];
    [self useRefreshControl];
    
}

#pragma
#pragma mark - UI Eelements


- (void)setNavBar
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:20.0f]                                                                      }];
    [self.navigationController.navigationBar setBackgroundColor:[kColorConstants pomogranateWithAlpha:1.0]];
    [self.navigationItem setTitle: @"Relay"];
}

- (void)useRefreshControl
{
    _refreshControl = [UIRefreshControl new];
    _refreshControl.backgroundColor = [kColorConstants pomogranateWithAlpha:1.0];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(userLikesQuery) forControlEvents:UIControlEventValueChanged];
}

#pragma
#pragma mark - Index Button Pressed Logic
- (IBAction)indexChanged:(id)sender
{
    switch (_segmentControl.selectedSegmentIndex)
    {
        case 0:
            
            [self userLikesQuery];
            
            break;
            
        default:
            
            [self userFollowingQuery];
            
            break;
    }
}

#pragma
#pragma mark - Refreshes & Queries
- (void)reloadTableView
{
    //Reloads data into array and stops refreshing
    [_tableView reloadData];
    [_refreshControl endRefreshing];
}

- (void)getUserImage
{
    User *cUser = [User currentUser];
    
    PFFile *userPhoto = [cUser objectForKey:@"profileImage"];
    [userPhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error)
     {
         if (!error)
         {
             _profileImage = [UIImage imageWithData:data];
             _profileImageView.image = _profileImage;
         }
         else
         {
             NSLog(@"%@", error.localizedDescription);
            [RKDropdownAlert title:@"Something Went Wrong!"
                           message:error.localizedDescription
                   backgroundColor:[UIColor redColor]
                         textColor:[UIColor whiteColor]
                              time:1.0];
             
         }
     }];
}

- (void)userLikesQuery
{
    User *cUser = [User currentUser];
    PFRelation *relationQuery = [cUser relationForKey:@"likedArticles"];
    PFQuery *query = [relationQuery query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            _likesArray = [NSMutableArray arrayWithArray:objects];
            NSLog(@"everything is passed %@",_likesArray);
            [_refreshControl endRefreshing];
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
            [RKDropdownAlert title:@"Something Went Wrong!"
                           message:error.localizedDescription
                   backgroundColor:[UIColor redColor]
                         textColor:[UIColor whiteColor]
                              time:1.0];
        }
        [_tableView reloadData];
    }];
    
}

-(void)userFollowingQuery
{
    User *cUser = [User currentUser];
    PFRelation *followingRelation = [cUser relationForKey:@"following"];
    PFQuery *query = [followingRelation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            _followingArray = [NSMutableArray arrayWithArray:objects];
            NSLog(@"We got your folllowing %@",_followingArray);
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
            [RKDropdownAlert title:@"Something Went Wrong!"
                           message:error.localizedDescription
                   backgroundColor:[UIColor redColor]
                         textColor:[UIColor whiteColor]
                              time:1.0];
        }
        [_tableView reloadData];
    }];
}

#pragma
#pragma mark - UI Tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (_segmentControl.selectedSegmentIndex == 0)
    {
        _articles = [_likesArray objectAtIndex:indexPath.row];
        
        PFFile *file = _articles.articleImage;
        [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error)
         {
             if (!error)
             {
                 UIImage *image = [UIImage imageWithData:data];
                 cell.articleImage.image = image;
                 [cell.articleImage.layer setBorderColor:[[kColorConstants cloudsWithAlpha:1.0]CGColor]];
                 [cell.articleImage.layer setBorderWidth:4.3];
                 [cell.articleImage.layer setCornerRadius:30.0f];
                 [cell.articleImage.layer setMasksToBounds:YES];
             }
             else
             {
                 NSLog(@"%@",error.localizedDescription);
                 [RKDropdownAlert title:@"Something Went Wrong!"
                                message:error.localizedDescription
                        backgroundColor:[UIColor redColor]
                              textColor:[UIColor whiteColor]
                                   time:1.0];
             }
             
         }
                             progressBlock:^(int percentDone)
         {
             //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];;
         }];
        
        
        cell.titleLable.text = _articles.title;
        cell.usernameLabel.text = @""; 
        cell.descriptionLabel.text = _articles.descriptionText;
        cell.backgroundColor = [UIColor lightGrayColor];

    }
    else
    {
        _user = [_followingArray objectAtIndex:indexPath.row];
        
        PFFile *file = _user.profileImage;
        [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error)
        {
            if (!error)
            {
                UIImage *image = [UIImage imageWithData:data];
                cell.articleImage.image = image;
                [cell.articleImage.layer setBorderColor:[[kColorConstants cloudsWithAlpha:1.0]CGColor]];
                [cell.articleImage.layer setBorderWidth:4.3];
                [cell.articleImage.layer setCornerRadius:30.0f];
                [cell.articleImage.layer setMasksToBounds:YES];
            }
            else
            {
                NSLog(@"%@", error.localizedDescription);
                [RKDropdownAlert title:@"Something Went Wrong!"
                               message:error.localizedDescription
                       backgroundColor:[UIColor redColor]
                             textColor:[UIColor whiteColor]
                                  time:1.0];
            }
        }];
        
        cell.titleLable.text = @"";
        cell.usernameLabel.text = _user.username;
        cell.descriptionLabel.text = @"";
        cell.backgroundColor = [UIColor lightGrayColor];
    }

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_segmentControl.selectedSegmentIndex == 0 )
    {
        return _likesArray.count;
    }
    else
    {
        return _followingArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segmentControl.selectedSegmentIndex == 0)
    {
        return 100;
    }
    else
    {
        return 100;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && _segmentControl.selectedSegmentIndex == 0)
    {
        User *cUser = [User currentUser];
        _articles = [_likesArray objectAtIndex:indexPath.row];
        PFRelation *relationQuery = [cUser relationForKey:@"likedArticles"];
        [relationQuery removeObject:_articles];
        [cUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
        {
            if (!error)
            {
                [_likesArray removeObjectAtIndex:indexPath.row];
                [_tableView reloadData];
                NSLog(@"Data removed");
            }
            else
            {
                [RKDropdownAlert title:@"Something Went Wrong!"
                               message:error.localizedDescription
                       backgroundColor:[UIColor redColor]
                             textColor:[UIColor whiteColor]
                                  time:1.0];
            }
        }];
    }
    else
    {
        User *cUser = [User currentUser];
        _user = [_followingArray objectAtIndex:indexPath.row];
        PFRelation *relationQuery = [cUser relationForKey:@"following"];
        [relationQuery removeObject:_user];
        [cUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
        {
            if (!error)
            {
                [_followingArray removeObjectAtIndex:indexPath.row];
                [_tableView reloadData];
                NSLog(@"User Unfollowed");
            }
            else
            {
                [RKDropdownAlert title:@"Something Went Wrong!"
                               message:error.localizedDescription
                       backgroundColor:[UIColor redColor]
                             textColor:[UIColor whiteColor]
                                  time:1.0];
            }
        }];
    }
}

#warning Add segue to profile view for user
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segmentControl.selectedSegmentIndex == 0)
    {
        Article *article = _likesArray[indexPath.row];
        [self performSegueWithIdentifier:@"articleViewSegue" sender:article];
    }
    else if (_segmentControl.selectedSegmentIndex == 1)
    {
        User *user = _followingArray[indexPath.row];
        [self performSegueWithIdentifier:@"profileViewSegue" sender:user];


    }
    else
    {
        [RKDropdownAlert title:@"Unselected Segment"
                       message:@"Yo, this segment doesn't exsist therefore there is NOTHING!"
               backgroundColor:[UIColor redColor]
                     textColor:[UIColor whiteColor]
                          time:1.0];
    }
}

#pragma
#pragma mark - Navigation
#warning Compete this method with user viewcontroller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqual:@"articleViewSegue"])
    {
        Article *article = (Article *)sender;
        WebArticleViewController *vc = [segue destinationViewController];
        NSLog(@"passed article.. before segue: %@", article);
        vc.article = article;
    }
    else if ([segue.identifier isEqual:@"profileViewSegue"])
    {
        User *user = (User *)sender;
        ProfileViewController *vc = [segue destinationViewController];
        vc.user = user;
        NSLog(@"%@", user);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
