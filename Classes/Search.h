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
@property (nonatomic, strong) UIActivityIndicatorView *searchActivity;
@property (nonatomic, strong) UILabel *errorLabel;
@property BOOL bannerIsVisible;
@property (nonatomic, strong) NSMutableArray *allMatchesTeamName;
@property (nonatomic, strong) NSMutableArray *potentialMatchesTeamName;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSMutableArray *allMatches;
@property (nonatomic, strong) UISegmentedControl *searchCriteria;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *potentialMatches;
@property (nonatomic, strong) NSMutableArray *teamsOnly;

-(void)getListOfTeams;
@end
