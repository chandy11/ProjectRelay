//
//  Article.h
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/9/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import <Parse/Parse.h>

@interface Article : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) PFFile *articleImage;
@property (strong, nonatomic) NSString *objectId;

@end
