//
//  User.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/9/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import "User.h"
#import <PFObject+Subclass.h>

@implementation User

@dynamic username;
@dynamic password;
@dynamic email;
@dynamic profileImage;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"_User";
}

@end
