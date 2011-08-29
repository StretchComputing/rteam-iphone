//
//  Search.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface Search : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ADBannerViewDelegate, UIActionSheetDelegate> {

	IBOutlet UISegmentedControl *searchCriteria;
	IBOutlet UISearchBar *searchBar;
	
	IBOutlet UILabel *errorLabel;
	
	IBOutlet UITableView *searchTableView;
	
	NSMutableArray *potentialMatches;
	NSMutableArray *potentialMatchesTeamName;
	NSMutableArray *allMatchesTeamName;
	NSMutableArray *allMatches;
	NSMutableArray *teamsOnly;
	
	NSString *error;
	
	ADBannerView *myAd;
	BOOL bannerIsVisible;
	
	IBOutlet UIActivityIndicatorView *searchActivity;
	
}
@property (nonatomic, retain) UIActivityIndicatorView *searchActivity;
@property (nonatomic, retain) UILabel *errorLabel;
@property BOOL bannerIsVisible;
@property (nonatomic, retain) NSMutableArray *allMatchesTeamName;
@property (nonatomic, retain) NSMutableArray *potentialMatchesTeamName;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSMutableArray *allMatches;
@property (nonatomic, retain) UISegmentedControl *searchCriteria;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UITableView *searchTableView;
@property (nonatomic, retain) NSMutableArray *potentialMatches;
@property (nonatomic, retain) NSMutableArray *teamsOnly;

-(void)getListOfTeams;
@end
