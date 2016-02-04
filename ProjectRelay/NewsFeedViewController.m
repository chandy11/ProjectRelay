//
//  NewsFeedViewController.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/8/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "WebArticleViewController.h"
#import "BackendFunctions.h"
#import "Article.h"
#import "User.h"
#import "ArticleTableViewCell.h"
#import <Parse/Parse.h>
#import "RKDropdownAlert.h"
#import "MBProgressHUD.h"
#import "kColorConstants.h"


@interface NewsFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *newsFeedArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIImage *articleImage;
@property (strong, nonatomic) Article *article;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation NewsFeedViewController

// IS INTIAL VIEWCONTROLLER
- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self showWelcomeMessage];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.newsFeedArray = [NSMutableArray new];
    //self.articleImage = [UIImage new];
    [self newsQuery];
    [self.tableView reloadData];
    
    [self useRefreshControl];
    [self setNavBar];
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
    _refreshControl.backgroundColor = [UIColor grayColor];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(newsQuery) forControlEvents:UIControlEventValueChanged];
}

- (void)showWelcomeMessage
{
    PFQuery *query = [User query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
     {
         NSArray *userArray = [NSArray arrayWithArray:objects];
         if ([userArray containsObject:[User new]])
         {
             [RKDropdownAlert title:@"Welcome Back!"
                            message:@"Good to have you back!"
                    backgroundColor:[UIColor greenColor]
                          textColor:[UIColor whiteColor]
                               time:1.0];
             
         }
         else
         {
             [RKDropdownAlert title:@"Welcome To Relay!"
                            message:@"Go ahead, know all the things!"
                    backgroundColor:[UIColor greenColor]
                          textColor:[UIColor whiteColor]
                               time:1.0];
         }
         
     }];
}

#pragma
#pragma mark - Refreshes & Queries
- (void )newsQuery
{
    
    //QUERY FOR ALL OBJECTS IN DATABASE - FOUND IN BackendFunctions.h
    [BackendFunctions arrayQuery:^(NSArray *array, NSError *error)
    {
        //Error handle for both data and refresh control
        if (!error && _refreshControl)
        {
            //populate array
            _newsFeedArray = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
            [_refreshControl endRefreshing];
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
            [RKDropdownAlert show];
            [RKDropdownAlert title:@"Error!"
                           message:error.localizedDescription
                   backgroundColor:[UIColor greenColor]
                         textColor:[UIColor whiteColor]];
        }
        
    }];
}

- (void)reloadTableView
{
    //Reloads data into array and stops refreshing
    [_tableView reloadData];
    [_refreshControl endRefreshing];
}

#pragma
#pragma mark - UI Tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // puts objects from query into tableview as objects
    Article *article = [_newsFeedArray objectAtIndex:indexPath.row];

    // makes tableview cell
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // set cell styling
    cell.backgroundColor = [UIColor blackColor];
    cell.titleLable.text = article.title;
    cell.titleLable.textColor = [kColorConstants pomogranateWithAlpha:1.0];
    cell.descriptionLabel.text = article.descriptionText;
    cell.descriptionLabel.textColor = [kColorConstants pomogranateWithAlpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [cell.layer setBorderColor:[[kColorConstants silverWithAlpha:1.0] CGColor]];
    [cell.layer setBorderWidth:1.3];
    [cell.layer setCornerRadius:0.0f];
    [cell.layer setMasksToBounds:YES];

    PFFile *file = article.articleImage;
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error)
    {
        if (!error)
        {
            UIImage *image = [UIImage imageWithData:data];
            cell.articleImage.image = image;
            [cell.articleImage.layer setBorderColor:[[UIColor blackColor]CGColor]];
            [cell.articleImage.layer setBorderWidth:1.3];
            [cell.articleImage.layer setCornerRadius:3.0f];
            [cell.articleImage.layer setMasksToBounds:YES];
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
        
    }
    progressBlock:^(int percentDone)
    {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];;
    }];
    
    cell.textLabel.textColor = [UIColor redColor];

    
    // relay button
    UIImage *imageTapped = [UIImage imageNamed:@"Refresh-48"];
    UIImage *image = [UIImage imageNamed:@"Refresh Filled-50"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect frame = CGRectMake(0.0, 0.0, 25, 25);
    
    button.frame = frame;   // match the button's size with the image size
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:imageTapped forState:UIControlStateHighlighted];
    
    // set the button's target to this table view controller so we can interpret touch events and map that to a NSIndexSet
    [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryView = button;
 
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.image = _articleImage;
    [cell.contentView addSubview:imageView];

    return cell;
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
    {
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
        //NSLog(@"button tapped");
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    User *user = [User currentUser];
    Article *article = _newsFeedArray[indexPath.row];
    PFRelation *relation = [user relationForKey:@"likedArticles"];
    [relation addObject:article];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        if (!error || succeeded)
        {
            [user saveInBackground];
            NSLog(@"%@ was saved!", article);
            [RKDropdownAlert title:@"Article Was Saved Into Your Favorites!"
                           message:nil
                   backgroundColor:[UIColor blueColor]
                         textColor:[UIColor whiteColor]
                              time:1.0];
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = _newsFeedArray[indexPath.row];
    [self performSegueWithIdentifier:@"toWebSegue" sender:article];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsFeedArray.count;
}

#pragma
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"toWebSegue"])
    {
        Article *article = (Article *)sender;
        WebArticleViewController *vc = [segue destinationViewController];
        vc.article = article;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
