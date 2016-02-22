//
//  BackendFunctions.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/9/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import "BackendFunctions.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Article.h"
#import "User.h"

@implementation BackendFunctions

#pragma
#pragma mark - User Signup
+ (void)signupUser:(NSString *)username
          password:(NSString *)password
             email:(NSString *)email
      onCompletion:(CompletionWithErrorBlock)onCompletion
    
{
    User *user = [User user];
    user.username = username;
    user.password = password;
    user.email = email;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        onCompletion(succeeded, error);
    }];
}

+ (void)addUserImageProfile:(UIImage *)photo
               onCompletion:(CompletionWithErrorBlock)onCompletion
{
    NSData *imageData = UIImagePNGRepresentation(photo);
    PFFile *imageFile = [PFFile fileWithName:@"RelayProfilePicture.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
     {
         if (!error)
         {
             User *user = [User currentUser];
             user.profileImage = imageFile;
             [user saveInBackground];
         }
     }];
}

+ (void)saveChangesOnUserProfile:(NSString *)username
                           email:(NSString *)email
                        password:(NSString *)password
                    onCompletion:(CompletionWithErrorBlock)onCompletion
{
    PFUser *user = [PFUser currentUser];
    
    if ([username isEqualToString:@""])
    {
        user.email= email;
        user.password = password;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
         {
             onCompletion(succeeded, error);
         }];
    }
    else if ([email isEqualToString:@""])
    {
        user.username = username;
        user.password = password;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
         {
             onCompletion(succeeded, error);
         }];
        
    }
    else if ([password isEqualToString:@""])
    {
        user.username = username;
        user.password = password;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
         {
             onCompletion(succeeded, error);
         }];
    }
    else
    {
        user.username = username;
        user.email = email;
        user.password = password;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
         {
             onCompletion(succeeded, error);
         }];
    }
}

+ (UIAlertController *)confirmNewPassword:(NSString *)password and:(NSString *)confirmPassword
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm Password"
                                                                   message:@"Just to make sure you're sure!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
    {
        nil;
    }];
    
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action)
                                                   {
                                                       if (password == confirmPassword)
                                                       {
                                                           PFUser *user = [PFUser currentUser];
                                                           user.password = confirmPassword;
                                                           [user saveInBackground];
                                                       }
                                                   }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Canel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    [alert addAction:submit];
    [alert addAction:cancelAction];
    return alert;
}

#pragma
#pragma mark - User Login
+ (void)loginUser:(NSString *)username
         password:(NSString *)password
     onCompletion:(CompletionWithErrorBlock)onCompletion
{
    [PFUser logInWithUsername:username password:password];
}

#pragma
#pragma mark - User Logout
+ (void)logoutUser
{
    [PFUser logOut];
}

#pragma
#pragma mark - Article Query
+ (void)arrayQuery:(ArrayReturnBlock)returnArray
{
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass(Article.class)];
    [query selectKeys:@[@"title",@"url",@"descriptionText",@"articleImage",@"objectId"]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         returnArray(objects,error);
     }];
}

#pragma
#pragma mark - Comment Query
+ (void)commentQueryWithArticle:(Article *)article andArray:(ArrayReturnBlock)returnArray
{
    article = [Article new];
    PFRelation *relation = [article relationForKey:@"comments"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            returnArray(objects, error);
        }
    }];
}

#pragma
#pragma mark - Save Comments
+ (void)saveComment: (NSString *)text onArticle: (Article *)article
{
    User *cUser = [User currentUser];
    PFObject *comment = [PFObject objectWithClassName:@"Comments"];
    PFRelation *relation = [article relationForKey:@"comments"];
    [relation addObject:comment];
    [comment addObject:cUser forKey:@"author"];
    comment[@"text"] = text;
    comment[@"authorId"] = cUser.objectId;
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        if (!error)
        {
            [comment save];
            [article save];
            NSLog(@"Comment Saved");
            NSLog(@"%@", comment[@"authorId"]);
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

#pragma
#pragma mark - Article Save
+ (void)saveArticleWithTitle:(UITextField *)title
                 description:(UITextView *)description
                       image:(UIImage *)image
                      andUrl:(UITextField *)url
                     tagName:(UITextField *)tagField
{
    Article *article = [Article new];
    User *cUser = [User currentUser];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"RelayProfilePicture.png" data:imageData];
    
    article.title = title.text;
    article.descriptionText = description.text;
    article.url = url.text;
    article.articleImage = imageFile;
    article[@"author"] = cUser;
    
    [article saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        if (succeeded)
        {
            NSLog(@"Object Id = %@", article.objectId);
            PFObject *tag = [PFObject objectWithClassName:@"Tags"];
            PFRelation *relation = [tag relationForKey:@"article"];
            [relation addObject:article];
            tag[@"content"] = tagField.text;
            tag[@"article1"] = article;
            [tag save];
            [tag saveInBackground];
            //Post a notification "savedToParseSuccess"
            [[NSNotificationCenter defaultCenter] postNotificationName:@"savedToParseSuccess" object:nil];
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    }

#pragma
#pragma mark - AlertView
+ (UIAlertController *)showDataEntryError:(NSString *)errorTitle
                              withMessage:(NSString *)errorMessage
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:errorTitle
                                message:errorMessage
                                preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [alert addAction:ok];
    return alert;
}

+ (UIAlertController *)showNotification:(NSString *)title
                            withMessage: (NSString *)message
                           onCompletion:(CompletionWithErrorBlock)onCompletion
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [alert addAction:ok];
    return alert;
}

+ (UIAlertController *)showSuccessEntrywithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [alert addAction:ok];
    return alert;
}

