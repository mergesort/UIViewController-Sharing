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

NSString * const textMessageSharingService = @"text_message";
NSString * const emailSharingService = @"email";
NSString * const twitterSharingService = @"twitter";
NSString * const facebookSharingService = @"facebook";
NSString * const sinaWeiboSharingService = @"sina_weibo";
NSString * const tencentWeiboSharingService = @"tencent_weibo";
NSString * const cancelledSharingService = @"cancelled";


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
#pragma mark - Handle sharing

- (void)shareViaTextWithMessage:(NSString *)message
{
    if (self.canShareViaText)
    {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        messageController.body = message;
        [self presentViewController:messageController animated:YES completion:nil];
    }
}

- (void)shareViaEmailWithSubject:(NSString *)subject withMessage:(NSString *)message isHTML:(BOOL)HTML toRecepients:(NSArray *)recepients ccRecepients:(NSArray *)ccRecepients bccRecepients:(NSArray *)bccRecepients
{
    if (self.canShareViaEmail)
    {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setSubject:subject];
        [mailController setMessageBody:message isHTML:HTML];
        [mailController setToRecipients:recepients];
        [mailController setCcRecipients:ccRecepients];
        [mailController setBccRecipients:bccRecepients];
        mailController.mailComposeDelegate = self;
        [self presentViewController:mailController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Looks like you don't have email set up.", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Bummer", nil) otherButtonTitles:nil];
        [alert show];
    }
}

- (void)shareViaFacebookWithMessage:(NSString *)message withImage:(UIImage *)image
{
    if (self.canShareViaFacebook)
    {
        [self shareViaSLComposeViewController:SLServiceTypeFacebook withMessage:message withImage:image];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Looks like you don't have Facebook set up. You can do so in the iPhone's Settings", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Bummer", nil) otherButtonTitles:nil];
        [alert show];
    }
}

- (void)shareViaTwitterWithMessage:(NSString *)message withImage:(UIImage *)image
{
    if (self.canShareViaTwitter)
    {
        [self shareViaSLComposeViewController:SLServiceTypeTwitter withMessage:message withImage:image];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Looks like you don't have Twitter set up. You can do so in the iPhone's Settings", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Bummer", nil) otherButtonTitles:nil];
        [alert show];
    }
}

- (void)shareViaSinaWeiboWithMessage:(NSString *)message withImage:(UIImage *)image
{
    if (self.canShareViaSinaWeibo)
    {
        [self shareViaSLComposeViewController:SLServiceTypeSinaWeibo withMessage:message withImage:image];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Looks like you don't have Sina Weibo set up. You can do so in the iPhone's Settings", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Bummer", nil) otherButtonTitles:nil];
        [alert show];
    }
}

- (void)shareViaTencentWeiboWithMessage:(NSString *)message withImage:(UIImage *)image
{
    if (self.canShareViaTencentWeibo)
    {
        [self shareViaSLComposeViewController:SLServiceTypeTencentWeibo withMessage:message withImage:image];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Looks like you don't have Tencent Weibo set up. You can do so in the iPhone's Settings", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Bummer", nil) otherButtonTitles:nil];
        [alert show];
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

- (void)shareViaSLComposeViewController:(NSString *)network withMessage:(NSString *)message withImage:(UIImage *)image
{
    NSString *initialText = message;
    
    if ([SLComposeViewController isAvailableForServiceType:network])
    {
        SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:network];
        [composeController setInitialText:initialText];
        if (image)
        {
            [composeController addImage:image];
        }

        composeController.completionHandler = ^(SLComposeViewControllerResult result) {
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.sharingCompleted)
            {
                self.sharingCompleted((result == SLComposeViewControllerResultDone), [UIViewController serviceForNetwork:network]);
            }
        };
        [self presentViewController:composeController animated:YES completion:nil];
    }
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Sharing Delegates

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultFailed)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error sending email!", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Bummer", nil) otherButtonTitles:nil];
        [alert show];
    }

    if (self.sharingCompleted)
    {
        self.sharingCompleted((result != MFMailComposeResultFailed), emailSharingService);
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultFailed)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred sending this message" message:nil delegate:self cancelButtonTitle:@"Sorry :(" otherButtonTitles:nil, nil];
        [alert show];
    }

    if (self.sharingCompleted)
    {
        self.sharingCompleted((result != MessageComposeResultFailed), textMessageSharingService);
    }
}

+ (NSString *)serviceForNetwork:(NSString *)network
{
    NSString *service = nil;

    if ([network isEqualToString:SLServiceTypeTwitter])
    {
        service = twitterSharingService;
    }
    else if ([network isEqualToString:SLServiceTypeFacebook])
    {
        service = facebookSharingService;
    }
    else if ([network isEqualToString:SLServiceTypeSinaWeibo])
    {
        service = sinaWeiboSharingService;
    }
    else if ([network isEqualToString:SLServiceTypeTencentWeibo])
    {
        service = tencentWeiboSharingService;
    }

    return service;
}

@end
