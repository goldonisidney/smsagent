#import "FontChangerViewController.h"
#import <spawn.h>

extern char **environ;

static void respringDevice(void) {
    pid_t pid;
    const char *args[] = {"killall", "-9", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, environ);
}

@interface FontChangerViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *availableFonts;
@property (nonatomic, strong) NSString *selectedFont;
@property (nonatomic, strong) UILabel *previewLabel;
@end

@implementation FontChangerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Font Changer";
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    self.selectedFont = [[NSUserDefaults standardUserDefaults] stringForKey:@"com.fontchanger.selectedfont"] ?: @"";

    [self loadAvailableFonts];
    [self setupUI];
}

- (void)loadAvailableFonts {
    // Fontes populares disponíveis no iOS
    self.availableFonts = @[
        @"Padrão do Sistema",
        @"AcademyEngravedLetPlain",
        @"AmericanTypewriter",
        @"AmericanTypewriter-Bold",
        @"AmericanTypewriter-Condensed",
        @"AppleSDGothicNeo-Regular",
        @"Arial-BoldMT",
        @"ArialMT",
        @"ArialRoundedMTBold",
        @"Avenir-Book",
        @"Avenir-Heavy",
        @"Avenir-Light",
        @"AvenirNext-Regular",
        @"AvenirNext-Bold",
        @"AvenirNext-DemiBold",
        @"Baskerville",
        @"Baskerville-Bold",
        @"Baskerville-Italic",
        @"ChalkboardSE-Regular",
        @"ChalkboardSE-Bold",
        @"Chalkduster",
        @"Cochin",
        @"Cochin-Bold",
        @"Copperplate",
        @"Copperplate-Bold",
        @"Courier",
        @"Courier-Bold",
        @"CourierNewPS-BoldMT",
        @"CourierNewPSMT",
        @"DINAlternate-Bold",
        @"DINCondensed-Bold",
        @"Didot",
        @"Didot-Bold",
        @"EuphemiaUCAS",
        @"Futura-Medium",
        @"Futura-Bold",
        @"GillSans",
        @"GillSans-Bold",
        @"GillSans-Italic",
        @"Georgia",
        @"Georgia-Bold",
        @"Helvetica",
        @"Helvetica-Bold",
        @"HelveticaNeue",
        @"HelveticaNeue-Bold",
        @"HelveticaNeue-Light",
        @"HelveticaNeue-Thin",
        @"HiraKakuProN-W3",
        @"HoeflerText-Regular",
        @"IowanOldStyle-Roman",
        @"KohinoorDevanagari-Regular",
        @"Menlo-Regular",
        @"Menlo-Bold",
        @"MarkerFelt-Thin",
        @"MarkerFelt-Wide",
        @"Noteworthy-Light",
        @"Noteworthy-Bold",
        @"Optima-Regular",
        @"Optima-Bold",
        @"Palatino-Roman",
        @"Palatino-Bold",
        @"Papyrus",
        @"PartyLetPlain",
        @"SavoyeLetPlain",
        @"SnellRoundhand",
        @"TimesNewRomanPSMT",
        @"TimesNewRomanPS-BoldMT",
        @"Trebuchet-BoldItalic",
        @"TrebuchetMS",
        @"TrebuchetMS-Bold",
        @"Verdana",
        @"Verdana-Bold",
        @"ZapfDingbatsITC",
        @"Zapfino",
    ];
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 12;
    stack.layoutMargins = UIEdgeInsetsMake(16, 16, 16, 16);
    stack.layoutMarginsRelativeArrangement = YES;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:stack];

    // Preview card
    UIView *previewCard = [[UIView alloc] init];
    previewCard.backgroundColor = [UIColor secondarySystemBackgroundColor];
    previewCard.layer.cornerRadius = 12;
    previewCard.translatesAutoresizingMaskIntoConstraints = NO;

    self.previewLabel = [[UILabel alloc] init];
    self.previewLabel.text = @"Abc 123 iOS Font Preview\nAa Bb Cc Dd Ee Ff";
    self.previewLabel.numberOfLines = 2;
    self.previewLabel.textAlignment = NSTextAlignmentCenter;
    self.previewLabel.font = [UIFont systemFontOfSize:20];
    self.previewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [previewCard addSubview:self.previewLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.previewLabel.topAnchor constraintEqualToAnchor:previewCard.topAnchor constant:16],
        [self.previewLabel.bottomAnchor constraintEqualToAnchor:previewCard.bottomAnchor constant:-16],
        [self.previewLabel.leadingAnchor constraintEqualToAnchor:previewCard.leadingAnchor constant:16],
        [self.previewLabel.trailingAnchor constraintEqualToAnchor:previewCard.trailingAnchor constant:-16],
    ]];

    [stack addArrangedSubview:previewCard];

    // Label
    UILabel *chooseLabel = [[UILabel alloc] init];
    chooseLabel.text = @"Escolha uma Fonte:";
    chooseLabel.font = [UIFont boldSystemFontOfSize:16];
    [stack addArrangedSubview:chooseLabel];

    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.scrollEnabled = NO;
    [self.tableView.heightAnchor constraintEqualToConstant:self.availableFonts.count * 56].active = YES;
    [stack addArrangedSubview:self.tableView];

    // Reset Button
    UIButton *resetButton = [[UIButton alloc] init];
    [resetButton setTitle:@"Resetar para Fonte Padrão" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor systemRedColor] forState:UIControlStateNormal];
    resetButton.backgroundColor = [UIColor secondarySystemBackgroundColor];
    resetButton.layer.cornerRadius = 10;
    resetButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [resetButton.heightAnchor constraintEqualToConstant:50].active = YES;
    [resetButton addTarget:self action:@selector(resetFont) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:resetButton];

    // Apply Button
    UIButton *applyButton = [[UIButton alloc] init];
    [applyButton setTitle:@"Aplicar e Respring" forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.backgroundColor = [UIColor systemBlueColor];
    applyButton.layer.cornerRadius = 10;
    applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [applyButton.heightAnchor constraintEqualToConstant:50].active = YES;
    [applyButton addTarget:self action:@selector(applyFont) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:applyButton];

    // Constraints
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [stack.topAnchor constraintEqualToAnchor:scrollView.topAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor],
        [stack.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor],
    ]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.availableFonts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FontCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FontCell"];
    }

    NSString *fontName = self.availableFonts[indexPath.row];

    if (indexPath.row == 0) {
        cell.textLabel.text = fontName;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.text = @"Fonte original do iOS";
    } else {
        cell.textLabel.text = fontName;
        UIFont *previewFont = [UIFont fontWithName:fontName size:16];
        cell.textLabel.font = previewFont ?: [UIFont systemFontOfSize:16];
        cell.detailTextLabel.text = fontName;
    }

    if ([fontName isEqualToString:self.selectedFont] ||
        (self.selectedFont.length == 0 && indexPath.row == 0)) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *fontName = indexPath.row == 0 ? @"" : self.availableFonts[indexPath.row];
    self.selectedFont = fontName;

    if (fontName.length > 0) {
        UIFont *previewFont = [UIFont fontWithName:fontName size:20];
        self.previewLabel.font = previewFont ?: [UIFont systemFontOfSize:20];
    } else {
        self.previewLabel.font = [UIFont systemFontOfSize:20];
    }

    [tableView reloadData];
}

- (void)applyFont {
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedFont forKey:@"com.fontchanger.selectedfont"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Fonte Aplicada!"
        message:@"O iPhone vai fazer Respring para aplicar a nova fonte."
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Aplicar e Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        respringDevice();
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)resetFont {
    self.selectedFont = @"";
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.fontchanger.selectedfont"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.previewLabel.font = [UIFont systemFontOfSize:20];
    [self.tableView reloadData];

    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Fonte Resetada!"
        message:@"Toque em Aplicar e Respring para voltar à fonte padrão."
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
