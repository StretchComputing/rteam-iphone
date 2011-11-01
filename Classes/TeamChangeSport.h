//
//  TeamChangeSport.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TeamChangeSport : UIViewController <UITableViewDelegate, UITableViewDataSource>{

	
	
}
@property (nonatomic, strong) IBOutlet UITextField *sport;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSArray *allSports;
@property (nonatomic, strong) NSMutableArray *allMatches;
@property (nonatomic, strong) IBOutlet UILabel *errorMessage;

-(IBAction)endText;
-(IBAction)selectSport;
-(IBAction)valueChanged;
@end
