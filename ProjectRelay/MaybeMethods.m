//
//  MaybeMethods.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/10/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import "MaybeMethods.h"

@implementation MaybeMethods

//- (void)gotoWorld:(id)sender
//{
//    //Need to check how many view controllers we have.
//    if (self.infiniteTabBarController.viewControllers.count >= 4) {
//        [self.infiniteTabBarController setSelectedIndex:4];
//    } else {
//        [self.infiniteTabBarController setSelectedIndex:2];
//    }
//}

//- (UIImage *)articleImage
//{
//    Article *article = [Article new];
//    PFFile *articleImage = [article objectForKey:@"articleImage"];
//    [articleImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error)
//    {
//        if (!error)
//        {
//            _articleImage = [UIImage imageWithData:data];
//            [self reloadTableView];
//        }
//        else
//        {
//            NSLog(@"%@", error.localizedDescription);
//            [RKDropdownAlert title:@"Something Went Wrong!"
//                           message:error.localizedDescription
//                   backgroundColor:[UIColor redColor]
//                         textColor:[UIColor whiteColor]
//                              time:1.0];
//        }
//    }];
//    return _articleImage;
//}


@end
