//
//  NewOtherTeam.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewOtherTeam : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{

	
}
@property bool fromHome;
@property (nonatomic, strong) IBOutlet UIButton *continueButton;
@property (nonatomic, strong) IBOutlet UITextField *sport;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSArray *allSports;
@property (nonatomic, strong) NSMutableArray *allMatches;
@property (nonatomic, strong) IBOutlet UILabel *errorMessage;

-(IBAction)endText;
-(IBAction)nextScreen;
-(IBAction)valueChanged;
-(bool)doesMatchSport;
@end
