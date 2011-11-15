//
//  EventList.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"

@interface EventList : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UIActionSheetDelegate> {

    
}
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *editEventActiviy;
@property int actionRow;
@property (nonatomic, strong) UIActionSheet *undoCancel;
@property (nonatomic, strong) IBOutlet UITableView *eventsTableView;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *barActivity;

@property (nonatomic, strong) IBOutlet UILabel *eventActivityLabel;

@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) IBOutlet UILabel *error;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property int deleteRow;
@property bool isPastGame;
@property bool fromEdit;
@property (nonatomic, strong) NSString *userRole;

-(void)getAllEvents;
-(void)deleteActionSheet;

-(void)scrollToCurrent;
@end
