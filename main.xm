#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static BOOL IsSupportedPubgBundle(NSString **versionLabelOut) {
    NSString *bid = [[NSBundle mainBundle] bundleIdentifier] ?: @"";

    // 1. فلاش (Flash)
    if ([bid containsString:@"iglite"] || [bid containsString:@"flash"]) {
        if (versionLabelOut) *versionLabelOut = @"FLASH";
        return YES;
    }
    // 2. گلۆباڵ (Global)
    if ([bid isEqualToString:@"com.tencent.ig"]) {
        if (versionLabelOut) *versionLabelOut = @"GLOBAL";
        return YES;
    }
    // 3. تایوانی (Taiwan)
    if ([bid containsString:@"rekoo"] || [bid isEqualToString:@"com.pubg.twmobile"]) {
        if (versionLabelOut) *versionLabelOut = @"TAIWAN";
        return YES;
    }
    // 4. کۆری (Korea)
    if ([bid containsString:@"krmobile"] || [bid isEqualToString:@"com.pubg.krmobile"]) {
        if (versionLabelOut) *versionLabelOut = @"KOREA";
        return YES;
    }
    // 5. ڤێتنامی (Vietnam)
    if ([bid containsString:@"vng"] || [bid isEqualToString:@"com.vng.pubgmobile"]) {
        if (versionLabelOut) *versionLabelOut = @"VIETNAM";
        return YES;
    }

    return NO;
}

static void ShowHamaOverlay(void) {
    UIWindow *targetWindow = nil;
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *w in scene.windows) {
                if (w.isKeyWindow) {
                    targetWindow = w;
                    break;
                }
            }
        }
        if (targetWindow) break;
    }
    if (!targetWindow) {
        targetWindow = [UIApplication sharedApplication].keyWindow;
    }
    if (!targetWindow) return;

    NSInteger tagId = 987654;
    if ([targetWindow viewWithTag:tagId]) return;

    CGFloat boxWidth = 240.0;
    CGFloat boxHeight = 52.0;
    UIView *banner = [[UIView alloc] initWithFrame:CGRectMake((targetWindow.bounds.size.width - boxWidth) / 2.0, 36.0, boxWidth, boxHeight)];
    banner.tag = tagId;
    banner.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    banner.layer.cornerRadius = 10.0;
    banner.userInteractionEnabled = NO;

    UILabel *mainText = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, boxWidth, 24)];
    mainText.text = @"HAMA - IOS";
    mainText.textAlignment = NSTextAlignmentCenter;
    mainText.font = [UIFont boldSystemFontOfSize:18];
    mainText.textColor = [UIColor whiteColor];
    [banner addSubview:mainText];

    UILabel *tgText = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, boxWidth, 20)];
    tgText.text = @"Telegram.hama_vip1";
    tgText.textAlignment = NSTextAlignmentCenter;
    tgText.font = [UIFont boldSystemFontOfSize:13];
    tgText.textColor = [UIColor colorWithRed:1.0 green:0.12 blue:0.24 alpha:1.0]; // سووری ڕوون
    [banner addSubview:tgText];

    [targetWindow addSubview:banner];
}

%ctor {
    @autoreleasepool {
        NSString *verName = nil;
        if (!IsSupportedPubgBundle(&verName)) {
            return;
        }
        NSLog(@"[HAMA - IOS] Auto-detected PUBG version: %@", verName);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ShowHamaOverlay();
        });
    }
}
