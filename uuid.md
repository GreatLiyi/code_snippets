CFUUIDRef udid = CFUUIDCreate(NULL);
NSString *udidString = (NSString *) CFUUIDCreateString(NULL, udid);
UPDATE:

As of iOS 6, there is an easier way to generate UUID. And as usual, there are multiple ways to do it:

Create a UUID string:

NSString *uuid = [[NSUUID UUID] UUIDString];
