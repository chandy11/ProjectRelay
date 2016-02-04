//
//  Article.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/9/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import "Article.h"
#import <PFObject+Subclass.h>

@implementation Article

@dynamic title;
@dynamic descriptionText;
@dynamic url;
@dynamic articleImage;
@dynamic objectId;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Article";
}

@end
