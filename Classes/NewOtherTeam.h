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
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UITextField *sport;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *allSports;
@property (nonatomic, strong) NSMutableArray *allMatches;
@property (nonatomic, strong) UILabel *errorMessage;

-(IBAction)endText;
-(IBAction)nextScreen;
-(IBAction)valueChanged;
-(bool)doesMatchSport;
@end
