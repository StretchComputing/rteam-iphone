//
//  PracticeTabs.h
//  iCoach
//
//  Created by Nick Wroblewski on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PracticeTabs : UITabBarController <UITabBarControllerDelegate, UIActionSheetDelegate> {
	NSString *startDate;
	NSString *endDate;
	NSString *practiceId;
	NSString *teamId;
	NSString *timeZone;
	NSString *description;
	NSString *latitude;
	NSString *longitude;
	NSString *location;
	NSString *userRole;
	
	bool messageSuccess;
	int messageCount;
	bool fromHome;
	
}
@property bool fromHome;
@property bool messageSuccess;
@property int messageCount;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *timeZone;
@property (nonatomic, strong) NSString *practiceId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *location;
@end
