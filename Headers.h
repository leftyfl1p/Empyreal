@interface SBApplication : NSObject
- (id)bundleIdentifier;
@end

@interface SBApplicationController : NSObject 
+ (id)sharedInstance;
- (SBApplication *)applicationWithBundleIdentifier:(id)arg1;
@end

@interface SBLockScreenViewController
- (id)lockScreenBottomLeftAppController;
- (void)loadView;
@end

@interface SBLockScreenSlideUpToAppController : NSObject
- (void)setTargetApp:(id)arg1 withAppSuggestion:(id)arg2;

//iOS8
-(void)setTargetApp:(id)app withLSInfo:(id)lsinfo;
@end

//iOS8
@interface LSBestAppSuggestion : NSObject
@end

@interface SBBestAppSuggestion : NSObject
- (NSString *)bundleIdentifier;
@end

@interface _SBExpertAppSuggestion : SBBestAppSuggestion
- (id)initWithAppSuggestion:(id)arg1 result:(id)arg2;
@end

@interface _DECAppItem : NSObject
+ (id)appWithBundleIdentifier:(id)arg1;
@end

@interface SBDeckSwitcherViewController : UIViewController
@property(retain, nonatomic) SBBestAppSuggestion *bestAppSuggestion;
- (void)viewDidLoad;
@end

@interface SBSwitcherAppSuggestionBottomBannerView : UIView
@property(readonly, retain, nonatomic) SBBestAppSuggestion *representedAppSuggestion;
- (id)_descriptionStringForSuggestion:(id)arg1;
@end