#import <UIKit/UIKit.h>
#import "SMSAgentViewController.h"

@interface SpringBoard : UIApplication
@end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self showSMSAgentWindow];
    });
}

- (void)showSMSAgentWindow {
    SMSAgentViewController *controller = [[SMSAgentViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window.rootViewController presentViewController:navController animated:YES completion:nil];
}

%end

%ctor {
    NSLog(@"[SMS Agent] Tweak carregado com sucesso!");
}
