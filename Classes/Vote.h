//
//  Vote.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Vote : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	
}
@property (nonatomic, strong) NSString *updateStatus;
@property bool gameInfoSuccess;
@property bool updateSuccess;
@property bool isOpen;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *votingActivity;

@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *myVote;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) IBOutlet UIButton *closeVotingButton;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *userRole;

-(IBAction)closeVoting;
@end
