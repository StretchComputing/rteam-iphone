//
//  SelectRecipientsTeam.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SelectRecipientsTeam : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

	NSArray *teamArray;
	IBOutlet UITableView *teamList;

	NSString *fromWhere;      //MessagesTabs, CurrentTeamTabs, GameTabs, or PracticeTabs
	NSString *messageOrPoll;  //message or poll
}
@property (nonatomic, retain) NSString *messageOrPoll;
@property (nonatomic, retain) NSString *fromWhere;
@property (nonatomic, retain) UITableView *teamList;
@property (nonatomic, retain) NSArray *teamArray;
@end
