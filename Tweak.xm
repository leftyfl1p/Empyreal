/*
Submission for tweak battles #3

Thanks to the following users who supported:

	@twodayslate
	Eric
	Borsato92
	cj81499
	winlogon0
	mootjeuh
	@redzrex
	Jason R.
	CONATH
	JimDotR
	Boris S
	Ziph0n
	Andrew
	/u/DervishSkater
	Corporal
	Acidschnee
	Josh Gibson
	HHumbert
	Cody
	Connor
	@sel2by3
	Shadow Games
	Pixxaddict
	platypusw90
	echo000
	Jonathan Gautreau 
	Blink
	ShaneSparkyYYZ
	kamikasky
	MaxD
	@tilgut
	@Beezure
	Matteo Piccina
	josh_boothman
	Moshe Siegel
	Ian L
	Torben
	MeatyCheetos
	@rauseo12
	Lei33
	K S LEE
	@RichResk
	wizage
	@sekrit_
	RushNY
	Maortega89
	@frkbmb_
	Kyle
	Robert
	@BrianOverly
	@thetomcanuck
	@pwned24k
	OhSpazz
	Jessyreynosa3
	Jessie mejia 
	Jp_delon
	dantesieg
	@codsane
	Alex S.

*/
#import "Headers.h"

#define isiOS9Up (kCFCoreFoundationVersionNumber >= 1217.11)
#define kPrefPath @"/User/Library/Preferences/com.leftyfl1p.empyreal.plist"
#define shouldShow (kEnabled && kSelectedAppID)

static NSString *kSelectedAppID = @"com.saurik.Cydia";
static BOOL kEnabled = YES;
static NSMutableDictionary *prefs = nil;

%group iOS9

%hook SBDeckSwitcherViewController

- (void)viewDidLoad {
	%orig;

	if(shouldShow) {

		//app item to represent which application we want	
		_DECAppItem* appitem = [%c(_DECAppItem) appWithBundleIdentifier:kSelectedAppID];

		//create our new best app suggestion
		_SBExpertAppSuggestion *expertSuggesiton = [%c(_SBExpertAppSuggestion) new];
		expertSuggesiton = [expertSuggesiton initWithAppSuggestion:appitem result:nil];

		//self.bestAppSuggestion = expertSuggesiton;
		//show the suggestion
		[self setBestAppSuggestion:expertSuggesiton];

	} else {
		[self setBestAppSuggestion:nil];
	}


}

%end

%hook SBLockScreenViewController

- (void)loadView {
	%orig;

	if (shouldShow) {
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
	//make sure app isnt removed by system
	if(arg1 != nil || !kSelectedAppID) {
		%orig;
	}
	
}

%end

%hook SBSwitcherAppSuggestionBottomBannerView

//custom description text in switcher
- (id)_descriptionStringForSuggestion:(id)arg1 {

	return (shouldShow ? @"Empyreal" : %orig); 
}

%end

%end //end iOS9 group


%group iOS8

%hook SBLockScreenViewController

- (void)loadView {
	%orig;

	//determine if we want to show our app
	if (shouldShow) {

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

	/*	
		when there are no apps selected in settings the key is also removed
		so this is used is to make sure the default option stays until the
		user opens settings.
	*/
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
