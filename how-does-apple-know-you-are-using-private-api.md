[sto](http://stackoverflow.com/questions/2842357/how-does-apple-know-you-are-using-private-api)

There are 3 ways I know. These are just some speculation, since I do not work in the Apple review team.

1. otool -L

This will list all libraries the app has linked to. Something clearly you should not use, like IOKit and WebKit can be detected by this.

2. nm -u

This will list all linked symbols. This can detect

Undocumented C functions such as _UIImageWithName;
Objective-C classes such as UIProgressHUD
Ivars such as UITouch._phase (which could be the cause of rejection of Three20-based apps last few months.)
3. Listing Objective-C selectors, or strings

Objective-C selectors are stored in a special region of the binary, and therefore Apple could extract the content from there, and check if you've used some undocumented Objective-C methods, such as -[UIDevice setOrientation:].

Since selectors are independent from the class you're messaging, even if your custom class defines -setOrientation: irrelevant to UIDevice, there will be a possibility of being rejected.

You could use Erica Sadun's APIKit to detect potential rejection due to (false alarms of) private APIs.

(If you really really really really want to workaround these checks, you could use runtime features such as

- dlopen, dlsym
- objc_getClass, sel_registerName, objc_msgSend
- valueForKey:; object_getInstanceVariable, object_getIvar, etc.
to get those private libraries, classes, methods and ivars. )
