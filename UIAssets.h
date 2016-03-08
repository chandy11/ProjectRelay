//
//  UIAssets.h
//  ProjectRelay
//
//  Created by Irwin Gonzales on 3/8/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "kColorConstants.h"
#import "ArticleTableViewCell.h"
#import "Article.h"

@interface UIAssets : NSObject

+ (void)setupNavbarOnNavbar:(UINavigationController *)navigationController
           onNavigationItem:(UINavigationItem *)navigationItem;

+ (void)setArticleCellStyling:(ArticleTableViewCell *)cell
                  withArticle:(Article *)article;

@end
