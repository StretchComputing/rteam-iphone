//
//  Vote.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Vote : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	NSString *teamId;
	NSString *userRole;
	
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	IBOutlet UITableView *myTableView;
	IBOutlet UIButton *closeVotingButton;
	IBOutlet UILabel *errorLabel;
	IBOutlet UIActivityIndicatorView *activity;
	
	NSMutableArray *memberArray;
	NSString *errorString;
	NSString *myVote;
	NSString *gameId;
	
	IBOutlet UIActivityIndicatorView *votingActivity;
	
	bool isOpen;
	
	bool gameInfoSuccess;
	bool updateSuccess;
	
	NSString *updateStatus;
	
}
@property (nonatomic, retain) NSString *updateStatus;
@property bool gameInfoSuccess;
@property bool updateSuccess;
@property bool isOpen;
@property (nonatomic, retain) UIActivityIndicatorView *votingActivity;

@property (nonatomic, retain) NSString *gameId;
@property (nonatomic, retain) NSString *myVote;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSMutableArray *memberArray;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UIButton *closeVotingButton;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activity;

@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *userRole;

-(IBAction)closeVoting;
@end
