UIViewController+Sharing
========================

The easiest way to share from your app to anywhere, because you've got so much to say!

`UIViewController+Sharing` supports sharing text, URLs, images, and attachments, all through Apple's frameworks. No more implementing your own `MFMailComposeViewController` delegate, or `SLServiceBlahBlahBlah`.

> Enough talk though, show me code...

Said some impatient brat.

    if (self.canShareViaFacebook) {
        self.shareViaFacebookWithMessage("I've got so much to say!", withImages: [ UIImage(named:"sunglasses.png") ], withURLs: [ myCoolURL ])
    } else {
        ¯\_(ツ)_/¯ // Do whatever the hell you want
    }

It's as simple as that.


You can check out all the sharing choices are below.

```
- (void)shareViaActivityController:(NSArray *)excludedActivityTypes activityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities completionWithItemsHandler:(void (^)(NSString *activityType, BOOL completed, NSArray * __returnedItems, NSError * __activityError))completion;
- (void)shareViaTextWithMessage:(NSString *)message attachments:(NSArray *)attachments;
- (void)shareViaEmailWithSubject:(NSString *)subject withMessage:(NSString *)message isHTML:(BOOL)HTML toRecepients:(NSArray *)recepients ccRecepients:(NSArray *)ccRecepients bccRecepients:(NSArray *)bccRecepients attachments:(NSArray *)attachments;
- (void)shareViaFacebookWithMessage:(NSString *)message withImages:(NSArray *)images withURLs:(NSArray *)URLs;
- (void)shareViaTwitterWithMessage:(NSString *)message withImages:(NSArray *)images withURLs:(NSArray *)URLs;
- (void)shareViaSinaWeiboWithMessage:(NSString *)message withImages:(NSArray *)images withURLs:(NSArray *)URLs;
- (void)shareViaTencentWeiboWithMessage:(NSString *)message withImages:(NSArray *)images withURLs:(NSArray *)URLs;
- (void)shareViaCopyString:(NSString *)string;
- (void)shareViaCopyURL:(NSURL *)URL;
```

Customizing the navigation bar for `MFMailComposeViewController` and `MFMessageComposeViewController` is such a pain... But not any more. Just set a couple properties and when you share, it will implement your fun look and feel. And when you're done, no harm no foul, everything gets reset.

```
@property (nonatomic, copy) UIColor * barButtonItemTintColor;
@property (nonatomic, copy) NSDictionary * titleTextAttributes;
```


Callbacks when your sharing completes are great, for example if you'd like to track analytics on where people are sharing, if you're creepy like that.

```
@property (nonatomic, copy) void  (^sharingCompleted)(BOOL success, NSString * sharingService);
```


`UIViewController+Sharing` is uses `nonnull` and `nullable` annotations, so it plays very nicely with your Swift or Objective-C code.


I've run out of words, so go and use the library!
