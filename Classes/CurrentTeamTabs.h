//
//  CurrentTeamTabs.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CurrentTeamTabs : UITabBarController <UITabBarControllerDelegate, UIActionSheetDelegate> {
    

}
@property bool fromHome;
@property bool tookPicture;
@property bool newActivity;
@property bool messageSuccess;
@property int messageCount;
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *userRole;
@property bool toTeam;
@property (nonatomic, strong) NSArray *recipients;
-(IBAction)done;
@end
