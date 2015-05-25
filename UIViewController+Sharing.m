//
//  UIViewController+Sharing.h
//  Joseph Fabisevich
//
//  Created by Joseph Fabisevich on 2/19/13.
//  Copyright (c) 2013 mergesort. All rights reserved.
//

#import "UIViewController+Sharing.h"

#import <Social/Social.h>
#import <objc/runtime.h>


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants

NSString * const textMessageSharingService = @"com.apple.UIKit.activity.Message";
NSString * const emailSharingService = @"com.apple.UIKit.activity.Mail";
NSString * const cancelledSharingService = @"com.plugin.cancelled";


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface - MessageAttachment

@interface MessageAttachment ()

@property (nonnull) NSString *attachmentType;
@property (nonnull) NSString *filename;
@property (nonnull) NSData *attachmentData;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation - MessageAttachment

@implementation MessageAttachment

+ (instancetype)attachmentWithType:(NSString *)attachmentType filename:(NSString *)filename attachmentData:(NSData *)data
{
    MessageAttachment *attachment = [[MessageAttachment alloc] init];

    attachment.attachmentType = attachmentType;
    attachment.filename = filename;
    attachment.attachmentData = data;

    return attachment;
}

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation UIViewController (Sharing)


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Associated objects

- (void)setSharingCompleted:(void (^)(BOOL, NSString *))sharingCompleted
{
    objc_setAssociatedObject(self, @selector(setSharingCompleted:), sharingCompleted, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(BOOL, NSString *))sharingCompleted
{
    return objc_getAssociatedObject(self, @selector(setSharingCompleted:));
}

- (UIColor *)barButtonItemTintColor
{
    return objc_getAssociatedObject(self, @selector(setBarButtonItemTintColor:));
}

- (void)setBarButtonItemTintColor:(UIColor *)color
{
    objc_setAssociatedObject(self, @selector(setBarButtonItemTintColor:), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)titleTextAttributes
{
    return objc_getAssociatedObject(self, @selector(setTitleTextAttributes:));
}

- (void)setTitleTextAttributes:(NSDictionary *)titleTextAttributes
{
    objc_setAssociatedObject(self, @selector(setTitleTextAttributes:), titleTextAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Sharing state

- (BOOL)canShareViaText
{
    return [MFMessageComposeViewController canSendText];
}

- (BOOL)canShareViaEmail
{
    return [MFMailComposeViewController canSendMail];
}

- (BOOL)canShareViaTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (BOOL)canShareViaFacebook
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
}

- (BOOL)canShareViaSinaWeibo
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo];
}

- (BOOL)canShareViaTencentWeibo
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTencentWeibo];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

- (void)shareViaActivityController:(NSArray *)excludedActivityTypes activityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities completionWithItemsHandler:(void (^)(NSString * activityType, BOOL completed, NSArray * returnedItems, NSError * activityError))completion
{
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludedActivityTypes;

    activityController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {

        if (completion)
        {
            completion(activityType, completed, returnedItems, activityError);
        }

        if (self.sharingCompleted)
        {
            NSString *sharingService = (activityType.length > 0) ? activityType : cancelledSharingService;
            self.sharingCompleted((completed && !activityError), sharingService);
        }
    };
    
    [self presentViewController:activityController animated:YES completion:nil];
   
}

- (void)shareViaTextWithMessage:(NSString *)message attachments:(NSArray *)attachments
{
    if (self.canShareViaText)
    {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        messageController.body = message;

        for (MessageAttachment *attachment in attachments)
        {
            [messageController addAttachmentData:attachment.attachmentData typeIdentifier:attachment.attachmentType filename:attachment.filename];
        }

        if (self.titleTextAttributes)
        {
            messageController.navigationBar.titleTextAttributes = self.titleTextAttributes;
        }

        if (self.barButtonItemTintColor)
        {
            messageController.navigationBar.tintColor = self.barButtonItemTintColor;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:messageController animated:YES completion:nil];
        });
    }
    else
    {
        self.sharingCompleted(NO, textMessageSharingService);
    }
}

