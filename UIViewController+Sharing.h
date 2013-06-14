//
//  UIViewController+Sharing.h
//  Joseph Fabisevich
//
//  Created by Joseph Fabisevich on 2/19/13.
//  Copyright (c) 2013 mergesort. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


@interface UIViewController (Sharing)
<
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    UINavigationControllerDelegate
>

+ (BOOL)canShareViaText;
+ (BOOL)canShareViaEmail;
+ (BOOL)canShareViaTwitter;
+ (BOOL)canShareViaFacebook;

- (void)shareViaTextWithMessage:(NSString *)message;
- (void)shareViaEmailWithSubject:(NSString *)subject withMessage:(NSString *)message;
- (void)shareViaFacebookWithMessage:(NSString *)message withImage:(UIImage *)image;
- (void)shareViaTwitterWithMessage:(NSString *)message withImage:(UIImage *)image;

@end
