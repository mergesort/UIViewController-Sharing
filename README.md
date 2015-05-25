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
func shareViaActivityController(excludedActivityTypes: [AnyObject]?, activityItems: [AnyObject]?, applicationActivities: [AnyObject]?, completionWithItemsHandler completion: ((String, Bool, [AnyObject]?, NSError?) -> Void)?)
func shareViaTextWithMessage(message: String?, attachments: [AnyObject]?)
func shareViaEmailWithSubject(subject: String?, withMessage message: String?, isHTML HTML: Bool, toRecepients recepients: [AnyObject]?, ccRecepients: [AnyObject]?, bccRecepients: [AnyObject]?, attachments: [AnyObject]?)
func shareViaFacebookWithMessage(message: String?, withImages images: [AnyObject]?, withURLs URLs: [AnyObject]?)
func shareViaTwitterWithMessage(message: String?, withImages images: [AnyObject]?, withURLs URLs: [AnyObject]?)
func shareViaSinaWeiboWithMessage(message: String?, withImages images: [AnyObject]?, withURLs URLs: [AnyObject]?)
func shareViaTencentWeiboWithMessage(message: String?, withImages images: [AnyObject]?, withURLs URLs: [AnyObject]?)
func shareViaCopyString(string: String?)
func shareViaCopyURL(URL: NSURL?)
```

Customizing the navigation bar for `MFMailComposeViewController` and `MFMessageComposeViewController` is such a pain... But not any more. Just set a couple properties and when you share, it will implement your fun look and feel. And when you're done, no harm no foul, everything gets reset.

```
var barButtonItemTintColor: UIColor?
var titleTextAttributes: [NSObject : AnyObject]?
```

Callbacks when your sharing completes are great, for example if you'd like to track analytics on where people are sharing, if you're creepy like that.

```
var sharingCompleted: ((Bool, String) -> Void)?
```

`UIViewController+Sharing` is uses `nonnull` and `nullable` annotations, so it plays very nicely with your Swift or Objective-C code.

I've run out of words, so go and use the library!
