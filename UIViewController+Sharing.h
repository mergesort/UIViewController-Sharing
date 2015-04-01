//
//  UIViewController+Sharing.h
//  Joseph Fabisevich
//
//  Created by Joseph Fabisevich on 2/19/13.
//  Copyright (c) 2013 mergesort. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants

extern NSString * const textMessageSharingService;
extern NSString * const emailSharingService;
extern NSString * const twitterSharingService;
extern NSString * const facebookSharingService;
extern NSString * const sinaWeiboSharingService;
extern NSString * const tencentWeiboSharingService;
extern NSString * const cancelledSharingService;


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface UIViewController (Sharing)
<
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate,
UINavigationControllerDelegate
>

- (BOOL)canShareViaText;
- (BOOL)canShareViaEmail;
- (BOOL)canShareViaTwitter;
- (BOOL)canShareViaFacebook;
- (BOOL)canShareViaSinaWeibo;
- (BOOL)canShareViaTencentWeibo;

- (void)shareViaTextWithMessage:(NSString *)message;
- (void)shareViaEmailWithSubject:(NSString *)subject withMessage:(NSString *)message isHTML:(BOOL)HTML toRecepients:(NSArray *)recepients ccRecepients:(NSArray *)ccRecepients bccRecepients:(NSArray *)bccRecepients;
- (void)shareViaFacebookWithMessage:(NSString *)message withImage:(UIImage *)image;
- (void)shareViaTwitterWithMessage:(NSString *)message withImage:(UIImage *)image;
- (void)shareViaSinaWeiboWithMessage:(NSString *)message withImage:(UIImage *)image;
- (void)shareViaTencentWeiboWithMessage:(NSString *)message withImage:(UIImage *)image;
- (void)shareViaCopyString:(NSString *)string;
- (void)shareViaCopyURL:(NSURL *)URL;

@property (nonatomic, copy) UIColor *barButtonItemTintColor;
@property (nonatomic, copy) NSDictionary *titleTextAttributes;
@property (nonatomic, copy) void (^sharingCompleted)(BOOL success, NSString *sharingService);

@end
