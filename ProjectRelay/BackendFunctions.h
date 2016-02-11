//
//  BackendFunctions.h
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/9/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Article.h"

// Block Definitions
typedef void (^SuccessCompletionBlock)(BOOL success);
typedef void (^CompletionWithErrorBlock)(BOOL success, NSError *error);
typedef void (^CompletionWithDictionaryBlock)(NSDictionary *dictionary, NSError *error);
typedef void (^CompletionWithArrayBlock)(NSArray *array, NSError *error);
typedef void (^FacebookCompletionWithErrorBlock)(BOOL isNewUser, BOOL success, NSError *error);
typedef void (^FacebookProfileCompletionBlock)(UIImage *image, NSError *error);
typedef void (^ArrayReturnBlock)(NSArray *array, NSError *error);


@interface BackendFunctions : NSObject

//Methods With Blocks
+ (void)signupUser:(NSString *)username
          password:(NSString *)password
             email:(NSString *)email
      onCompletion:(CompletionWithErrorBlock)onCompletion;

+ (void)addUserImageProfile:(UIImage *)photo
               onCompletion:(CompletionWithErrorBlock)onCompletion;

+ (void)loginUser:(NSString *)username
         password:(NSString *)password
     onCompletion:(CompletionWithErrorBlock)onCompletion;

+ (void)arrayQuery:(ArrayReturnBlock)returnArray;

+ (void)commentQueryWithArticle:(Article *)article
                       andArray:(ArrayReturnBlock)returnArray;

+ (void)saveComment:(NSString *)text
          onArticle:(Article *)article;

//+ (void)userQueryonCompletion:(CompletionWithErrorBlock)onCompletion;

+ (UIAlertController *)confirmNewPassword:(NSString *)password and:(NSString *)confirmPassword;

//Regular Class Methods
+ (void)saveArticleWithTitle:(UITextField *)title
                 description:(UITextView *)description
                       image:(UIImage *)image
                      andUrl:(UITextField *)url
                     tagName:(UITextField *)tagField;
+ (void)logoutUser;

+ (UIAlertController *)showDataEntryError:(NSString *)errorTitle
               withMessage:(NSString *)errorMessage;

+ (UIAlertController *)addTagswithObjectClassName:(NSString *)className
                                   withProperties:(NSString *)property
                                   andRelationKey:(NSString *)relation;

+ (UIAlertController *)showSuccessEntrywithMessage:(NSString *)message;

+ (UIAlertController *)showNotification:(NSString *)title withMessage: (NSString *)message onCompletion:(CompletionWithErrorBlock)onCompletion;

+ (UIAlertController *)alertControllerwithTitle:(NSString *)title
                                     andMessage:(NSString *)message;


#warning WORK ON THESE TWO METHODS FOR LOGIN OPTIMIZATION ON V2
//+ (UIAlertController *)errorHandleAndLoginAlerController:(UITextField *)usernameTextField
//                                       passwordTextField:(UITextField *)passwordTextField;

//+ (UIAlertController *)errorHandelAlertController: (UITextField *)emailTextField
//                                usernameTextField: (UITextField *)usernameTextField
//                                passwordTextfield: (UITextField *)passwordTextField
//                      andConfirmPasswordTextField: (UITextField *)confirmPasswordTextField;

//Profile Edit Methods
+ (void)saveChangesOnUserProfile:(NSString *)username
                           email:(NSString *)email
                        password:(NSString *)password
                    onCompletion:(CompletionWithErrorBlock)onCompletion;


@end
