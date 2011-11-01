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

    
	
}
@property (nonatomic, strong) ADBannerView *myAd;
@property (nonatomic, strong) IBOutlet UIView *insideView;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *refreshActivity;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivity;
@property BOOL bannerIsVisible;
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSArray *teamList;
@property bool haveTeamList;
@property (nonatomic, strong) IBOutlet UIScrollView  *scroll;
@property (nonatomic, strong) IBOutlet UITableView *teamTable;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) IBOutlet UIToolbar *bottomBar;
@property (nonatomic, strong) UIBarButtonItem *filterButton;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;
@property (nonatomic, strong) NSArray *games;

-(void)getGames;
-(IBAction)closeFilter;
@end
