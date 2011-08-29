//
//  DeleteMessageFrequency.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeleteMessageFrequency : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITableView *myTableView;
	IBOutlet UIActivityIndicatorView *activity;
	
	NSMutableArray *selectedArray;
	
	IBOutlet UILabel *displayLabel;
	NSString *errorString;
	
	NSString *newValue;
	
}
@property (nonatomic,retain) NSString *newValue;
@property (nonatomic, retain) UILabel *displayLabel;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic,retain) NSMutableArray *selectedArray;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UITableView *myTableView;

@end
