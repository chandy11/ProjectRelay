//
//  SearchViewController.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/8/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchWebViewController.h"
#import "WebArticleViewController.h"
#import "ProfileViewController.h"
#import "BackendFunctions.h"
#import <Parse/Parse.h>
#import "Article.h"
#import "User.h"
#import "RKDropdownAlert.h"
#import "kColorConstants.h"


@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIAlertController *alert;
@property (weak, nonatomic) IBOutlet UIView *segmentBackroundView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSMutableArray *articleArray;
@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) NSMutableArray *displayArray;
@property (strong, nonatomic) Article *article;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _searchBar.delegate = self;
    _displayArray = [NSMutableArray new];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;

    UIView *segmentBackroundView = _segmentBackroundView;
    segmentBackroundView.backgroundColor = [kColorConstants pomogranateWithAlpha:1.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    _articleArray = [NSMutableArray new];
    _userArray = [NSMutableArray new];
}

- (void)hideKeyboard
{
    [_searchBar resignFirstResponder];
}

#pragma
#pragma mark - Index Button Pressed Logic
- (IBAction)segmentControlIndexChanged:(UISegmentedControl *)sender
{

    if (_segmentControl.selectedSegmentIndex == 0)
    {
        [self queryArticle];
    }
    else
    {
        [self userQuery];
    }
}

#pragma
#pragma mark - Table View Delgates
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (_segmentControl.selectedSegmentIndex == 0)
    {
        Article *article = [_displayArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [kColorConstants pomogranateWithAlpha:1.0];
        cell.textLabel.text = article.title;
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        User *user = [_displayArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [kColorConstants pomogranateWithAlpha:1.0];
        cell.textLabel.text = user.username;
        cell.textLabel.textColor = [UIColor whiteColor];

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (_segmentControl.selectedSegmentIndex == 1)
    {
        User *oUser = [_displayArray objectAtIndex:indexPath.row];
        User *cUser = [User currentUser];
        
        PFRelation *relation = [cUser relationForKey:@"following"];
        [relation addObject:oUser];
        
        [cUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
         {
             if (!error && succeeded)
             {
                 [cUser save];
                 NSLog(@"now following %@ !",oUser);
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_segmentControl.selectedSegmentIndex == 0)
    {
        Article *article = _displayArray[indexPath.row];
        NSLog(@"selected article: %@", article);
        [self performSegueWithIdentifier:@"toWebViewSegue" sender:article];
    }
    else if (_segmentControl.selectedSegmentIndex == 1)
    {
        User *user = _displayArray[indexPath.row];
        [self performSegueWithIdentifier:@"profileViewSegue" sender:user];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _displayArray.count;
}

#pragma 
#pragma mark - Search Bar Delegates
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterVisibleItems];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self filterVisibleItems];
    [_searchBar resignFirstResponder];
}

- (void)filterVisibleItems
{
    NSString *searchText = _searchBar.text;
    
    if (_segmentControl.selectedSegmentIndex == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
        _displayArray = [[_articleArray filteredArrayUsingPredicate:predicate] mutableCopy];
        [_tableView reloadData];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username CONTAINS[cd] %@", searchText];
        _displayArray = [[_userArray filteredArrayUsingPredicate:predicate] mutableCopy];
        [_tableView reloadData];
    }
}

#pragma
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"toWebViewSegue"])
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
        NSLog(@"got user %@", user);
        vc.user = user;
    }
}

#pragma
#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma
#pragma mark - Refreshes & Queries
-(void)queryArticle
{
    [self clearDisplayArray];
    
    // Possible data structure:
    // NSDictionary<NSString *, NSMutableArray<Article *> *> *
    
    PFQuery *query = [PFQuery queryWithClassName:@"Tags"];
    //        [query whereKey:@"content" equalTo:searchText];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable tags, NSError * _Nullable error)
     {
         if (!error)
         {
             for (PFObject *tag in tags)
             {
                 PFRelation *relation = [tag relationForKey:@"article"];
                 PFQuery *relationalQuery = [relation query];
                 [relationalQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable articles, NSError * _Nullable error)
                  {
                      if (!error)
                      {
                          [_articleArray addObjectsFromArray:articles];
                          [self filterVisibleItems];
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

- (void)userQuery
{
    [self clearDisplayArray];
    
    PFQuery *userQuery = [User query];
    //        [userQuery whereKey:@"username" equalTo:searchText];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
     {
         if (!error)
         {
//             [_displayArray addObjectsFromArray:objects];
             _userArray.array = objects;
             [self filterVisibleItems];
             // TODO: re-filter the display array
//             [_tableView reloadData];
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

- (void)clearDisplayArray
{
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    for (NSUInteger i = 0; i < _displayArray.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [_displayArray removeAllObjects];
    [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

@end
