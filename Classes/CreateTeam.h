//
//  CoachCreateTeam.h
//  iCoach
//
//  Created by Nick Wroblewski on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CreateTeam : UIViewController <UIActionSheetDelegate> {


    bool fromHome;
}
@property bool fromHome;
-(IBAction)football;
-(IBAction)basketball;
-(IBAction)baseball;
-(IBAction)soccer;
-(IBAction)hockey;
-(IBAction)tennis;
-(IBAction)lacrosse;
-(IBAction)volleyball;
-(IBAction)other;

@end
