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
@property (nonatomic, strong) NSString *updateStatus;
@property bool gameInfoSuccess;
@property bool updateSuccess;
@property bool isOpen;
@property (nonatomic, strong) UIActivityIndicatorView *votingActivity;

@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *myVote;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIButton *closeVotingButton;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *userRole;

-(IBAction)closeVoting;
@end
