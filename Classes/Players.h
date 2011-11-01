//
//  Players.h
//  iCoach
//
//  Created by Nick Wroblewski on 12/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface Players : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate> {

    
}
@property (nonatomic, strong) NSMutableArray *phoneOnlyArray;
@property (nonatomic,strong) NSMutableArray *tmpPlayerPics;
@property (nonatomic,strong) NSMutableArray *tmpFanPics;

@property (nonatomic,strong) NSMutableArray *tmpPlayers;
@property (nonatomic,strong) NSMutableArray *tmpFans;


@property (nonatomic, strong) IBOutlet UITableView *memberTableView;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *barActivity;

@property (nonatomic, strong) IBOutlet UILabel *memberActivityLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *memberActivity;



@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) UISegmentedControl *segRosterFans;
@property bool isFans;
@property (nonatomic, strong) NSString *currentMemberId;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSMutableArray *fans;
@property (nonatomic, strong) NSMutableArray *playerPics;
@property (nonatomic, strong) NSMutableArray *fanPics;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *userRole;

-(void)getListOfMembers;
@end
