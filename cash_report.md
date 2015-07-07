## type of crash reports

### iPhone OS policy

- watchdog timeout: 未能在制定的timeout时间内launch/resume/suspend/quit
exception codes: 0x8badf00d
- user force-quit
exception codes: 0xdeadfa11
- low memory-termination
对后台的应用调用low memory notification，若还是不足，会terminate active application.
原则：
 + respect low memory notification
 + release objects that can be reconstructed
 + release cached objects
### application crashes due to bugs
common crashes:
- over released objects
- null pointer dereference
- insert nil objects


### crash reports location
Mac OS X: ~/Library/Logs/CrashReporter/MobileDevice/

SIGABRT, exception type=EXC_CRASH
crash线程本身只有main相关的信息，没有具体的错误信息。此时需要通过其他线程查找问题。查找带kill,abort方法的线程。
