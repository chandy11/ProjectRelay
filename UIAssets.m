//
//  UIAssets.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 3/8/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import "UIAssets.h"

@implementation UIAssets

+ (void)setupNavbarOnNavbar:(UINavigationController *)navigationController onNavigationItem:(UINavigationItem *)navigationItem
{
    [navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],
                                                                  NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:20.0f]                                                                      }];
    [navigationController.navigationBar setBackgroundColor:[kColorConstants pomogranateWithAlpha:1.0]];
    [navigationItem setTitle: @"Relay"];
}

+ (void)setArticleCellStyling:(ArticleTableViewCell *)cell withArticle:(Article *)article
{
    cell.backgroundColor = [UIColor blackColor];
    cell.titleLable.text = article.title;
    cell.titleLable.textColor = [kColorConstants pomogranateWithAlpha:1.0];
    cell.descriptionLabel.text = article.descriptionText;
    cell.descriptionLabel.textColor = [kColorConstants pomogranateWithAlpha:1.0];
    //    cell.usernameLabel.text = ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [cell.layer setBorderColor:[[kColorConstants silverWithAlpha:1.0] CGColor]];
    [cell.layer setBorderWidth:1.3];
    [cell.layer setCornerRadius:0.0f];
    [cell.layer setMasksToBounds:YES];
}

@end
