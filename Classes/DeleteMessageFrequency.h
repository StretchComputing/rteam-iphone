//
//  DeleteMessageFrequency.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeleteMessageFrequency : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	
}
@property (nonatomic,strong, getter = theNewValue) NSString *newValue;
@property (nonatomic, strong) IBOutlet UILabel *displayLabel;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic,strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;

@end
