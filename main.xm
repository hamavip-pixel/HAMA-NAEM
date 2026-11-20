#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

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

static UIWindow *GetActivePubgWindow(void) {
    NSSet<UIScene *> *scenes = [UIApplication sharedApplication].connectedScenes;
    for (UIScene *scene in scenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *ws = (UIWindowScene *)scene;
            if (ws.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *win in ws.windows) {
                    if (win.isKeyWindow) {
                        return win;
                    }
                }
                if (ws.windows.count > 0) {
                    return ws.windows.firstObject;
                }
            }
        }
    }
    for (UIScene *scene in scenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *ws = (UIWindowScene *)scene;
            if (ws.windows.count > 0) {
                return ws.windows.firstObject;
            }
        }
    }
    return nil;
}

static void RenderHamaBanner(void) {
    UIWindow *win = GetActivePubgWindow();
    if (!win) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            RenderHamaBanner();
        });
        return;
    }

    NSInteger bannerTag = 778899;
    if ([win viewWithTag:bannerTag]) return;

    CGFloat w = 240.0;
    CGFloat h = 52.0;
    CGFloat x = (win.bounds.size.width - w) / 2.0;
    CGFloat y = 34.0;

    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    box.tag = bannerTag;
    box.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    box.layer.cornerRadius = 10.0;
    box.userInteractionEnabled = NO;

    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, w, 24)];
    titleLbl.text = @"HAMA - IOS";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont boldSystemFontOfSize:18];
    titleLbl.textColor = [UIColor whiteColor];
    [box addSubview:titleLbl];

    UILabel *tgLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, w, 20)];
    tgLbl.text = @"Telegram.hama_vip1";
    tgLbl.textAlignment = NSTextAlignmentCenter;
    tgLbl.font = [UIFont boldSystemFontOfSize:13];
    tgLbl.textColor = [UIColor colorWithRed:1.0 green:0.12 blue:0.24 alpha:1.0];
    [box addSubview:tgLbl];

    [win addSubview:box];
}

%ctor {
    @autoreleasepool {
        NSString *ver = nil;
        if (!IsSupportedPubgBundle(&ver)) {
            return;
        }
        NSLog(@"[HAMA - IOS] PUBG Version: %@", ver);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            RenderHamaBanner();
        });
    }
}
