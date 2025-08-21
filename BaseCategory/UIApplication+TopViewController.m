#import "UIApplication+TopViewController.h"

@implementation UIApplication (TopViewController)
+ (UIViewController *)topViewController:(UIViewController *)viewController {
    if (!viewController) {
        viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = (UINavigationController *)viewController;
        return [UIApplication topViewController:viewController.visibleViewController];
    }
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        viewController = (UITabBarController *)viewController;
        return [UIApplication topViewController:viewController.selectedViewController];
    }
    if (viewController.presentedViewController) {
        return [UIApplication topViewController:viewController.presentedViewController];
    }
    return viewController;
}
@end