+ (UIAlertController *)addTagswithObjectClassName:(NSString *)className
                                   withProperties:(NSString *)property
                                   andRelationKey:(NSString *)relation
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Tags"
                                                                             message:@"What catergory of news would this be?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
     {
         nil;
     }];
    
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action)
                                {
                                    UITextField *textField = alertController.textFields.firstObject;
                                    PFObject *tag = [PFObject objectWithClassName:className];
                                    tag[property] = textField.text;
                                    [tag save];
                                    PFRelation *tagRelation = [tag relationForKey:relation];
                                    [tagRelation addObject:tag];
                                    [tag saveInBackground];
                                }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Canel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    return alertController;
}

+ (UIAlertController *)alertControllerwithTitle:(NSString *)title
                                     andMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss"
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil];
    [alert addAction:dismiss];
    return alert;
}

#warning WORK ON THESE METHODSFOR LOGIN AND SIGN UP!
//+ (UIAlertController *)errorHandelAlertController: (UITextField *)emailTextField
//                                usernameTextField: (UITextField *)usernameTextField
//                                passwordTextfield: (UITextField *)passwordTextField
//                      andConfirmPasswordTextField: (UITextField *)confirmPasswordTextField
//{
//    UIAlertController *alertController = [UIAlertController new];
//    
//    if ([emailTextField.text isEqualToString:@""])
//    {
//        alertController = [BackendFunctions showDataEntryError:@"Error" withMessage:@"You Forgot To Put A Email"];
//    }
//    else if ([usernameTextField.text isEqualToString:@""])
//    {
//        alertController = [BackendFunctions showDataEntryError:@"Error" withMessage:@"You Forgot To Put A Username"];
//    }
//    else if([passwordTextField.text isEqualToString:@""])
//    {
//        alertController = [BackendFunctions showDataEntryError:@"Error" withMessage:@"You Forgot To Put In Your Password"];
//    }
//    else if ([confirmPasswordTextField.text isEqualToString:passwordTextField.text] == [confirmPasswordTextField.text isEqualToString:@""])
//    {
//        alertController = [BackendFunctions showDataEntryError:@"Error" withMessage:@"Passwords Don't Match Yo!"];
//    }
//    else
//    {
//        [BackendFunctions signupUser:usernameTextField.text password:passwordTextField.text email:emailTextField.text onCompletion:^(BOOL success, NSError *error)
//         {
//             if (!error)
//             {
//                 NSLog(@"Signed up as %@", [User currentUser].username);
//             }
//             else
//             {
//                 NSString *errorString = [error userInfo][@"error"];
//                 [BackendFunctions showDataEntryError:@"Error" withMessage:errorString];
//             }
//         }];
//    }
//    return alertController;
//}


//+ (UIAlertController *)errorHandleAndLoginAlerController:(UITextField *)usernameTextField
//                                        passwordTextField:(UITextField *)passwordTextField
//{
//    UIAlertController *alertController = [UIAlertController new];
//    if ([usernameTextField.text isEqualToString:@""])
//    {
//        alertController = [BackendFunctions showDataEntryError:@"Error" withMessage:@"You Forgot To Put A Username"];
//    }
//    else if ([passwordTextField.text isEqualToString:@""])
//    {
//        alertController = [BackendFunctions showDataEntryError:@"Error" withMessage:@"You Forgot To Put A Password"];
//    }
//    else
//    {
//        [PFUser logInWithUsernameInBackground:usernameTextField.text password:passwordTextField.text block:^(PFUser *user, NSError *error)
//         {
//             if (!error)
//             {
//                 NSLog(@"Signed In As %@", [PFUser currentUser].username);
//             }
//             else
//             {
//                 NSString *errorString = [error userInfo][@"error"];
//                 NSLog(@"%@", errorString);
//             }
//         }];
//    }
//    
//    return alertController;
//}


@end
