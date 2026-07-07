#import <UIKit/UIKit.h>

@interface SMSAgentViewController : UIViewController

@property (nonatomic, strong) UITextView *phoneNumbersTextView;
@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UILabel *statusLabel;

- (void)sendSMS;

@end
