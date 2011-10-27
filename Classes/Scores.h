//
//  Scores.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>



@interface Scores : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIActionSheetDelegate,
ADBannerViewDelegate> {
    
	NSString *teamId;
	
	IBOutlet UIScrollView *scroll;
	IBOutlet UITableView *teamTable;
	IBOutlet UITableView *table;
	IBOutlet UIToolbar *bottomBar;
	UIBarButtonItem *filterButton;
	UIBarButtonItem *refreshButton;
	
	NSArray *games;
	NSString *error;
	NSArray *teamList;
	bool haveTeamList;
	
	NSString *sport;
	NSString *teamName;
	
	BOOL bannerIsVisible;
	ADBannerView *myAd;
	
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	IBOutlet UIActivityIndicatorView *refreshActivity;
	
	IBOutlet UIButton *cancelButton;
	
	IBOutlet UIView *insideView;
    
	
}
@property (nonatomic, strong) UIView *insideView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIActivityIndicatorView *refreshActivity;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;
@property BOOL bannerIsVisible;
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSArray *teamList;
@property bool haveTeamList;
@property (nonatomic, strong) UIScrollView  *scroll;
@property (nonatomic, strong) UITableView *teamTable;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) UIToolbar *bottomBar;
@property (nonatomic, strong) UIBarButtonItem *filterButton;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;
@property (nonatomic, strong) NSArray *games;

-(void)getGames;
-(IBAction)closeFilter;
@end
