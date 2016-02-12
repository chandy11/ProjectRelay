//
//  ProfileViewController.m
//  ProjectRelay
//
//  Created by Jazz Santiago on 2/6/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "ProfileViewController.h"
#import "WebArticleViewController.h"
#import "Article.h"
#import "ArticleTableViewCell.h"
#import "kColorConstants.h"
#import "RKDropdownAlert.h"


@interface ProfileViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *likesArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) UIImage *articleImage;
@property (strong, nonatomic) Article *articles;



@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [_profileImageView.layer setBorderColor:[[kColorConstants silverWithAlpha:1.0] CGColor]];
    [_profileImageView.layer setBorderWidth:4.3]; // For Border width
    [_profileImageView.layer setCornerRadius:45.0f]; // For Corner radious
    [_profileImageView.layer setMasksToBounds:YES];
    
    [self userLikesQuery];

    _likesArray = [[NSMutableArray alloc]init];

    [self getUserImage];
    [_tableView reloadData];
    [self useRefreshControl];



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

    PFFile *userPhoto = [_user objectForKey:@"profileImage"];
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
//    User *cUser = _user;
//    NSLog(@"%@", cUser);
    PFRelation *relationQuery = [_user relationForKey:@"likedArticles"];
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


#pragma
#pragma mark - UI Eelements
- (void)useRefreshControl
{
    _refreshControl = [UIRefreshControl new];
    _refreshControl.backgroundColor = [kColorConstants pomogranateWithAlpha:1.0];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(userLikesQuery) forControlEvents:UIControlEventValueChanged];
}

#pragma
#pragma mark - UI Tableview

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"forIndexPath:indexPath];

    _articles = [_likesArray objectAtIndex:indexPath.row];

    cell.titleLable.textColor = [kColorConstants pomogranateWithAlpha:1.0];
    cell.descriptionLabel.textColor = [kColorConstants pomogranateWithAlpha:1.0];

    PFFile *file = _articles.articleImage;
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error)
     {
         if (!error)
         {
             UIImage *image = [UIImage imageWithData:data];
//             cell.articleImage.image = image;
//             [cell.articleImage.layer setBorderColor:[[kColorConstants cloudsWithAlpha:1.0]CGColor]];
//             [cell.articleImage.layer setBorderWidth:4.3];
//             [cell.articleImage.layer setCornerRadius:30.0f];
//             [cell.articleImage.layer setMasksToBounds:YES];
             cell.articleImage.image = image;
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
    cell.titleLable.textColor = [kColorConstants pomogranateWithAlpha:1.0];
    cell.usernameLabel.text = @"";
    cell.usernameLabel.textColor = [kColorConstants pomogranateWithAlpha:1.0];
    cell.descriptionLabel.text = _articles.descriptionText;
    cell.descriptionLabel.textColor = [kColorConstants pomogranateWithAlpha:1.0];
    cell.backgroundColor = [UIColor lightGrayColor];


    return cell;

}
- (IBAction)didFollowUserOnButtonPressed:(UIButton *)sender
{

    User *cUser = [User currentUser];
    
    PFRelation *relation = [cUser relationForKey:@"following"];
    [relation addObject:_user];
    
    [cUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
     {
         if (!error && succeeded)
         {
             [cUser save];
             NSLog(@"now following %@ !",_user);
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = _likesArray[indexPath.row];
    NSLog(@"selected article: %@", article);
    [self performSegueWithIdentifier:@"toWebSegue" sender:article];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _likesArray.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Article *article = (Article *)sender;
    WebArticleViewController *vc = [segue destinationViewController];
    vc.article = article;
}


@end
