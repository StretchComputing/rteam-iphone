//
//  TeamChangeSport.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TeamChangeSport : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	
	IBOutlet UITextField *sport;
	IBOutlet UITableView *myTableView;
	NSArray *allSports;
	NSMutableArray *allMatches;
	IBOutlet UILabel *errorMessage;
	
	
}
@property (nonatomic, retain) UITextField *sport;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSArray *allSports;
@property (nonatomic, retain) NSMutableArray *allMatches;
@property (nonatomic, retain) UILabel *errorMessage;

-(IBAction)endText;
-(IBAction)selectSport;
-(IBAction)valueChanged;
@end
