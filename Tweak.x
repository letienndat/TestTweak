#import <UIKit/UIKit.h>
#import "BaseCategory/UIApplication+TopViewController.h"

@interface SBIconView : UIView
@end

%hook SBIconView

- (void)didMoveToSuperview {
    %log;
    %orig;
    self.alpha = 0.5;
}

- (void)setAlpha:(CGFloat)alpha {
    %log;
    %orig(0.5);
}

@interface BCBatteryDevice: NSObject

@property (copy, nonatomic) NSString *name;
@property (nonatomic) long long percentCharge;

@end

@interface BCBatteryDeviceController: NSObject

@property (readonly, copy, nonatomic) NSArray *connectedDevices;

+ (id)sharedInstance;

@end

%end

%hook UIViewController

- (void) presentViewController:(UIViewController *) viewControllerToPresent 
                      animated:(BOOL) flag 
                    completion:(void (^)()) completion {
    %log;
    if ([viewControllerToPresent isKindOfClass: [UIAlertController class]]) {
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        BCBatteryDeviceController *sharedInstance = [%c(BCBatteryDeviceController) sharedInstance];

        NSMutableString *mutableString = [NSMutableString new];
        for (BCBatteryDevice *battery in sharedInstance.connectedDevices) {
            NSString *batteryName = battery.name;
            NSString *batteryPercentCharge = [NSString stringWithFormat:@"%lld%%", battery.percentCharge];

            [mutableString appendFormat:@"Pin: %@ - Phần trăm: %@\n", batteryName, batteryPercentCharge];
        }

        alertController.message = mutableString;

        return %orig(alertController, flag, completion);
    }
    return %orig;
}

%end