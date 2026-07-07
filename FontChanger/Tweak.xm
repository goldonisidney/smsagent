#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

static NSString* getSelectedFont() {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"com.fontchanger.selectedfont"] ?: @"";
}

%hook UIFont

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    NSString *fontName = getSelectedFont();
    if (fontName.length > 0) {
        UIFont *customFont = [UIFont fontWithName:fontName size:fontSize];
        if (customFont) return customFont;
    }
    return %orig;
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    NSString *fontName = getSelectedFont();
    if (fontName.length > 0) {
        UIFont *customFont = [UIFont fontWithName:[fontName stringByAppendingString:@"-Bold"] size:fontSize];
        if (customFont) return customFont;
        customFont = [UIFont fontWithName:fontName size:fontSize];
        if (customFont) return customFont;
    }
    return %orig;
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize weight:(UIFontWeight)weight {
    NSString *fontName = getSelectedFont();
    if (fontName.length > 0) {
        UIFont *customFont = [UIFont fontWithName:fontName size:fontSize];
        if (customFont) return customFont;
    }
    return %orig;
}

%end

%ctor {
    NSLog(@"[FontChanger] Tweak carregado!");
}
