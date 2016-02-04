//
//  User.h
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/9/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) PFFile *profileImage;

@end
