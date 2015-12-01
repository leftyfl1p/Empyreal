#import <Preferences/Preferences.h>
#import <Twitter/TWTweetComposeViewController.h>

#define prefPath @"/User/Library/Preferences/com.leftyfl1p.empyreal.plist"

@interface empyrealListController: PSListController {
	UIWindow *settingsView;
}
@end

@implementation empyrealListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"empyreal" target:self] retain];
	}
	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
[super viewWillAppear:animated];
settingsView = [[UIApplication sharedApplication] keyWindow];
}

- (void)viewWillDisappear:(BOOL)animated {
[super viewWillDisappear:animated];
settingsView.tintColor = nil;

}

-(id)readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:prefPath];
    if (!prefs[specifier.properties[@"key"]]) {
        return specifier.properties[@"default"];
    }
    return prefs[specifier.properties[@"key"]];
}
 
-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:prefPath]];
    [defaults setObject:value forKey:specifier.properties[@"key"]];
    [defaults writeToFile:prefPath atomically:YES];
    CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
    if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

- (void)loadView {
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(tweet:)];
    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor colorWithRed:0 green:0.478 blue:1 alpha:1]; /*#007aff*/
}

- (void)openTwitter {
    NSString *user = @"leftyfl1p";
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
    
    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];
    
    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];
    
    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
    
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}

- (void)tweet:(id)sender {
    TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];
    [tweetController setInitialText:@"I'm using the tweak #Empyreal by @leftyfl1p!"];
    [self.navigationController presentViewController:tweetController animated:YES completion:nil];
    [tweetController release];
}

@end


// vim:ft=objc
