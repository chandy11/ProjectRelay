//
//  ArticleTableViewCell.h
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/26/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kColorConstants.h"

@interface ArticleTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *articleImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;

@end
