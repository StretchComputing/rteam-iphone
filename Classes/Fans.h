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
@property (nonatomic, strong) NSMutableArray *fanPics;
@property (nonatomic, strong) UITableView *fanTable;
@property (nonatomic, strong) UILabel *fanActivityLabel;
@property (nonatomic, strong) UIActivityIndicatorView *fanActivity;
@property (nonatomic, strong) UIActivityIndicatorView *barActivity;

@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *currentMemberId;
@property (nonatomic, strong) UIImageView *currentIcon;
@property (nonatomic, strong) NSArray *fans;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *userRole;
@end
