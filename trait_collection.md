# trait collection
想要创建自适应的界面(adaptive interface)，你的代码要根据trait的变化来调整app的布局。
iOS 通过UITraitEnviroment protocol的属性traitCollection提供访问trait环境的方式。下面几个类都实现了这个协议：UIScreen, UIWindow, UIViewController, UIPresentationController, and UIView. 并提供以下属性来访问具体的特征值（trait values）
- horizontalSizeClass
- verticalSizeClass
- displayScale //1.0 indicate a non-retina display, 2.0 indicate a retina display
- userInterfaceIdiom //UIUserInterfaceIdiomPhone/Pad/Unspecified

想要你的view controller和views能够根据iOS设备界面的变化而变化，你需要override traitCollectionDidChange:方法。想要根据界面变化来自定义view controller的动画，需要override UIContentContainer协议的方法 willTransitionToTraitCollection:withTransitionCoordinator:

## rotation time line(form WWDC 2015)
这套机制的好处在于旋转(rotation)和多任务变形(multitasking resize)都适用。需要注意的是不能假设所有以下方法都会被执行，有些情况只有部分方法执行（具体有待研究）。
- setup, willTransitionToTraitCollection viewWillTransitionToSize
<- size change, traitCollectionDidChange
- create animations, animationAlongsideTransition
- run animations
- cleanup, completion
