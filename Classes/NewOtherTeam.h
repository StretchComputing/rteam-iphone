//
//  NewOtherTeam.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewOtherTeam : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{

	IBOutlet UITextField *sport;
	IBOutlet UITableView *myTableView;
	NSArray *allSports;
	NSMutableArray *allMatches;
	IBOutlet UILabel *errorMessage;
	
	IBOutlet UIButton *continueButton;
    bool fromHome;
	
}
@property bool fromHome;
@property (nonatomic, retain) UIButton *continueButton;
@property (nonatomic, retain) UITextField *sport;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSArray *allSports;
@property (nonatomic, retain) NSMutableArray *allMatches;
@property (nonatomic, retain) UILabel *errorMessage;

-(IBAction)endText;
-(IBAction)nextScreen;
-(IBAction)valueChanged;
-(bool)doesMatchSport;
@end
