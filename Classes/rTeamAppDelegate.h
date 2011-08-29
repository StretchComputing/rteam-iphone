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
	
	
}
@property (nonatomic, retain) NSString *justAddName;
@property (nonatomic, retain) NSArray *phoneOnlyArray;
@property (nonatomic, retain) NSString *displayName;
@property BOOL returnHome;
@property BOOL displayedConnectionError;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) NSString *dataFilePath;
@property (nonatomic, retain) NSString *token;
@property BOOL registered;
@property (nonatomic, retain) NSData *pushToken;
@property BOOL startNew;

@property (nonatomic, retain) NSString *quickLinkOne;
@property (nonatomic, retain) NSString *quickLinkTwo;

@property (nonatomic, retain) NSString *quickLinkOneName;
@property (nonatomic, retain) NSString *quickLinkTwoName;

@property (nonatomic, retain) NSString *quickLinkOneImage;
@property (nonatomic, retain) NSString *quickLinkTwoImage;

- (void) updateInterfaceWithReachability: (Reachability*) curReach;
-(void)saveUserInfo;
@end

