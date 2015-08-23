## concept
core animation, animation is only one facet of the framework, originally called Layer Kit.
基本结构 layer tree

- views: rectangular object that displays content. view hierarchy
base class, UIView. UIView许多操作不是自己实现的，交给CALayer
- CALayer is not aware of `responder chain`(responder chain是基于view hierarchy,在一个iOS app中，subview->superview->topview->view controller->parent view controller's view, topview's superview->一直到top view controller->UIWindow->UIApplication)

## CALayer
backing layer: UIView's layer property
It's actually there backing layers that are responsible for the display and animation of everything you see onscreen. UIView is simply a wrapper, providing iOS-specific functionality such as touch handling and high-level interface for some Core Animation's low-level functionality.

理解UIView and CALayer结构分离的意义：职责分离
iOS and MacOS有不同的操作和界面
iOS   UIKit and UIView
MacOS AppKit and NSView

### CALayer没有暴露给UIView的功能
- drop shadows, rounded corners, and colored borders
- 3D transforms and positioning
- Nonrectangular bounds
- Alpha masking of content
- Multistep, nonlinear animations
