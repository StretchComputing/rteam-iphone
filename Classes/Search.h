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

	
}
@property (nonatomic, strong) ADBannerView *myAd;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *searchActivity;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property BOOL bannerIsVisible;
@property (nonatomic, strong) NSMutableArray *allMatchesTeamName;
@property (nonatomic, strong) NSMutableArray *potentialMatchesTeamName;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSMutableArray *allMatches;
@property (nonatomic, strong) IBOutlet UISegmentedControl *searchCriteria;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *potentialMatches;
@property (nonatomic, strong) NSMutableArray *teamsOnly;

-(void)getListOfTeams;
@end
