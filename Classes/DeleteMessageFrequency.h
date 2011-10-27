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
@property (nonatomic,strong, getter = theNewValue) NSString *newValue;
@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic,strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UITableView *myTableView;

@end
