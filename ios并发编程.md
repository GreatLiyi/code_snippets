## OSSpinLock

``` objc
static OSSpinLock aspect_lock = OS_SPINLOCK_INIT;
OSSpinLockLock(&aspect_lock);
block();
OSSpinLockUnlock(&aspect_lock);
```
