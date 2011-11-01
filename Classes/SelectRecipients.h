//
//  SelectRecipients.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectRecipients : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

}
@property (nonatomic, strong) NSMutableArray *allMemberObjects;
@property bool fans;
@property bool team;
@property bool isPoll;
@property bool isPrivate;
@property bool haveMembers;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) IBOutlet UITableView *memberTableView;
@property bool haveFans;
@property (nonatomic, strong) NSMutableArray *allFansObjects;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *messageOrPoll;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *fromWhere;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSMutableArray *selectedMembers;
@property (nonatomic, strong) NSMutableArray *selectedMemberObjects;

-(IBAction)save;

-(void)getAllMembers;
-(void)save;
@end
