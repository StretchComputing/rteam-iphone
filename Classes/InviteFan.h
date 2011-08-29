//
//  InviteFan.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InviteFan : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

	IBOutlet UITableView *listOfTeams;
	NSMutableArray *teamArray;
	NSMutableArray *teamArrayTemp;
	bool noRightButton;
	
	IBOutlet UILabel *error;
	
	NSString *errorString;
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
}
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, retain) UILabel *error;
@property bool noRightButton;
@property (nonatomic, retain) NSMutableArray *teamArray;
@property (nonatomic, retain) NSMutableArray *teamArrayTemp;

@property (nonatomic, retain) UITableView *listOfTeams;


@end
