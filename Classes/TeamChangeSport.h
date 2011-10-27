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
@property (nonatomic, strong) UITextField *sport;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *allSports;
@property (nonatomic, strong) NSMutableArray *allMatches;
@property (nonatomic, strong) UILabel *errorMessage;

-(IBAction)endText;
-(IBAction)selectSport;
-(IBAction)valueChanged;
@end
