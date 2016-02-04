//
//  CommentCell.h
//  ProjectRelay
//
//  Created by Irwin Gonzales on 1/13/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;

@end
