#import "SMSAgentViewController.h"
#import <MessageUI/MessageUI.h>

@interface SMSAgentViewController () <MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) NSArray *phoneNumbers;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isSending;
@end

@implementation SMSAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"SMS Agent";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissController)];

    self.phoneNumbers = @[];
    self.currentIndex = 0;
    self.isSending = NO;

    [self setupUI];
}

- (void)setupUI {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 12;
    stackView.layoutMargins = UIEdgeInsetsMake(16, 16, 16, 16);
    stackView.layoutMarginsRelativeArrangement = YES;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:stackView];

    // Label: Números de Telefone
    UILabel *phonesLabel = [[UILabel alloc] init];
    phonesLabel.text = @"Números de Telefone (um por linha):";
    phonesLabel.font = [UIFont boldSystemFontOfSize:14];
    [stackView addArrangedSubview:phonesLabel];

    // TextView: Números de Telefone
    self.phoneNumbersTextView = [[UITextView alloc] init];
    self.phoneNumbersTextView.layer.borderColor = [UIColor systemGrayColor].CGColor;
    self.phoneNumbersTextView.layer.borderWidth = 1;
    self.phoneNumbersTextView.layer.cornerRadius = 8;
    self.phoneNumbersTextView.font = [UIFont systemFontOfSize:14];
    self.phoneNumbersTextView.heightAnchor.constant = 120;
    [self.phoneNumbersTextView.heightAnchor constraintEqualToConstant:120].active = YES;
    [stackView addArrangedSubview:self.phoneNumbersTextView];

    // Label: Mensagem
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = @"Mensagem:";
    messageLabel.font = [UIFont boldSystemFontOfSize:14];
    [stackView addArrangedSubview:messageLabel];

    // TextView: Mensagem
    self.messageTextView = [[UITextView alloc] init];
    self.messageTextView.layer.borderColor = [UIColor systemGrayColor].CGColor;
    self.messageTextView.layer.borderWidth = 1;
    self.messageTextView.layer.cornerRadius = 8;
    self.messageTextView.font = [UIFont systemFontOfSize:14];
    [self.messageTextView.heightAnchor constraintEqualToConstant:100].active = YES;
    [stackView addArrangedSubview:self.messageTextView];

    // Status Label
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"Pronto para enviar";
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    self.statusLabel.textColor = [UIColor systemGreenColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [stackView addArrangedSubview:self.statusLabel];

    // Send Button
    self.sendButton = [[UIButton alloc] init];
    [self.sendButton setTitle:@"Enviar SMS" forState:UIControlStateNormal];
    [self.sendButton setBackgroundColor:[UIColor systemBlueColor]];
    self.sendButton.layer.cornerRadius = 8;
    self.sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.sendButton addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton.heightAnchor constraintEqualToConstant:50].active = YES;
    [stackView addArrangedSubview:self.sendButton];

    // Constraints
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [stackView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

- (void)sendSMS {
    if (self.isSending) {
        self.statusLabel.text = @"Envio em andamento...";
        self.statusLabel.textColor = [UIColor systemOrangeColor];
        return;
    }

    NSString *phonesText = self.phoneNumbersTextView.text;
    NSString *message = self.messageTextView.text;

    if (phonesText.length == 0) {
        self.statusLabel.text = @"⚠️ Adicione números!";
        self.statusLabel.textColor = [UIColor systemRedColor];
        return;
    }

    if (message.length == 0) {
        self.statusLabel.text = @"⚠️ Escreva uma mensagem!";
        self.statusLabel.textColor = [UIColor systemRedColor];
        return;
    }

    self.phoneNumbers = [phonesText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    self.phoneNumbers = [self.phoneNumbers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.length > 0"]];

    if (self.phoneNumbers.count == 0) {
        self.statusLabel.text = @"⚠️ Nenhum número válido!";
        self.statusLabel.textColor = [UIColor systemRedColor];
        return;
    }

    self.currentIndex = 0;
    self.isSending = YES;
    self.sendButton.enabled = NO;
    self.sendButton.alpha = 0.5;

    [self sendNextSMS];
}

- (void)sendNextSMS {
    if (self.currentIndex >= self.phoneNumbers.count) {
        self.statusLabel.text = [NSString stringWithFormat:@"✅ %lu SMS enviados!", (unsigned long)self.phoneNumbers.count];
        self.statusLabel.textColor = [UIColor systemGreenColor];
        self.isSending = NO;
        self.sendButton.enabled = YES;
        self.sendButton.alpha = 1.0;
        return;
    }

    NSString *phone = [self.phoneNumbers[self.currentIndex] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        messageController.recipients = @[phone];
        messageController.body = self.messageTextView.text;

        [self presentViewController:messageController animated:NO completion:nil];
    } else {
        self.statusLabel.text = @"❌ SMS não disponível!";
        self.statusLabel.textColor = [UIColor systemRedColor];
        self.isSending = NO;
        self.sendButton.enabled = YES;
        self.sendButton.alpha = 1.0;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:NO completion:nil];

    if (result == MessageComposeResultSent) {
        self.statusLabel.text = [NSString stringWithFormat:@"Enviando... %lu/%lu", (unsigned long)(self.currentIndex + 1), (unsigned long)self.phoneNumbers.count];
        self.statusLabel.textColor = [UIColor systemBlueColor];
    }

    self.currentIndex++;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self sendNextSMS];
    });
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
