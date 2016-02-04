//
//  WebArticleViewController.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/9/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import "WebArticleViewController.h"
#import "MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "BackendFunctions.h"
#import "CommentCell.h"
#import "User.h"
#import "kColorConstants.h"


@interface WebArticleViewController () <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (strong, nonatomic) NSMutableArray *userArray;
//@property (strong, nonatomic) NSMutableArray *contentArray;
@property (strong, nonatomic) NSMutableDictionary *contentDictionary;

@property (strong, nonatomic) NSString *authorName;
@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) PFObject *comment;

@end

@implementation WebArticleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    
    _commentsArray = [NSMutableArray new];
    _userArray = [NSMutableArray new];
    [_webView.layer setBorderColor:[[kColorConstants silverWithAlpha:1.0] CGColor]];
    [_webView.layer setBorderWidth:1.3];
    [_webView.layer setCornerRadius:5.0f];
    [_webView.layer setMasksToBounds:YES];
 //   _contentArray = [NSMutableArray new];
    
    [self loadWebsite];
  //  [self queryAll];
   // [self commentQuery];
   // [self userQuery];
   // [self commentAndUserArray];
    [self setDelegates];
    
    
   // [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _commentsArray = nil;
    _commentsArray = [NSMutableArray new];
    
    _userArray = nil;
    _userArray = [NSMutableArray new];
    
    _contentDictionary = nil;
    
    [self queryAll];
}

- (void)loadWebsite
{
    NSString *webPageURLString = self.article.url;
    NSURL *webPageURL = [NSURL URLWithString:webPageURLString];
    NSURLRequest *webPageURLRequest = [NSURLRequest requestWithURL:webPageURL];
    [self.webView loadRequest:webPageURLRequest];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [RKDropdownAlert title:@"Something Went Wrong!"
                   message:error.localizedDescription
           backgroundColor:[UIColor redColor]
                 textColor:[UIColor whiteColor]
                      time:1.0];
}

#pragma mark - TableView Delegates

-(void)setDelegates
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _commentTextField.delegate = self;
}


- (void)queryAll
{
    PFRelation *relation = [_article relationForKey:@"comments"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
     {
         if (!error)
         {
             _commentsArray = [NSMutableArray arrayWithArray:objects];
             
             NSMutableArray *usersIDArray = [NSMutableArray new];
             for (int index = 0; index < [_commentsArray count]; index++)
             {
                 PFObject *comment = _commentsArray[0];
                 
                 NSString *userID = comment[@"authorId"];
                 [usersIDArray addObject:userID];
             }
             
             PFQuery *userQuery = [User query];
             [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                 if (!error)
                 {
                     
                     if (!_userArray)
                         _userArray = [NSMutableArray new];
                     
                     for (int index = 0; index < [objects count]; index++)
                     {
                         PFUser *user = objects[index];
                         if ([usersIDArray containsObject:user.objectId])
                             [_userArray addObject:user];
                     }
                     
                     _contentDictionary = [self commentAndUserArray];
                     
                     [_tableView reloadData];
                 }
                 
                 else
                 {
                     NSLog(@"%@", error.localizedDescription);
                 }
             }];
         }
         else
         {
             NSLog(@"%@",error.localizedDescription);
         }
     }];
}

-(void)commentQuery
{
    PFRelation *relation = [_article relationForKey:@"comments"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            _commentsArray = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
            
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
        
    }];
}

-(void)userQuery
{
    PFQuery *userIdQuery = [PFQuery queryWithClassName:@"Comments"];
    [userIdQuery includeKey:@"authorId"];
    [userIdQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            _userArray = [NSMutableArray arrayWithObject:objects];
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
            
    }];
}

- (NSMutableDictionary *)commentAndUserArray
{
 /*   NSMutableDictionary *commentAndUserDictionary = [NSMutableDictionary dictionaryWithObjects:_userArray forKeys:_commentsArray];
    
    NSMutableArray *commentAndDictionaryArray = [NSMutableArray new];
    [commentAndDictionaryArray addObject:commentAndUserDictionary];
    
    return commentAndDictionaryArray; */
    
    if (_userArray && _commentsArray)
    {

        NSMutableDictionary *commentAndUserDictionary = [NSMutableDictionary new];
        
        for (int i = 0; i < [_commentsArray count]; i++)
        {
            PFObject *comment = _commentsArray[i];
            
            for (int j = 0; j < [_userArray count]; j++)
            {
                PFUser *user = _userArray[j];
                
            
                if ([user.objectId isEqualToString:comment[@"authorId"]])
                {
                    NSString *commentID = comment.objectId;
                    [commentAndUserDictionary setObject:user forKey:commentID];
                    j = (int)[_userArray count] + 1;
                }
            }
        }
        
        return commentAndUserDictionary;
    }
    else
    {
        NSLog(@"Error: Didn't finish pulling everything.");
        return nil;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    PFObject *comment = _commentsArray[indexPath.row];
    
    [cell.layer setBorderColor:[[kColorConstants silverWithAlpha:1.0] CGColor]];
    [cell.layer setBorderWidth:0.3];
    [cell.layer setCornerRadius:1.0f];
    [cell.layer setMasksToBounds:YES];
//    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    NSString *commentText = comment[@"text"];
    cell.commentLabel.text = commentText;
    
    
    PFUser *user = [_contentDictionary objectForKey:comment.objectId];
    NSString *usernameText = user.username;
    cell.authorLabel.text = usernameText;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


#pragma mark - Submit Button Action
- (IBAction)submitArticleOnButtonPressed:(id)sender
{
    [BackendFunctions saveComment:_commentTextField.text onArticle:_article];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
