//
//  iCoachAppDelegate.h
//  iCoach
//
//  Created by Nick Wroblewski on 10/27/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
@interface rTeamAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;
	NSString *dataFilePath;
	NSString *token;
	
	NSString *quickLinkOne;
	NSString *quickLinkTwo;
	NSString *quickLinkOneName;
	NSString *quickLinkTwoName;
	NSString *quickLinkOneImage;
	NSString *quickLinkTwoImage;
    	
	NSString *displayName;
	
	BOOL registered;
	
	NSData *pushToken;
	
	BOOL startNew;
	
	Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
	
	BOOL displayedConnectionError;
	bool initChange;
	
	BOOL returnHome;
	
	NSArray *phoneOnlyArray;
    NSString *justAddName;
    
    NSString *crashSummary;
    NSString *crashUserName;
    NSDate *crashDetectDate;
    NSData *crashStackData;
    NSString *crashInstanceUrl;
    
	
}

@property (nonatomic, strong) NSString *lastPostTeamId;
@property (nonatomic, strong) NSMutableDictionary *replyDictionary;
@property (nonatomic, strong) NSMutableDictionary *messageImageDictionary;

@property (nonatomic, strong) NSString *lastTwenty;
@property (nonatomic, strong) NSString *lastTwentyTime;

@property (nonatomic, strong) NSString *showSwipeAlert;
@property (nonatomic, strong) NSString *justAddName;
@property (nonatomic, strong) NSArray *phoneOnlyArray;
@property (nonatomic, strong) NSString *displayName;
@property BOOL returnHome;
@property BOOL displayedConnectionError;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navController;
@property (nonatomic, strong) NSString *dataFilePath;
@property (nonatomic, strong) NSString *token;
@property BOOL registered;
@property (nonatomic, strong) NSData *pushToken;
@property BOOL startNew;

@property (nonatomic, strong) NSString *quickLinkOne;
@property (nonatomic, strong) NSString *quickLinkTwo;

@property (nonatomic, strong) NSString *quickLinkOneName;
@property (nonatomic, strong) NSString *quickLinkTwoName;

@property (nonatomic, strong) NSString *quickLinkOneImage;
@property (nonatomic, strong) NSString *quickLinkTwoImage;

@property (nonatomic, strong) NSString *crashSummary;
@property (nonatomic, strong) NSString *crashUserName;
@property (nonatomic, strong) NSDate *crashDetectDate;
@property (nonatomic, strong) NSData *crashStackData;
@property (nonatomic, strong) NSString *crashInstanceUrl;

- (void) updateInterfaceWithReachability: (Reachability*) curReach;
-(void)saveUserInfo;
-(void)handleCrashReport;
@end