- (void)shareViaEmailWithSubject:(NSString *)subject withMessage:(NSString *)message isHTML:(BOOL)HTML toRecepients:(NSArray *)recepients ccRecepients:(NSArray *)ccRecepients bccRecepients:(NSArray *)bccRecepients attachments:(NSArray *)attachments
{
    if (self.canShareViaEmail)
    {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setSubject:subject];
        [mailController setMessageBody:message isHTML:HTML];
        [mailController setToRecipients:recepients];
        [mailController setCcRecipients:ccRecepients];
        [mailController setBccRecipients:bccRecepients];

        for (MessageAttachment *attachment in attachments)
        {
            [mailController addAttachmentData:attachment.attachmentData mimeType:attachment.attachmentType fileName:attachment.filename];
        }

        if (self.titleTextAttributes)
        {
            mailController.navigationBar.titleTextAttributes = self.titleTextAttributes;
        }
        if (self.barButtonItemTintColor)
        {
            mailController.navigationBar.tintColor = self.barButtonItemTintColor;
        }

        mailController.mailComposeDelegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:mailController animated:YES completion:nil];
        });
    }
    else
    {
        self.sharingCompleted(NO, emailSharingService);
    }
}

- (void)shareViaFacebookWithMessage:(NSString *)message withImages:(NSArray *)images withURLs:(NSArray *)URLs
{
    if (self.canShareViaFacebook)
    {
        [self shareViaSLComposeViewController:SLServiceTypeFacebook withMessage:message withImages:images withURLs:URLs];
    }
    else
    {
        self.sharingCompleted(NO, SLServiceTypeFacebook);
    }
}


- (void)shareViaTwitterWithMessage:(NSString *)message withImages:(NSArray *)images withURLs:(NSArray *)URLs
{
    if (self.canShareViaTwitter)
    {
        [self shareViaSLComposeViewController:SLServiceTypeTwitter withMessage:message withImages:images withURLs:URLs];
    }
    else
    {
        self.sharingCompleted(NO, SLServiceTypeTwitter);
    }
}

- (void)shareViaSinaWeiboWithMessage:(NSString *)message withImages:(NSArray *)images withURLs:(NSArray *)URLs
{
    if (self.canShareViaSinaWeibo)
    {
        [self shareViaSLComposeViewController:SLServiceTypeSinaWeibo withMessage:message withImages:images withURLs:URLs];
    }
    else
    {
        self.sharingCompleted(NO, SLServiceTypeSinaWeibo);
    }
}

- (void)shareViaTencentWeiboWithMessage:(NSString *)message withImages:(NSArray *)images withURLs:(NSArray *)URLs
{
    if (self.canShareViaTencentWeibo)
    {
        [self shareViaSLComposeViewController:SLServiceTypeTencentWeibo withMessage:message withImages:images withURLs:URLs];
    }
    else
    {
        self.sharingCompleted(NO, SLServiceTypeTencentWeibo);
    }
}

- (void)shareViaCopyString:(NSString *)string
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
}

- (void)shareViaCopyURL:(NSURL *)URL
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.URL = URL;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private helpers

- (void)shareViaSLComposeViewController:(NSString *)network withMessage:(NSString *)message withImages:(NSArray *)images withURLs:(NSArray *)URLs
{
    NSString *initialText = message;

    if ([SLComposeViewController isAvailableForServiceType:network])
    {
        SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:network];
        [composeController setInitialText:initialText];

        for (NSURL *URL in URLs)
        {
            [composeController addURL:URL];
        }

        for (UIImage *image in images)
        {
            [composeController addImage:image];
        }

        composeController.completionHandler = ^(SLComposeViewControllerResult result) {
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.sharingCompleted)
            {
                self.sharingCompleted((result == SLComposeViewControllerResultDone), network);
            }
        };

        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:composeController animated:YES completion:nil];
        });
    }
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Delegation - MFMailComposeViewController

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];

    if (self.sharingCompleted)
    {
        self.sharingCompleted((result == MFMailComposeResultSent || result == MFMailComposeResultSaved), emailSharingService);
    }
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Delegation - MFMessageComposeViewController

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (self.sharingCompleted)
    {
        self.sharingCompleted(result == MessageComposeResultSent, textMessageSharingService);
    }
}

@end
