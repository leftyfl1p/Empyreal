#import "Headers.h"

#define isiOS9Up (kCFCoreFoundationVersionNumber >= 1217.11)
#define kPrefPath @"/User/Library/Preferences/com.leftyfl1p.empyreal.plist"
#define shouldShow (kEnabled && kSelectedAppID)

static NSString *kSelectedAppID = @"com.saurik.Cydia";
static BOOL kEnabled = YES;
static BOOL shouldOverride = NO;
static BOOL showInLS = YES;
static BOOL showInMultitasking = YES;
static NSString *suggestionName = @"Empyreal";
static NSMutableDictionary *prefs = nil;

%group iOS9

%hook SBDeckSwitcherViewController

- (void)viewDidLoad {
	%orig;
	if(shouldShow && showInMultitasking) {
		//app item to represent which application we want	
		_DECAppItem* appitem = [%c(_DECAppItem) appWithBundleIdentifier:kSelectedAppID];
		//create our new best app suggestion
		_SBExpertAppSuggestion *expertSuggesiton = [[%c(_SBExpertAppSuggestion) alloc] initWithAppSuggestion:appitem result:nil];
			//expertSuggesiton = [expertSuggesiton initWithAppSuggestion:appitem result:nil];
		//self.bestAppSuggestion = expertSuggesiton;
		//show the suggestion
		[self setBestAppSuggestion:expertSuggesiton];
	} else {
		[self setBestAppSuggestion:nil];
	}
}

-(void)setBestAppSuggestion:(id)arg1 {
	if(shouldOverride && shouldShow && showInMultitasking) {
		//make sure ios doesn't give replacement
		if(![((SBBestAppSuggestion *)arg1).bundleIdentifier isEqualToString:kSelectedAppID]) {
			//if app is different
			return;
		}
	}
	%orig;
}

%end

%hook SBLockScreenViewController

- (void)loadView {
	%orig;
	if (shouldShow && showInLS) {
	SBApplication* app = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:kSelectedAppID];
	//this just needs to exist
	SBBestAppSuggestion *suggestion = [%c(SBBestAppSuggestion) new];
	//show the app on the lockscreen
	[self.lockScreenBottomLeftAppController setTargetApp:app withAppSuggestion:suggestion];
	} else {
		//tweak disabled or no app selected; take the app off
		[self.lockScreenBottomLeftAppController setTargetApp:nil withAppSuggestion:nil];
	}
}

%end

%hook SBLockScreenSlideUpToAppController

- (void)setTargetApp:(id)arg1 withAppSuggestion:(id)arg2 {
	//make sure app isn't removed by system
	if(arg1 != nil || !kSelectedAppID) {
		if(shouldOverride && shouldShow && showInLS) {
			//make sure ios doesn't give replacement
			if(![((SBApplication *)arg1).bundleIdentifier isEqualToString:kSelectedAppID]) {
				//if app is different
				return;
			}
		}
		%orig;
	}
}

%end

%hook SBSwitcherAppSuggestionBottomBannerView

//custom description text in switcher
- (id)_descriptionStringForSuggestion:(id)arg1 {
	if(![self.representedAppSuggestion.bundleIdentifier isEqualToString:kSelectedAppID]) {
		//if app is different
		return %orig;
	}
	return ((shouldShow && showInLS)? suggestionName : %orig);
}

%end

%end //end iOS9 group


%group iOS8

%hook SBLockScreenViewController

- (void)loadView {
	%orig;
	//determine if we want to show our app
	if (shouldShow && showInLS) {
		//this represents which app we want to show
		SBApplication* app = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:kSelectedAppID];
		//this just needs to exist
		LSBestAppSuggestion *suggestion = [%c(LSBestAppSuggestion) new];
		//show the app on the lockscreen
		[self.lockScreenBottomLeftAppController setTargetApp:app withLSInfo:suggestion];
	} else {
		//tweak disabled or no app selected; take the app off
		[self.lockScreenBottomLeftAppController setTargetApp:nil withLSInfo:nil];
	}
}

%end

%hook SBLockScreenSlideUpToAppController

- (void)setTargetApp:(id)arg1 withLSInfo:(id)arg2 {
	//make sure app isn't removed by system
	if(arg1 != nil || !kSelectedAppID) {
		if(shouldOverride && shouldShow && showInLS) {
			//make sure ios doesn't give replacement
			if(![((SBApplication *)arg1).bundleIdentifier isEqualToString:kSelectedAppID]) {
				//if app is different
				return;
			}
		}
		%orig;
	}
}

%end


%end //end iOS8 group

//load/update all our preferences here
static void loadPrefs()
{
    prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:kPrefPath];
	kEnabled = prefs[@"enabled"] ? [prefs[@"enabled"] boolValue] : 1;
	shouldOverride = prefs[@"override"] ? [prefs[@"override"] boolValue] : 0;
	showInLS = prefs[@"showInLS"] ? [prefs[@"showInLS"] boolValue] : 1;
	showInMultitasking = prefs[@"showInMultitasking"] ? [prefs[@"showInMultitasking"] boolValue] : 1;
	suggestionName = [prefs[@"suggestionName"] length] != 0 ? prefs[@"suggestionName"] : @"Empyreal";

	/*	
		when there are no apps selected in settings the key is also removed
		so this is used is to make sure the default option stays until the
		user opens settings.
	*/
	//not sure if I need this check still
	if ([[NSFileManager defaultManager]fileExistsAtPath:kPrefPath]) {
		kSelectedAppID = ([prefs objectForKey:@"ALValue-"] ? [prefs objectForKey:@"ALValue-"] : nil);
	}

}

//method to receive notifications
static void receivedNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	loadPrefs();
}

%ctor {

	//figure out which group to load
	isiOS9Up ? (%init(iOS9)) : (%init(iOS8));

	CFNotificationCenterAddObserver(
		CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		receivedNotification,
		CFSTR("com.leftyfl1p.empyreal/settingschanged"),
		NULL,
		CFNotificationSuspensionBehaviorCoalesce);

	loadPrefs();
}
