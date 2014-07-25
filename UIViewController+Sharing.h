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
#pragma mark - Enums

typedef NS_ENUM(NSInteger, SharingService)
{
    SharingServiceTextMessage,
    SharingServiceEmail,
    SharingServiceTwitter,
    SharingServiceFacebook,
    SharingServiceSinaWeibo,
    SharingServiceTencentWeibo,
    SharingServiceError,
};


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
- (void)shareViaEmailWithSubject:(NSString *)subject withMessage:(NSString *)message isHTML:(BOOL)HTML toRecepients:(NSArray *)recepients;
- (void)shareViaFacebookWithMessage:(NSString *)message withImage:(UIImage *)image;
- (void)shareViaTwitterWithMessage:(NSString *)message withImage:(UIImage *)image;
- (void)shareViaSinaWeiboWithMessage:(NSString *)message withImage:(UIImage *)image;
- (void)shareViaTencentWeiboWithMessage:(NSString *)message withImage:(UIImage *)image;

@property (nonatomic, copy) void (^sharingCompleted)(BOOL success, SharingService service);

NSString * stringForService(SharingService service);

@end
