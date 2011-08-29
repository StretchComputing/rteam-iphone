//
//  CurrentTeamTabs.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CurrentTeamTabs : UITabBarController <UITabBarControllerDelegate, UIActionSheetDelegate> {

	NSString *teamId;
	NSString *teamName;
	NSString *userRole;
	
	bool toTeam;
	bool messageSuccess;
	int messageCount;
	NSArray *recipients;
	
	NSString *sport;
	bool newActivity;
	bool tookPicture;
}
@property bool tookPicture;
@property bool newActivity;
@property bool messageSuccess;
@property int messageCount;
@property (nonatomic, retain) NSString *sport;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *userRole;
@property bool toTeam;
@property (nonatomic, retain) NSArray *recipients;
-(IBAction)done;
@end
