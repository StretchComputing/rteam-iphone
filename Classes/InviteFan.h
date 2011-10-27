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
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) UILabel *error;
@property bool noRightButton;
@property (nonatomic, strong) NSMutableArray *teamArray;
@property (nonatomic, strong) NSMutableArray *teamArrayTemp;

@property (nonatomic, strong) UITableView *listOfTeams;


@end
