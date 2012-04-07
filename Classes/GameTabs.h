//
//  GameTabs.h
//  iCoach
//
//  Created by Nick Wroblewski on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameTabs : UITabBarController <UITabBarControllerDelegate, UIActionSheetDelegate> {

}
@property bool fromActivity;
@property bool fromHome;
@property bool newActivity;
@property (nonatomic, strong) NSString *teamName;
@property bool messageSuccess;
@property int messageCount;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *timeZone;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *opponent;

@end
