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
#pragma mark - Interface - MessageAttachment

@interface MessageAttachment : NSObject

+ (nonnull instancetype)attachmentWithType:(nonnull NSString *)attachmentType filename:(nonnull NSString *)filename attachmentData:(nonnull NSData *)data;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants

extern NSString * const __nonnull textMessageSharingService;
extern NSString * const __nonnull emailSharingService;
extern NSString * const __nonnull cancelledSharingService;


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface UIViewController (Sharing)
<
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    UINavigationControllerDelegate
>

@property (readonly) BOOL canShareViaText;
@property (readonly) BOOL canShareViaEmail;
@property (readonly) BOOL canShareViaTwitter;
@property (readonly) BOOL canShareViaFacebook;
@property (readonly) BOOL canShareViaSinaWeibo;
@property (readonly) BOOL canShareViaTencentWeibo;

- (void)shareViaActivityController:(nullable NSArray *)excludedActivityTypes activityItems:(nullable NSArray *)activityItems applicationActivities:(nullable NSArray *)applicationActivities completionWithItemsHandler:(nullable void (^)(NSString * __nonnull activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError))completion;
- (void)shareViaTextWithMessage:(nullable NSString *)message attachments:(nullable NSArray *)attachments;
- (void)shareViaEmailWithSubject:(nullable NSString *)subject withMessage:(nullable NSString *)message isHTML:(BOOL)HTML toRecepients:(nullable NSArray *)recepients ccRecepients:(nullable NSArray *)ccRecepients bccRecepients:(nullable NSArray *)bccRecepients attachments:(nullable NSArray *)attachments;
- (void)shareViaFacebookWithMessage:(nullable NSString *)message withImages:(nullable NSArray *)images withURLs:(nullable NSArray *)URLs;
- (void)shareViaTwitterWithMessage:(nullable NSString *)message withImages:(nullable NSArray *)images withURLs:(nullable NSArray *)URLs;
- (void)shareViaSinaWeiboWithMessage:(nullable NSString *)message withImages:(nullable NSArray *)images withURLs:(nullable NSArray *)URLs;
- (void)shareViaTencentWeiboWithMessage:(nullable NSString *)message withImages:(nullable NSArray *)images withURLs:(nullable NSArray *)URLs;
- (void)shareViaCopyString:(nullable NSString *)string;
- (void)shareViaCopyURL:(nullable NSURL *)URL;

@property (nonatomic, copy, nullable) UIColor * barButtonItemTintColor;
@property (nonatomic, copy, nullable) NSDictionary * titleTextAttributes;
@property (nonatomic, copy, nullable) void  (^sharingCompleted)(BOOL success, NSString * __nonnull sharingService);

@end
