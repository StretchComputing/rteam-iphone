//
//  Fans.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fans : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	NSArray *fans;
	NSString *teamName;
	NSString *teamId;
	NSString *userRole;
	
	NSString *currentMemberId;
	UIImageView *currentIcon;
	NSString *error;
	
	IBOutlet UITableView *fanTable;
	IBOutlet UILabel *fanActivityLabel;
	IBOutlet UIActivityIndicatorView *fanActivity;
	UIActivityIndicatorView *barActivity;
	NSMutableArray *fanPics;
}
@property (nonatomic, retain) NSMutableArray *fanPics;
@property (nonatomic, retain) UITableView *fanTable;
@property (nonatomic, retain) UILabel *fanActivityLabel;
@property (nonatomic, retain) UIActivityIndicatorView *fanActivity;
@property (nonatomic, retain) UIActivityIndicatorView *barActivity;

@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSString *currentMemberId;
@property (nonatomic, retain) UIImageView *currentIcon;
@property (nonatomic, retain) NSArray *fans;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *userRole;
@end
