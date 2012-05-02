//
//  NewActivity.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewActivity.h"
#import "MyViewController.h"
#import "FastActionSheet.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "Base64.h"
#import "MessageThreadInbox.h"
#import "MessageThreadOutbox.h"
#import "ViewPollSent.h"
#import "ViewPollReceived.h"
#import "ViewMessageSent.h"
#import "ViewMessageReceived.h"

#import "ActivityPost.h"
#import "TableDisplayUtil.h"
#import "ImageButton.h"
#import "ImageDisplayMultiple.h"
#import "PhotosActivity.h"
#import "NewActivityDetail.h"
#import "VideoDisplay.h"
#import "NewActivityImageObject.h"
#import "GANTracker.h"
#import "TraceSession.h"
#import "GoogleAppEngine.h"
#import "GameTabs.h"
#import "GameTabsNoCoord.h"
#import "Gameday.h"
#import "GameAttendance.h"
#import "Vote.h"
#import "ScoreButton.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation NewActivity
@synthesize topScrollView, bottomScrollView, viewControllers, numberOfPages, currentPage, view1, view2, view3, currentMiddle, bannerIsVisible,
tmpActivityArray, newActivityFailed, hasNewActivity, activityArray, allActivityTable, view1Top, view2Top, view3Top, allActivityLoadingLabel, allActivityLoadingIndicator, refreshArrow, refreshLabel, refreshSpinner, textPull, textLoading, textRelease, refreshHeaderView, refreshArrow2, refreshLabel2, refreshSpinner2, refreshHeaderView2, textPull2, textLoading2, textRelease2, isLoading, currentTable, myActivityTable, myActivityLoadingLabel, myActivityLoadingIndicator, photosTable, photosLoadingLabel, photosLoadingIndicator, isDragging, shouldCallStop, didInitPhotos, didInitMyActivity, myActivityArray, myAd, fromPost, swipeAlert, swipeAlertFront, activityImageObjects, totalReplyArray, errorString, homeScoreView, photosArray, photoActivity, photoDisplayLabel, photoBackView, canLoadMorePhotos, tmpPhotosArray, morePhotosButton, refreshArrow3, refreshLabel3, refreshSpinner3, refreshHeaderView3, textPull3, textLoading3, textRelease3;


-(void)home{
    
    [TraceSession addEventToSession:@"Activity Page - Home Button Clicked"];

	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}

-(void)compose{
    
    [TraceSession addEventToSession:@"Activity Page - Compose Button Clicked"];

    
    ActivityPost *tmp = [[ActivityPost alloc] init];
	tmp.fromClass = self;
	UINavigationController *navController = [[UINavigationController alloc] init];
	
	[navController pushViewController:tmp animated:NO];
	
	[self.navigationController presentModalViewController:navController animated:YES];	

    
}
	
-(void)viewWillAppear:(BOOL)animated{
    
    [TraceSession addEventToSession:@"Activity - View Will Appear"];

    
    self.topScrollView.contentOffset = self.bottomScrollView.contentOffset;
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([mainDelegate.showSwipeAlert isEqualToString:@"true"]) {
        self.swipeAlert.hidden = NO;
        mainDelegate.showSwipeAlert = @"false";
        
        [mainDelegate saveUserInfo];
    }else{
        self.swipeAlert.hidden = YES;
    }
   // if (self.fromPost) {
        //self.fromPost = false;
        [self performSelectorInBackground:@selector(getNewActivity) withObject:nil];
        [self performSelectorInBackground:@selector(getMyActivity) withObject:nil];
    //}

    
    if (myAd.bannerLoaded) {
        bannerIsVisible = YES;
        myAd.hidden = NO;
        
        CGRect frame = self.allActivityTable.frame;
        frame.size.height = 341;
        self.allActivityTable.frame = frame;
        
        CGRect frame1 = self.myActivityTable.frame;
        frame1.size.height = 341;
        self.myActivityTable.frame = frame1;
        
        CGRect frame2 = self.photoBackView.frame;
        frame2.size.height = 341;
        self.photoBackView.frame = frame2;
        
    }else{
        bannerIsVisible = NO;
        myAd.hidden = YES;
        
        CGRect frame = self.allActivityTable.frame;
        frame.size.height = 391;
        self.allActivityTable.frame = frame;
        
        CGRect frame1 = self.myActivityTable.frame;
        frame1.size.height = 391;
        self.myActivityTable.frame = frame1;
        
        CGRect frame2 = self.photoBackView.frame;
        frame2.size.height = 391;
        self.photoBackView.frame = frame2;
        
    }
    
}
    
    
- (void)viewDidLoad
{
    self.canLoadMorePhotos = false;
    self.photoBackView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 391)];
    self.photoBackView.backgroundColor = [UIColor clearColor];
    
    self.photoBackView.delegate = self;
    
                                                                       
    
    self.photosArray = [NSMutableArray array];
    self.tmpPhotosArray = [NSMutableArray array];

    homeScoreView = [[HomeScoreView alloc] init];
    homeScoreView.view.frame = CGRectMake(0, 322, 320, 301);
    homeScoreView.view.hidden = YES;

    [self.view addSubview:self.homeScoreView.view];
    
    self.swipeAlertFront.layer.masksToBounds = YES;
    self.swipeAlertFront.layer.cornerRadius = 4.0;
    self.swipeAlert.layer.masksToBounds = YES;
    self.swipeAlert.layer.cornerRadius = 4.0;
    self.totalReplyArray = [NSMutableArray array];
    
    self.title = @"Activity";

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setLeftBarButtonItem:addButton];
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose)];
	[self.navigationItem setRightBarButtonItem:composeButton];
    
    self.numberOfPages = 3;
    [self setUpScrollView];

    
    int y = self.bottomScrollView.frame.size.height;
    
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, y)];
    self.view1.backgroundColor = [UIColor whiteColor];
    [self.bottomScrollView addSubview:self.view1];
    [self.view1 addSubview:self.photoBackView];
    
    PhotosActivity *tmp = [[PhotosActivity alloc] init];
    [self.view1 addSubview:tmp.view];
    
    self.photoActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.photoActivity.frame = CGRectMake(140, 150, 40, 40);
    
    self.photoDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 20)];
    self.photoDisplayLabel.backgroundColor = [UIColor clearColor];
    self.photoDisplayLabel.textAlignment = UITextAlignmentCenter;
    self.photoDisplayLabel.textColor = [UIColor darkGrayColor];
    
    [self.view1 addSubview:self.photoActivity];
    [self.view1 addSubview:self.photoDisplayLabel];
    
    self.view2 = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, y)];
    self.view2.backgroundColor = [UIColor whiteColor];
    [self.bottomScrollView addSubview:self.view2];
    
    self.view3 = [[UIView alloc] initWithFrame:CGRectMake(640, 0, 320, y)];
    self.view3.backgroundColor = [UIColor whiteColor];
    [self.bottomScrollView addSubview:self.view3];
    
    y = self.topScrollView.frame.size.height;
    
    self.view1Top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, y)];
    [self.topScrollView addSubview:self.view1Top];
    
    self.view2Top = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, y)];
    [self.topScrollView addSubview:self.view2Top];
    
    self.view3Top = [[UIView alloc] initWithFrame:CGRectMake(640, 0, 320, y)];
    [self.topScrollView addSubview:self.view3Top];
    
    
    //Labels for top
    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, y)];
    centerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    centerLabel.textAlignment = UITextAlignmentCenter;
    centerLabel.backgroundColor = [UIColor clearColor];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, y)];
    leftLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    leftLabel.textAlignment = UITextAlignmentLeft;
    leftLabel.backgroundColor = [UIColor clearColor];
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 90, y)];
    rightLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    rightLabel.textAlignment = UITextAlignmentRight;
    rightLabel.backgroundColor = [UIColor clearColor];
    centerLabel.text = @"Everyone";
    leftLabel.text = @"Photos";
    rightLabel.text = @"Me";
    [self.view2Top addSubview:centerLabel];
    [self.view2Top addSubview:rightLabel];
    [self.view2Top addSubview:leftLabel];

    UILabel *centerLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, y)];
    centerLabel1.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    centerLabel1.textAlignment = UITextAlignmentCenter;
    centerLabel1.backgroundColor = [UIColor clearColor];
    UILabel *leftLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, y)];
    leftLabel1.font = [UIFont fontWithName:@"Helvetica" size:14];
    leftLabel1.textAlignment = UITextAlignmentLeft;
    leftLabel1.backgroundColor = [UIColor clearColor];
    UILabel *rightLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 90, y)];
    rightLabel1.font = [UIFont fontWithName:@"Helvetica" size:14];
    rightLabel1.textAlignment = UITextAlignmentRight;
    rightLabel1.backgroundColor = [UIColor clearColor];
    centerLabel1.text = @"Me";
    leftLabel1.text = @"Everyone";
    rightLabel1.text = @"Photos";
    [self.view3Top addSubview:centerLabel1];
    [self.view3Top addSubview:rightLabel1];
    [self.view3Top addSubview:leftLabel1];
    
    UILabel *centerLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, y)];
    centerLabel2.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    centerLabel2.textAlignment = UITextAlignmentCenter;
    centerLabel2.backgroundColor = [UIColor clearColor];
    UILabel *leftLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, y)];
    leftLabel2.font = [UIFont fontWithName:@"Helvetica" size:14];
    leftLabel2.textAlignment = UITextAlignmentLeft;
    leftLabel2.backgroundColor = [UIColor clearColor];
    UILabel *rightLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 90, y)];
    rightLabel2.font = [UIFont fontWithName:@"Helvetica" size:14];
    rightLabel2.textAlignment = UITextAlignmentRight;
    rightLabel2.backgroundColor = [UIColor clearColor];
    centerLabel2.text = @"Photos";
    leftLabel2.text = @"Me";
    rightLabel2.text = @"Everyone";
    [self.view1Top addSubview:centerLabel2];
    [self.view1Top addSubview:rightLabel2];
    [self.view1Top addSubview:leftLabel2];
    
    
    //All Activiiy - Table + loading label and activity indicator + server call
    self.tmpActivityArray = [NSMutableArray array];
    self.activityArray = [NSMutableArray array];
    
    //[self performSelectorInBackground:@selector(getNewActivity) withObject:nil];
    
    self.allActivityTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view2.frame.size.width, self.view2.frame.size.height) style:UITableViewStylePlain];
    self.allActivityTable.dataSource = self;
    self.allActivityTable.delegate = self;

    
    self.allActivityLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.allActivityLoadingIndicator.frame = CGRectMake(150, 120, 20, 20);
    [self.allActivityLoadingIndicator startAnimating];
    [self.view2 addSubview:self.allActivityLoadingIndicator];
    
    self.allActivityLoadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 320, 20)];
    self.allActivityLoadingLabel.text = @"Loading All Activity...";
    self.allActivityLoadingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    self.allActivityLoadingLabel.textColor = [UIColor grayColor];
    self.allActivityLoadingLabel.textAlignment = UITextAlignmentCenter;
    [self.view2 addSubview:self.allActivityLoadingLabel];
    
    self.allActivityTable.hidden = YES;
    [self.view2 addSubview:self.allActivityTable];
    
    //My Activity - Table + 
    self.didInitMyActivity = false;
    self.myActivityTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view2.frame.size.width, self.view2.frame.size.height) style:UITableViewStylePlain];
    self.myActivityTable.dataSource = self;
    self.myActivityTable.delegate = self;
    
    self.myActivityLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.myActivityLoadingIndicator.frame = CGRectMake(150, 120, 20, 20);
    [self.myActivityLoadingIndicator startAnimating];
    [self.view3 addSubview:self.myActivityLoadingIndicator];
    
    self.myActivityLoadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 320, 20)];
    self.myActivityLoadingLabel.text = @"Loading My Activity...";
    self.myActivityLoadingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    self.myActivityLoadingLabel.textColor = [UIColor grayColor];
    self.myActivityLoadingLabel.textAlignment = UITextAlignmentCenter;
    [self.view3 addSubview:self.myActivityLoadingLabel];
    
    self.myActivityTable.hidden = YES;
    [self.view3 addSubview:self.myActivityTable];
    
    //Photos stuff
    self.didInitPhotos = false;
        
    //Pull to refresh
    self.currentTable = @"everyone";
    [self setupStrings];
    [self addPullToRefreshHeader];
    
    self.topScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topScrollBack2.png"]];
    
    
    //iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 366, 320, 50)];
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
    
    
    [super viewDidLoad];
}


-(void)setUpScrollView{
	
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < self.numberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
	
    // a page is the width of the scroll view
	//scrollView.frame = CGRectMake(100, 300, 200, 100);
    bottomScrollView.pagingEnabled = YES;
    bottomScrollView.contentSize = CGSizeMake(bottomScrollView.frame.size.width * self.numberOfPages, bottomScrollView.frame.size.height);
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    bottomScrollView.showsVerticalScrollIndicator = NO;
    bottomScrollView.scrollsToTop = NO;
    bottomScrollView.delegate = self;
	bottomScrollView.backgroundColor = [UIColor whiteColor];

  
    for (int i = 0; i < 3; i++) {
        MyViewController *controller = [[MyViewController alloc] initWithPageNumber:i];
        [viewControllers replaceObjectAtIndex:i withObject:controller];
    }
        
    self.currentPage = 1;
    self.currentMiddle = 2;
    //[self loadScrollViewWithPage:1];

    CGPoint tmpPoint = CGPointMake(320, 0);
    [self.bottomScrollView setContentOffset:tmpPoint animated:NO];
	


}


- (void)loadScrollViewWithPage:(int)page {
   

    [self.view1 removeFromSuperview];
    [self.view2 removeFromSuperview];
    [self.view3 removeFromSuperview];
   
    int y = self.bottomScrollView.frame.size.height;

    if (self.currentMiddle == 1) {
        
        [TraceSession addEventToSession:@"Activity Page - Swiped To Photos"];

        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Activitiy Swipe - To Photos"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
        //Photos  
      if ([self.photosArray count] == 0) {
        [self.photoActivity startAnimating];
        
        NSDate *today = [NSDate date];
        NSDate *tomorrow = [NSDate dateWithTimeInterval:86400 sinceDate:today];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"YYYY-MM-dd"];

        NSString *dateString = [format stringFromDate:tomorrow];
        
        [self performSelectorInBackground:@selector(getActivityPhotos:) withObject:dateString];
       }
      
        self.view1.frame = CGRectMake(320, 0, 320, y);
        [self.bottomScrollView addSubview:self.view1];
        self.view1.backgroundColor = [UIColor whiteColor];
        
        self.view2.frame = CGRectMake(640, 0, 320, y);
        self.view2.backgroundColor = [UIColor whiteColor];
        [self.bottomScrollView addSubview:self.view2];
        
        self.view3.frame = CGRectMake(0, 0, 320, y);
        self.view3.backgroundColor = [UIColor whiteColor];
        [self.bottomScrollView addSubview:self.view3];
        
    }else if (self.currentMiddle == 2){
        //Everyone
        
        [TraceSession addEventToSession:@"Activity Page - Swiped To Everyone"];

        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Activitiy Swipe - To Everyone"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
        self.view1.frame = CGRectMake(0, 0, 320, y);
        self.view1.backgroundColor = [UIColor whiteColor];
        [self.bottomScrollView addSubview:self.view1];
        
        self.view2.frame = CGRectMake(320, 0, 320, y);
        self.view2.backgroundColor = [UIColor whiteColor];
        [self.bottomScrollView addSubview:self.view2];
        
        self.view3.frame = CGRectMake(640, 0, 320, y);
        self.view3.backgroundColor = [UIColor whiteColor];
        [self.bottomScrollView addSubview:self.view3];
        
    }else{
        //Me
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Activitiy Swipe - To Me"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
        [TraceSession addEventToSession:@"Activity Page - Swiped To Me"];

        
        if (!self.didInitMyActivity) {
            self.didInitMyActivity = false;
            [self performSelectorInBackground:@selector(getMyActivity) withObject:nil];
        }
        
        self.view1.frame = CGRectMake(640, 0, 320, y);
        self.view1.backgroundColor = [UIColor whiteColor];
        [self.bottomScrollView addSubview:self.view1];
        
        self.view2.frame = CGRectMake(0, 0, 320, y);
        self.view2.backgroundColor = [UIColor whiteColor];
        [self.bottomScrollView addSubview:self.view2];
        
        self.view3.frame = CGRectMake(320, 0, 320, y);
        self.view3.backgroundColor = [UIColor whiteColor];
        [self.bottomScrollView addSubview:self.view3];
        
        if ([self.myActivityArray count] > 0) {
            [self performSelectorInBackground:@selector(updateWasViewed) withObject:nil];
        }
         
    }
       
    CGRect frame1 = self.view1.frame;
    CGRect newFrame = self.view1Top.frame;
    newFrame.origin.x = frame1.origin.x;
    self.view1Top.frame = newFrame;
    
    CGRect frame2 = self.view2.frame;
    CGRect newFrame2 = self.view2Top.frame;
    newFrame2.origin.x = frame2.origin.x;
    self.view2Top.frame = newFrame2;
    
    CGRect frame3 = self.view3.frame;
    CGRect newFrame3 = self.view3Top.frame;
    newFrame3.origin.x = frame3.origin.x;
    self.view3Top.frame = newFrame3;
		
    CGPoint tmpPoint = CGPointMake(320, 0);
    [self.bottomScrollView setContentOffset:tmpPoint animated:NO];
		
            
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {

    
    if (sender == self.bottomScrollView) {
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = bottomScrollView.frame.size.width;
        int page = floor((bottomScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.currentPage = page;

        
        UIScrollView *tmp = (UIScrollView *)sender;
        
        CGPoint tmpPoint = CGPointMake(tmp.contentOffset.x, 0);
        [self.topScrollView setContentOffset:tmpPoint];
        
        if (tmp.contentOffset.x == 0) {
            
            if (self.currentMiddle == 1) {
                self.currentMiddle = 3;
            }else if (self.currentMiddle == 2){
                self.currentMiddle = 1;
                
            }else{
                self.currentMiddle = 2;
            }
            self.currentPage = 0;
            [self loadScrollViewWithPage:0];
        }
        
        if (tmp.contentOffset.x == 640) {
            
            if (self.currentMiddle == 1) {
                self.currentMiddle = 2;
            }else if (self.currentMiddle == 2){
                self.currentMiddle = 3;
                
            }else{
                self.currentMiddle = 1;
            }
            
            
            self.currentPage = 2;
            [self loadScrollViewWithPage:2];
        }

    }else{
        
        if (sender == self.allActivityTable) {
            self.currentTable = @"everyone";
            if (isLoading) {
                // Update the content inset, good for section headers
                if (sender.contentOffset.y > 0)
                    self.allActivityTable.contentInset = UIEdgeInsetsZero;
                else if (sender.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
                    self.allActivityTable.contentInset = UIEdgeInsetsMake(-sender.contentOffset.y, 0, 0, 0);
            } else if (isDragging && sender.contentOffset.y < 0) {
                // Update the arrow direction and label
                [UIView beginAnimations:nil context:NULL];
                if (sender.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                    // User is scrolling above the header
                    refreshLabel.text = self.textRelease;
                    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                } else { // User is scrolling somewhere within the header
                    refreshLabel.text = self.textPull;
                    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
                }
                [UIView commitAnimations];
            }
            
            
        }else if (sender == self.myActivityTable){
            self.currentTable = @"me";
            
            if (isLoading) {
                // Update the content inset, good for section headers
                if (sender.contentOffset.y > 0)
                    self.myActivityTable.contentInset = UIEdgeInsetsZero;
                else if (sender.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
                    self.myActivityTable.contentInset = UIEdgeInsetsMake(-sender.contentOffset.y, 0, 0, 0);
            } else if (isDragging && sender.contentOffset.y < 0) {
                // Update the arrow direction and label
                [UIView beginAnimations:nil context:NULL];
                if (sender.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                    // User is scrolling above the header
                    refreshLabel2.text = self.textRelease2;
                    [refreshArrow2 layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                } else { // User is scrolling somewhere within the header
                    refreshLabel2.text = self.textPull2;
                    [refreshArrow2 layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
                }
                [UIView commitAnimations];
            }
            
            
        }else{
            
            self.currentTable = @"photos";
            
            if (isLoading) {
                // Update the content inset, good for section headers
                if (sender.contentOffset.y > 0)
                    self.photoBackView.contentInset = UIEdgeInsetsZero;
                else if (sender.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
                    self.photoBackView.contentInset = UIEdgeInsetsMake(-sender.contentOffset.y, 0, 0, 0);
            } else if (isDragging && sender.contentOffset.y < 0) {
                // Update the arrow direction and label
                [UIView beginAnimations:nil context:NULL];
                if (sender.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                    // User is scrolling above the header
                    refreshLabel3.text = self.textRelease3;
                    [refreshArrow3 layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                } else { // User is scrolling somewhere within the header
                    refreshLabel3.text = self.textPull3;
                    [refreshArrow3 layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
                }
                [UIView commitAnimations];
            }
        }
    }        
}




- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	if (tableView == self.allActivityTable) {
        
        if ([self.activityArray count] == 0) {
            return 1;
        }
            
        return [self.activityArray count];

        
	
	}else if (true) {
		
        if ([self.myActivityArray count] == 0) {
            return 1;
        }
        return [self.myActivityArray count];
        
	}else {
        //Post Team
		return 1;
	}
    
    	
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	if (tableView == self.allActivityTable) {
		
        return [TableDisplayUtil setUpTableViewCellWithArray:self.activityArray fromClass:self forIndexPath:indexPath andTableView:tableView];

               
	}else if (true) { //my activity table
        
        return [TableDisplayUtil setUpTableViewCellWithArrayMy:self.myActivityArray fromClass:self forIndexPath:indexPath andTableView:tableView];

				
	}
    
}


//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (tableView == self.allActivityTable) {
		
        return [TableDisplayUtil getHeightForRowAtIndexPath:indexPath arrayUsed:self.activityArray];

      
	}else if (tableView == self.myActivityTable){
        return [TableDisplayUtil getHeightForRowAtIndexPathMy:indexPath arrayUsed:self.myActivityArray];
	}else{
        return 40;
    }
    
}

-(void)deselect:(NSIndexPath *)indexPath{
    [self.allActivityTable deselectRowAtIndexPath:indexPath animated:NO];
    [self.myActivityTable deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSelector:@selector(deselect:) withObject:indexPath afterDelay:1.0];
    
	@try {
        NSUInteger row = [indexPath row];
        
        if (tableView == self.allActivityTable) {
            
            [TraceSession addEventToSession:@"Activity Page - Activity Row Clicked"];
            
            if ([[self.activityArray objectAtIndex:row] class] == [Activity class]) {
                
                Activity *tmpActivity = [self.activityArray objectAtIndex:row];
                
                
                
                NewActivityDetail *theMessage = [[NewActivityDetail alloc] init];
                
                
                theMessage.displayName = @"rTeam";
                
                if (tmpActivity.senderName != nil) {
                    theMessage.displayName = tmpActivity.senderName;
                }
                theMessage.displayTime = [TableDisplayUtil getDateLabel:tmpActivity.createdDate]; 
                theMessage.displayMessage = tmpActivity.activityText;
                theMessage.messageId = tmpActivity.activityId;
                theMessage.teamId = tmpActivity.teamId;
                theMessage.teamName = tmpActivity.teamName;
                theMessage.numLikes = tmpActivity.numLikes;
                theMessage.numDislikes = tmpActivity.numDislikes;
                
                theMessage.currentVote = tmpActivity.vote;
                theMessage.isVideo = tmpActivity.isVideo;
                theMessage.isCurrentUser = tmpActivity.isCurrentUser;
                //theMessage.likes = [NSArray arrayWithArray:messageSelected.likedBy];
                //theMessage.replies = [NSArray arrayWithArray:messageSelected.replies];
                //theMessage.tags = [NSArray arrayWithArray:messageSelected.tags];
                //theMessage.profile = messageSelected.profile;
                
                if ([tmpActivity.thumbnail length] > 0) {
                    //theMessage.postImageArray = [NSMutableArray arrayWithObject:[Base64 decode:tmpActivity.thumbnail]];
                }else{
                    theMessage.postImageArray = [NSMutableArray array];
                }
                
                
                //Profile Image
                theMessage.picImageData = [NSData data];
                
                
                rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                     action:@"Activity Everyone - Row Selected"
                                                      label:mainDelegate.token
                                                      value:-1
                                                  withError:nil]) {
                }
                
                [self.navigationController pushViewController:theMessage animated:YES];  
                
            }else{
                //Polls
            }
            
        }else{
            //my
            
            [TraceSession addEventToSession:@"Activity Page - Me Row Clicked"];
            
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                 action:@"My Activity - Row Selected"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:nil]) {
            }
            
            if ([[self.myActivityArray objectAtIndex:row] class] == [MessageThreadInbox class]) {
                MessageThreadInbox *messageOrPoll = [self.myActivityArray objectAtIndex:row];
                
                if ([messageOrPoll.pollChoices count] > 0) {
                    ViewPollReceived *poll = [[ViewPollReceived alloc] init];
                    
                    poll.teamId = messageOrPoll.teamId;
                    poll.threadId = messageOrPoll.threadId;
                    poll.pollChoices = messageOrPoll.pollChoices;
                    poll.from = messageOrPoll.senderName;
                    poll.subject = messageOrPoll.subject;
                    poll.body = messageOrPoll.body;
                    poll.teamName = messageOrPoll.teamName;
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
                    NSDate *tmpDate = [dateFormat dateFromString:messageOrPoll.createdDate];
                    [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm aa"];
                    poll.receivedDate = [dateFormat stringFromDate:tmpDate];
                    
                    poll.wasViewed = messageOrPoll.wasViewed;
                    
                    poll.status = messageOrPoll.status;
                    poll.fromClass = self;
                    
                    
                    
                    [self.navigationController pushViewController:poll animated:YES];
                }else {
                    
                    
                    
                    ViewMessageReceived *message = [[ViewMessageReceived alloc] init];
                    message.fromClass = self;
                    
                    message.subject = messageOrPoll.subject;
                    message.body = messageOrPoll.body;
                    message.userRole = messageOrPoll.participantRole;
                    message.teamId = messageOrPoll.teamId;
                    
                    message.confirmStatus = messageOrPoll.status;
                    
                    message.receivedDate = messageOrPoll.createdDate;
                    
                    message.wasViewed = messageOrPoll.wasViewed;
                    message.threadId = messageOrPoll.threadId;
                    message.senderId = messageOrPoll.senderId;
                    message.senderName = messageOrPoll.senderName;
                    message.teamName = messageOrPoll.teamName;
                    
                    
                    
                    [self.navigationController pushViewController:message animated:YES];
                    
                    
                    
                }
                
            }else{
                //Outbox
                
                MessageThreadOutbox *message = [self.myActivityArray objectAtIndex:row];
                
                if ([message.messageType isEqualToString:@"poll"] || [message.messageType isEqualToString:@"whoiscoming"]) {
                    
                    ViewPollSent *tmp = [[ViewPollSent alloc] init];
                    tmp.fromClass = self;
                    tmp.teamId = message.teamId;
                    
                    tmp.messageThreadId = message.threadId;
                    tmp.teamName = message.teamName;
                    NSString *recipients = message.numRecipients;
                    NSString *replies = message.numReplies;
                    
                    if (recipients == nil) {
                        recipients = @"0";
                    }
                    if (replies == nil) {
                        replies = @"0";
                    }
                    
                    if ([message.status isEqualToString:@"finalized"]) {
                        tmp.replyFraction = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people replied."];
                    }else {
                        tmp.replyFraction = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people have replied."];
                    }
                    
                    
                    
                    
                    [self.navigationController pushViewController:tmp animated:YES];
                    
                    
                    
                    
                }else {
                    
                    ViewMessageSent *viewMessage = [[ViewMessageSent alloc] init];
                    
                    viewMessage.fromClass = self;
                    viewMessage.subject = message.subject;
                    viewMessage.body = message.body;
                    viewMessage.threadId = message.threadId;
                    viewMessage.createdDate = message.createdDate;
                    viewMessage.teamName = message.teamName;
                    viewMessage.teamId = message.teamId;
                    
                    
                    NSString *recipients = message.numRecipients;
                    NSString *replies = message.numReplies;
                    
                    
                    if (recipients == nil) {
                        recipients = @"0";
                    }
                    if (replies == nil) {
                        replies = @"0";
                    }
                    
                    NSString *replyString = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people have confirmed."];
                    
                    viewMessage.confirmString = replyString;
                    
                    
                    
                    [self.navigationController pushViewController:viewMessage animated:YES];
                    
                }
                
            }
            
        }

    }
    @catch (NSException *exception) {
       
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        [GoogleAppEngine sendExceptionCaught:exception inMethod:@"NewActivity.m - didSelectRowAtIndexPath()" theRecordedDate:[NSDate date] theRecordedUserName:mainDelegate.token theInstanceUrl:@""];
    }
      
}

-(NSString *)formatDateString:(NSString *)dateSent{
	//If its today, just return the time
	//If its yesterday, return "Yesterday"
	//else, return format MM/DD/YY
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
	
    NSDate *messageDate = [dateFormat dateFromString:dateSent];
	NSDate *todaysDate = [NSDate date];
	NSDate *yesterdaysDate = [todaysDate dateByAddingTimeInterval:-86400];
	
	[dateFormat setDateFormat:@"yyyyMMdd"];
	NSString *messageString = [dateFormat stringFromDate:messageDate];
	NSString *todayString = [dateFormat stringFromDate:todaysDate];
	NSString *yesterdayString = [dateFormat stringFromDate:yesterdaysDate];
	
	NSString *returnDate = @"";
	if ([messageString isEqualToString:todayString]) {
		//Date is today, return the message time
		[dateFormat setDateFormat:@"hh:mm aa"];
		
		returnDate = [dateFormat stringFromDate:messageDate];
	}else if ([messageString isEqualToString:yesterdayString]) {
		//Date was yesterday
		returnDate = @"Yesterday";
	}else {
		//Date was not today or yesterday
		[dateFormat setDateFormat:@"MMM dd"];
		
		returnDate = [dateFormat stringFromDate:messageDate];
	}
	
	return returnDate;
	
}



//iAd delegate methods and FAST
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
	
	return YES;
	
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    
	if (!self.bannerIsVisible) {
                
        CGRect frame = self.allActivityTable.frame;
        frame.size.height = 341;
        self.allActivityTable.frame = frame;
        
        CGRect frame1 = self.myActivityTable.frame;
        frame1.size.height = 341;
        self.myActivityTable.frame = frame1;
        
        CGRect frame2 = self.photoBackView.frame;
        frame2.size.height = 341;
        self.photoBackView.frame = frame2;
        
        
		self.bannerIsVisible = YES;
		myAd.hidden = NO;
        
        [self.view bringSubviewToFront:myAd];
        
	}
}


- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{

	if (self.bannerIsVisible) {
   
        CGRect frame = self.allActivityTable.frame;
        frame.size.height = 391;
        self.allActivityTable.frame = frame;
        
        CGRect frame1 = self.myActivityTable.frame;
        frame1.size.height = 391;
        self.myActivityTable.frame = frame1;
        
        CGRect frame2 = self.photoBackView.frame;
        frame2.size.height = 391;
        self.photoBackView.frame = frame2;
        
		myAd.hidden = YES;
		self.bannerIsVisible = NO;
		
	}
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
    [FastActionSheet doAction:self :buttonIndex];

	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}


//Scroll down to refresh method
- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
    
    textPull2 = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease2 = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading2 = [[NSString alloc] initWithString:@"Loading..."];
    
    textPull3 = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease3 = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading3 = [[NSString alloc] initWithString:@"Loading..."];
    
  
    
}


//Scroll down to refresh method
- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    
    [self.allActivityTable addSubview:refreshHeaderView];
    
    
    refreshHeaderView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView2.backgroundColor = [UIColor clearColor];
    
    refreshLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel2.backgroundColor = [UIColor clearColor];
    refreshLabel2.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel2.textAlignment = UITextAlignmentCenter;
    
    refreshArrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow2.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                     (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                     27, 44);
    
    refreshSpinner2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner2.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner2.hidesWhenStopped = YES;
    
    [refreshHeaderView2 addSubview:refreshLabel2];
    [refreshHeaderView2 addSubview:refreshArrow2];
    [refreshHeaderView2 addSubview:refreshSpinner2];
    
    [self.myActivityTable addSubview:refreshHeaderView2];
    
    refreshHeaderView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView3.backgroundColor = [UIColor clearColor];
    
    refreshLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel3.backgroundColor = [UIColor clearColor];
    refreshLabel3.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel3.textAlignment = UITextAlignmentCenter;
    
    refreshArrow3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow3.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                     (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                     27, 44);
    
    refreshSpinner3 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner3.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner3.hidesWhenStopped = YES;
    
    [refreshHeaderView3 addSubview:refreshLabel3];
    [refreshHeaderView3 addSubview:refreshArrow3];
    [refreshHeaderView3 addSubview:refreshSpinner3];
    
    [self.photoBackView addSubview:refreshHeaderView3];
    [self.photoBackView bringSubviewToFront:refreshHeaderView3];
    refreshHeaderView3.backgroundColor = [UIColor clearColor];

    
   
    
}

//Scroll down to refresh method
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}



//Scroll down to refresh method
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (scrollView == self.bottomScrollView) {
        
    }else{
        if (isLoading) return;
        isDragging = NO;
        if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
            // Released above the header
            [self startLoading];
        }
    }
    
}

//Scroll down to refresh method
- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if ([self.currentTable isEqualToString:@"everyone"]) {
        self.allActivityTable.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }else if ([self.currentTable isEqualToString:@"me"]){
        self.myActivityTable.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel2.text = self.textLoading2;
        refreshArrow2.hidden = YES;
        [refreshSpinner2 startAnimating];
    }else{
        self.photoBackView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel3.text = self.textLoading3;
        refreshArrow3.hidden = YES;
        [refreshSpinner3 startAnimating];
    }
    
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

//Scroll down to refresh method
- (void)stopLoading {
    self.shouldCallStop = false;
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    
    if ([self.currentTable isEqualToString:@"everyone"]) {
        self.allActivityTable.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        
    }else if ([self.currentTable isEqualToString:@"me"]){
        self.myActivityTable.contentInset = UIEdgeInsetsZero;
        [refreshArrow2 layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        
    }else{
        self.photoBackView.contentInset = UIEdgeInsetsZero;
        [refreshArrow3 layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
    
    [UIView commitAnimations];
}

//Scroll down to refresh method
- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
    if ([self.currentTable isEqualToString:@"everyone"]) {
        refreshLabel.text = self.textPull;
        refreshArrow.hidden = NO;
        [refreshSpinner stopAnimating];
        
    }else if ([self.currentTable isEqualToString:@"me"]){
        refreshLabel2.text = self.textPull2;
        refreshArrow2.hidden = NO;
        [refreshSpinner2 stopAnimating];
        
    }else{
        refreshLabel3.text = self.textPull3;
        refreshArrow3.hidden = NO;
        [refreshSpinner3 stopAnimating];
    }
}

//Scroll down to refresh method
- (void)refresh {
    // Don't forget to call stopLoading at the end.
    self.shouldCallStop = true;
    
    if ([self.currentTable isEqualToString:@"everyone"]) {
        
        [TraceSession addEventToSession:@"Activity Page - All Activity Refreshed Clicked"];

        [self performSelectorInBackground:@selector(getNewActivity) withObject:nil];
        
    }else if ([self.currentTable isEqualToString:@"me"]){
        
        [TraceSession addEventToSession:@"Activity Page - My Activity Refreshed Clicked"];

        [self performSelectorInBackground:@selector(getMyActivity) withObject:nil];
        
    }else{
        [TraceSession addEventToSession:@"Activity Page - Photo Refreshed Clicked"];
       
        NSDate *today = [NSDate date];
        NSDate *tomorrow = [NSDate dateWithTimeInterval:86400 sinceDate:today];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"YYYY-MM-dd"];
        
        NSString *dateString = [format stringFromDate:tomorrow];
        
        [self performSelectorInBackground:@selector(getActivityPhotos:) withObject:dateString];
        
    }
}


-(void)getNewActivity{
    
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        if (![token isEqualToString:@""]){	
            
            NSDate *today = [NSDate date];
            NSDate *tomorrow = [NSDate dateWithTimeInterval:86400 sinceDate:today];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"YYYY-MM-dd"];
            NSString *dateString = [format stringFromDate:tomorrow];
            
            NSDictionary *response = [ServerAPI getActivity:token maxCount:@"25" refreshFirst:@"true" newOnly:@"" mostCurrentDate:dateString totalNumberOfDays:@"20" includeDetails:@"false" mediaOnly:@""];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.tmpActivityArray = [response valueForKey:@"activities"];
                self.newActivityFailed = false;
                
            }else{
                
                self.newActivityFailed = true;
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                //[self.errorLabel setHidden:NO];
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    case 208:
                        self.errorString = @"NA";
                        break;
                    default:
                        //log status code?
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                }
            }
        }
        [self performSelectorOnMainThread:@selector(doneNewActivity) withObject:nil waitUntilDone:NO];

    }
	
}

-(void)doneNewActivity{
    
    
    if ([self.errorString isEqualToString:@"NA"]) {
        NSString *tmp = @"Only User's with confirmed email addresses can access Activity.  To confirm your email, please click on the activation link in the email we sent you.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    if (self.shouldCallStop) {
        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0];
    }
    
    if (!self.newActivityFailed) {
        self.hasNewActivity = true;
    }
    self.activityArray = [NSMutableArray arrayWithArray:self.tmpActivityArray];
    
 
    
    [self performSelectorInBackground:@selector(getUserVotes) withObject:nil];
    
    rTeamAppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *activityIds = [NSMutableArray array];
    
    
    for (int i = 0; i < [self.activityArray count]; i++) {
        Activity *tmpActivity = [self.activityArray objectAtIndex:i];
        
        if (([mainDelegate.replyDictionary objectForKey:tmpActivity.activityId] == nil) && ([mainDelegate.messageImageDictionary objectForKey:tmpActivity.activityId] == nil)) {
            [activityIds addObject:tmpActivity.activityId];
        }else{
            
            [activityIds addObject:tmpActivity.activityId];

            if ([mainDelegate.replyDictionary objectForKey:tmpActivity.activityId] != nil) {
                
                NSArray *replies = [mainDelegate.replyDictionary valueForKey:tmpActivity.activityId];
                
                if ([replies count] > 0) {
                    Activity *tmp = [replies objectAtIndex:0];
                    
                    tmpActivity.lastEditDate = [NSString stringWithFormat:tmp.createdDate];
                }
            }
            

        }
    }
    
    NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"lastEditDate" ascending:NO];
    [self.activityArray sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
    
    self.allActivityTable.hidden = NO;
    [self.allActivityTable reloadData];
    
    NSArray *idArray = [NSArray arrayWithArray:activityIds];
    [self performSelectorInBackground:@selector(getActivityDetails:) withObject:idArray];
    //[self performSelectorInBackground:@selector(getUserImages) withObject:nil];

    
    self.errorString = @"";
   	
}

-(void)getActivityDetails:(NSArray *)idArray{
    
    
    @autoreleasepool {

        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

        NSDictionary *response = [ServerAPI getActivityDetails:mainDelegate.token activityIds:idArray];
        
        NSString *status = [response valueForKey:@"status"];
        
        NSArray *details = [NSArray array];
        if ([status isEqualToString:@"100"]){
            
           details = [response valueForKey:@"activities"];

        }else{
            
            int statusCode = [status intValue];
            
            switch (statusCode) {
                case 0:
                    //null parameter
                    //self.error = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    //self.error = @"*Error connecting to server";
                    break;
                default:
                    //should never get here
                    //self.error = @"*Error connecting to server";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:@selector(doneActivityDetails:) withObject:details waitUntilDone:NO];
        
    }

}

-(void)doneActivityDetails:(NSArray *)details{
    
    NSMutableArray *totalReplies = [NSMutableArray array];
    rTeamAppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    if ([details count] > 0) {
        
        for (int i = 0; i < [details count]; i++) {
            
            NSDictionary *tmpDictionary = [details objectAtIndex:i];
            
            NSString *activityId = [tmpDictionary valueForKey:@"activityId"];
            NSString *thumbnail = [tmpDictionary valueForKey:@"thumbNail"];
            NSArray *replies = [tmpDictionary valueForKey:@"replies"];
                        
            if ([thumbnail length] > 0) {
                
                for (int j = 0; j < [self.activityArray count]; j++) {
                    Activity *tmpActivity = [self.activityArray objectAtIndex:j];
                    
                    if ([tmpActivity.activityId isEqualToString:activityId]) {

                        [mainDelegate.messageImageDictionary setValue:thumbnail forKey:tmpActivity.activityId];
                        break;
                    }
                }
            }
            
            
            if ([replies count] > 0) {
                
                totalReplies = [NSMutableArray arrayWithArray:[totalReplies arrayByAddingObjectsFromArray:replies]];

                for (int j = 0; j < [self.activityArray count]; j++) {
                    Activity *tmpActivity = [self.activityArray objectAtIndex:j];
                    NSMutableArray *mutableReplyArray = [NSMutableArray array];
                    
                    if ([tmpActivity.activityId isEqualToString:activityId]) {
                        
                        for (int k = 0; k < [replies count]; k++) {
                            
                            NSDictionary *tmpDict = [replies objectAtIndex:k];
                            
                            Activity *tmpReply = [[Activity alloc] init];
                                                        
                            tmpReply.activityText = [tmpDict valueForKey:@"text"];
                            tmpReply.createdDate = [tmpDict valueForKey:@"createdDate"];
                            tmpReply.cacheId = [tmpDict valueForKey:@"cacheId"];
                            
                            
                            tmpReply.teamId = [tmpDict valueForKey:@"teamId"];
                            tmpReply.teamName = [tmpDict valueForKey:@"teamName"];
                            tmpReply.senderName = [tmpDict valueForKey:@"poster"];
                            
                            tmpReply.activityId = [tmpDict valueForKey:@"activityId"];
                            
                            tmpReply.numLikes = [[tmpDict valueForKey:@"numberOfLikeVotes"] intValue];
                            tmpReply.numDislikes = [[tmpDict valueForKey:@"numberOfDislikeVotes"] intValue];
                            
                            tmpReply.isVideo = [[tmpDict valueForKey:@"isVideo"] boolValue];
                            tmpReply.isCurrentUser = [[tmpDict valueForKey:@"isCurrentUser"] boolValue];
                            
                            tmpReply.vote = [tmpDict valueForKey:@"vote"];
                            tmpReply.replies = [NSArray array];
                            
                            if ([tmpDict valueForKey:@"thumbNail"] != nil) {
                                tmpReply.thumbnail = [tmpDict valueForKey:@"thumbNail"];
                            }else {
                                tmpReply.thumbnail = @"";
                            }
                                                
                            [mutableReplyArray addObject:tmpReply];
                            [self.totalReplyArray addObject:tmpReply];
                        }
                        
                        NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
                        [mutableReplyArray sortUsingDescriptors:[NSArray arrayWithObject:dateSort]];
                        
                        [mainDelegate.replyDictionary setValue:mutableReplyArray forKey:tmpActivity.activityId];
                                                
                        if ([mutableReplyArray count] > 0) {
                            Activity *tmpReply = [mutableReplyArray objectAtIndex:0];
                            
                            tmpActivity.lastEditDate = [NSString stringWithFormat:tmpReply.createdDate];

                        }

                        
                        break;
                    }
                }              
            }
        }
        
    }
    
    [self performSelectorInBackground:@selector(getReplyImages:) withObject:totalReplies];

    NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"lastEditDate" ascending:NO];
    [self.activityArray sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
    
    [self.allActivityTable reloadData];
}

-(void)getMyActivity{
    
    @autoreleasepool {
        NSMutableArray *messages = [NSMutableArray array];
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSDictionary *response = [ServerAPI getMessageThreads:mainDelegate.token :@"" :@"" :@"" :@"" :@"" :@"active"];
        
        NSString *status = [response valueForKey:@"status"];
        
        if ([status isEqualToString:@"100"]){
            
            messages = [response valueForKey:@"messages"];
            
        }else{
            
            int statusCode = [status intValue];
            
            switch (statusCode) {
                case 0:
                    //null parameter
                    //self.error = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    //self.error = @"*Error connecting to server";
                    break;
                default:
                    //should never get here
                    //self.error = @"*Error connecting to server";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:@selector(doneMyActivity:) withObject:messages waitUntilDone:NO];

    }
       
}

-(void)doneMyActivity:(NSMutableArray *)messages{
    
    self.didInitMyActivity = true;
    if (self.shouldCallStop) {
        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0];
    }
    
    for (int i = 0; i < [messages count]; i++) {
        
        id tmpObject = [messages objectAtIndex:i];
        
        if ([tmpObject class] == [MessageThreadInbox class]) {
            
        }else{
            
        }
    }
    
    self.myActivityTable.hidden = NO;
    self.myActivityArray = [NSMutableArray arrayWithArray:messages];
    

    //Sort the array
    
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
    [self.myActivityArray sortUsingDescriptors:[NSArray arrayWithObject:dateSort]];
    
    [self.myActivityTable reloadData];
    
    if (self.currentMiddle == 3) {
        if ([self.myActivityArray count] > 0) {
            [self performSelectorInBackground:@selector(updateWasViewed) withObject:nil];
        }
    }
}


-(void)getPhotos{

    
    [self performSelectorOnMainThread:@selector(donePhotos) withObject:nil waitUntilDone:NO];
}
-(void)donePhotos{
    
}

//Finds the height of a string constrained by the input width
-(int)findHeightForString:(NSString *)message withWidth:(int)width{
    
    CGSize constraints = CGSizeMake(width, 900);
    CGSize totalSize = [message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraints];
    
    return totalSize.height;
    
}


//For clicking on an image inside the message (company feed)
-(void)imageSelected:(id)sender{
    
    [TraceSession addEventToSession:@"Activity Page - Image Clicked"];

        
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Image Selected - Activity"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    
    ImageButton *tmpButton = (ImageButton *)sender;
    
    NSString *messageId = [NSString stringWithString:tmpButton.messageId];
    NSString *teamId = @"";
    NSMutableArray *arrayOfImageData = [NSMutableArray array];
    for (int i = 0; i < [self.activityArray count]; i++) {
        Activity *tmpActivity = [self.activityArray objectAtIndex:i];
        
        if ([tmpActivity.activityId isEqualToString:messageId]) {
            NSData *profileData = [Base64 decode:tmpActivity.thumbnail];
            [arrayOfImageData addObject:profileData];
            teamId = tmpActivity.teamId;
            break;
        }
    }
    
    for (int i = 0; i < [self.totalReplyArray count]; i++) {
        Activity *tmpActivity = [self.totalReplyArray objectAtIndex:i];
        
        if ([tmpActivity.activityId isEqualToString:messageId]) {
            NSData *profileData = [Base64 decode:tmpActivity.thumbnail];
            [arrayOfImageData addObject:profileData];
            teamId = tmpActivity.teamId;
            break;
        }
    }
    
    ImageDisplayMultiple *newDisplay = [[ImageDisplayMultiple alloc] init];
    newDisplay.activityId = messageId;
    newDisplay.teamId = teamId;
    [self.navigationController pushViewController:newDisplay animated:YES];    
    
}


-(void)photoSelected:(id)sender{
    
    [TraceSession addEventToSession:@"Activity Photo Page - Image Clicked"];
    
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Image Selected - Activity Photos"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    
    ImageButton *tmpButton = (ImageButton *)sender;
    
    Activity *tmpActivity = [self.photosArray objectAtIndex:tmpButton.tag];
    
    ImageDisplayMultiple *newDisplay = [[ImageDisplayMultiple alloc] init];
    newDisplay.activityId = tmpActivity.activityId;
    newDisplay.teamId = tmpActivity.teamId;
    [self.navigationController pushViewController:newDisplay animated:YES];    
    
}

-(void)videoSelected:(id)sender{
        
    [TraceSession addEventToSession:@"Activity Page - Video Clicked"];
    
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Video Selected - Activity"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    ImageButton *tmpButton = (ImageButton *)sender;
    
    NSString *messageId = [NSString stringWithString:tmpButton.messageId];
    NSString *teamId = @"";
    NSMutableArray *arrayOfImageData = [NSMutableArray array];
    for (int i = 0; i < [self.activityArray count]; i++) {
        Activity *tmpActivity = [self.activityArray objectAtIndex:i];
        
        if ([tmpActivity.activityId isEqualToString:messageId]) {
            NSData *profileData = [Base64 decode:tmpActivity.thumbnail];
            [arrayOfImageData addObject:profileData];
            teamId = tmpActivity.teamId;
            break;
        }
    }
    
    for (int i = 0; i < [self.totalReplyArray count]; i++) {
        Activity *tmpActivity = [self.totalReplyArray objectAtIndex:i];
        
        if ([tmpActivity.activityId isEqualToString:messageId]) {
            NSData *profileData = [Base64 decode:tmpActivity.thumbnail];
            [arrayOfImageData addObject:profileData];
            teamId = tmpActivity.teamId;
            break;
        }
    }
    
    VideoDisplay *newDisplay = [[VideoDisplay alloc] init];
    newDisplay.activityId = messageId;
    newDisplay.teamId = teamId;
    [self.navigationController pushViewController:newDisplay animated:YES];    
    
}


-(void)photoSelectedVideo:(id)sender{
    
    [TraceSession addEventToSession:@"Activity Photo Page - Video Clicked"];
    
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Video Selected - Activity Photos"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    ImageButton *tmpButton = (ImageButton *)sender;
    
    Activity *tmpActivity = [self.photosArray objectAtIndex:tmpButton.tag];
    
    
    VideoDisplay *newDisplay = [[VideoDisplay alloc] init];
    newDisplay.activityId = tmpActivity.activityId;
    newDisplay.teamId = tmpActivity.teamId;
    
    UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = temp;
    
    [self.navigationController pushViewController:newDisplay animated:NO];    
    
}

-(void)getUserVotes{
    
    @autoreleasepool {
        
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        if (![token isEqualToString:@""]){	
            
            
            //Build the comma separated list of activity ids
            NSString *activityIds = @"";
            for (int i = 0; i < [self.activityArray count]; i++) {
                
                Activity *tmpActivity = [self.activityArray objectAtIndex:i];
                
                if (i == ([self.activityArray count] - 1)) {
                    activityIds = [activityIds stringByAppendingFormat:@"%@", tmpActivity.activityId];
                    
                }else {
                    activityIds = [activityIds stringByAppendingFormat:@"%@,", tmpActivity.activityId];
                    
                }
                
            }
            
            
            NSDictionary *response = [ServerAPI getActivityStatus:token :activityIds];
            
            
            NSString *status = [response valueForKey:@"status"];
            
            
            if ([status isEqualToString:@"100"]){
                
                NSArray *activityResponses = [response valueForKey:@"activities"];
                
                for (int i = 0; i < [activityResponses count]; i++) {
                    
                    NSDictionary *tmpDictionary = [activityResponses objectAtIndex:i];
                    
                    NSString *currentActId = [tmpDictionary valueForKey:@"activityId"];
                    NSString *vote = [tmpDictionary valueForKey:@"vote"];
                    
                    
                    for (int j = 0; j < [self.activityArray count]; j++) {
                        
                        Activity *tmpActivity = [self.activityArray objectAtIndex:j];
                        
                        if ([tmpActivity.activityId isEqualToString:currentActId]) {
                            
                            tmpActivity.vote = vote;
                            break;
                        }
                    }
                    
                    
                }
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                //[self.errorLabel setHidden:NO];
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    default:
                        //log status code?
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                }
            }
        }
        
    }
    
}
    


- (void)getUserImages {
	/*
    @autoreleasepool {
        //Create the new player
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        for (int i = 0; i < [self.players count]; i++) {
            
            
            if ([self.players count] > i) {
                
                Player *controller = [self.players objectAtIndex:i];
                
                NSDictionary *response = [ServerAPI getMemberInfo:self.teamId :controller.memberId :mainDelegate.token :@""];
                
                
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    NSDictionary *memberInfo = [response valueForKey:@"memberInfo"];
                    
                    NSString *profile = [memberInfo valueForKey:@"thumbNail"];
                    
                    
                    if ((profile == nil)  || ([profile isEqualToString:@""])){
                        
                        
                    }else {
                        
                        if ([self.playerPics count] > i) {
                            [self.playerPics replaceObjectAtIndex:i withObject:profile];
                            
                        }
                    }
                    
                    [self performSelectorOnMainThread:
                     @selector(didFinishPlayers)
                                           withObject:nil
                                        waitUntilDone:NO
                     ];
                    
                }else{
                    int statusCode = [status intValue];
                    
                    switch (statusCode) {
                        case 0:
                            //null parameter
                            //self.error = @"*Error connecting to server";
                            break;
                        case 1:
                            //error connecting to server
                            //self.error = @"*Error connecting to server";
                            break;
                        default:
                            //should never get here
                            //self.error = @"*Error connecting to server";
                            break;
                    }
                }
                
            }
            
        }
        
    }
	
	*/
}


    
-(void)cancelSwipe{
    
    self.swipeAlert.hidden = YES;
}


-(void)getReplyImages:(NSArray *)repliesArray{
    
    
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableArray *idArray = [NSMutableArray array];
        for (int i = 0; i < [repliesArray count]; i++) {
            
            NSDictionary *tmpDict = [repliesArray objectAtIndex:i];            
            NSString *activityId = [tmpDict valueForKey:@"activityId"];
            
            if ((activityId != nil) && ![activityId isEqualToString:@""]) {
                [idArray addObject:activityId];
            }
        }
                                
        NSDictionary *response = [ServerAPI getActivityDetails:mainDelegate.token activityIds:idArray];
        
        NSString *status = [response valueForKey:@"status"];
                
        NSArray *details = [NSArray array];
        if ([status isEqualToString:@"100"]){
            
            details = [response valueForKey:@"activities"];
            
        }else{
            
            int statusCode = [status intValue];
            
            switch (statusCode) {
                case 0:
                    //null parameter
                    //self.error = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    //self.error = @"*Error connecting to server";
                    break;
                default:
                    //should never get here
                    //self.error = @"*Error connecting to server";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:@selector(doneReplyImages:) withObject:details waitUntilDone:NO];
        
    }
    
}

-(void)doneReplyImages:(NSArray *)details{
    
    rTeamAppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    if ([details count] > 0) {
        
        for (int i = 0; i < [details count]; i++) {
            
            NSDictionary *tmpDictionary = [details objectAtIndex:i];
            
            NSString *activityId = [tmpDictionary valueForKey:@"activityId"];
            NSString *thumbnail = [tmpDictionary valueForKey:@"thumbNail"];

            
            if ([thumbnail length] > 0) {
                
                [mainDelegate.messageImageDictionary setValue:thumbnail forKey:activityId];

            }
                                
        }
        
    }

    
    [self.allActivityTable reloadData];

    
}


-(void)updateWasViewed{
    
	@autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        
        for (int i = 0; i < [self.myActivityArray count]; i++) {
            
            NSString *sendTeamId = @"";
            NSString *sendThreadId = @"";
            
            if ([[self.myActivityArray objectAtIndex:i] class] == [MessageThreadInbox class]) {
                MessageThreadInbox *messageOrPoll = [self.myActivityArray objectAtIndex:i];
                
                sendTeamId = messageOrPoll.teamId;
                sendThreadId = messageOrPoll.threadId;
                
                if (!messageOrPoll.wasViewed) {
                    NSDictionary *response = [ServerAPI updateMessageThread:token :sendTeamId :sendThreadId :@"" :@"true" :@"" :@"" :@""];
                    if ([response valueForKey:@"status"] != nil) {
                        
                    }
                }
            }
            

          
            
        }
        
    }

	
}

-(void)viewScore:(id)sender{
    
   
    @try {
        ScoreButton *tmpButton = sender;
        Activity *newActivity = tmpButton.activity;
    
        
        /*
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Go To Game Page - Activity"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        */
        
        
        NSString *tmpUserRole = [NSString stringWithString:newActivity.participantRole];
        NSString *tmpTeamId = [NSString stringWithString:newActivity.teamId];
        NSString *tmpGameId = [NSString stringWithString:newActivity.eventId];
        NSString *tmpTeamName = [NSString stringWithString:newActivity.teamName];
        NSString *tmpDate = [NSString stringWithString:newActivity.startDate];
        NSString *tmpDescription = [NSString stringWithString:newActivity.description];
        NSString *tmpSport = [NSString stringWithString:newActivity.sport];
        
        if ([tmpUserRole isEqualToString:@"creator"] || [tmpUserRole isEqualToString:@"coordinator"]) {
            GameTabs *currentGameTab = [[GameTabs alloc] init];
            currentGameTab.fromHome = true;
            
            NSArray *tmpViews = currentGameTab.viewControllers;
            currentGameTab.teamId = tmpTeamId;
            currentGameTab.gameId = tmpGameId;
            currentGameTab.userRole = tmpUserRole;
            currentGameTab.teamName = tmpTeamName;
            currentGameTab.fromActivity = true;

            Gameday *currentNotes = [tmpViews objectAtIndex:0];
            currentNotes.gameId = tmpGameId;
            currentNotes.teamId = tmpTeamId;
            currentNotes.userRole = tmpUserRole;
            currentNotes.sport = tmpSport;
            currentNotes.startDate = tmpDate;
            currentNotes.opponentString = @"";
            currentNotes.description = tmpDescription;
            
            
            
            GameAttendance *currentAttendance = [tmpViews objectAtIndex:1];
            currentAttendance.gameId = tmpGameId;
            currentAttendance.teamId = tmpTeamId;
            currentAttendance.startDate = tmpDate;
            
            Vote *fans = [tmpViews objectAtIndex:2];
            fans.teamId = tmpTeamId;
            fans.userRole = tmpUserRole;
            fans.gameId = tmpGameId;
            
            
            UINavigationController *navController = [[UINavigationController alloc] init];
            
            [navController pushViewController:currentGameTab animated:YES];
            
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        
            [self.navigationController presentModalViewController:navController animated:YES];
            
            
        }else {
            
            GameTabsNoCoord *currentGameTab = [[GameTabsNoCoord alloc] init];
            currentGameTab.fromHome = true;
            NSArray *tmpViews = currentGameTab.viewControllers;
            currentGameTab.teamId = tmpTeamId;
            currentGameTab.gameId =tmpGameId;
            currentGameTab.userRole = tmpUserRole;
            currentGameTab.teamName = tmpTeamName;
            currentGameTab.fromActivity = true;

            
            Gameday *currentNotes = [tmpViews objectAtIndex:0];
            currentNotes.gameId = tmpGameId;
            currentNotes.teamId = tmpTeamId;
            currentNotes.userRole = tmpUserRole;
            currentNotes.sport = tmpSport;
            currentNotes.description = tmpDescription;
            currentNotes.startDate = tmpDate;
            currentNotes.opponentString = @"";

            
            Vote *fans = [tmpViews objectAtIndex:1];
            fans.teamId = tmpTeamId;
            fans.userRole = tmpUserRole;
            fans.gameId = tmpGameId;
            
            UINavigationController *navController = [[UINavigationController alloc] init];
            
            [navController pushViewController:currentGameTab animated:YES];
            
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            
            [self.navigationController presentModalViewController:navController animated:YES];
            
            
            
        }

    }
    @catch (NSException *exception) {
        
    }
 
        
        
    
    
    /*
    homeScoreView.view.hidden = NO;
    
    homeScoreView.homeSuperView = nil;
    homeScoreView.teamName = @"Team Name";
    homeScoreView.scoreUs = @"15";
    homeScoreView.scoreThem = @"13";
    homeScoreView.interval = @"-1";
    
    homeScoreView.eventDate = @"";
    homeScoreView.eventDescription = @"";
    homeScoreView.eventStringDate = @"";
    
    
    //homeScoreView.teamId = tmp.teamId;
    homeScoreView.participantRole = @"creator";
    //homeScoreView.eventId = tmp.eventId;
    homeScoreView.sport = @"Basketball";
    
    
    [homeScoreView setLabels];
    
    [self moveDivider];

    */
}

-(void)moveDivider{
    
    //if (self.isMoreShowing) {
        /*
        self.showLessButton.hidden = YES;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        
        self.bottomBar.hidden = NO;
        [self.view bringSubviewToFront:self.bottomBar];
        [self.view bringSubviewToFront:self.postImageBackView];
        
        
        CGRect frame = self.happeningNowView.frame;
        if (self.bannerIsVisible) {
            frame.origin.y = 201;
        }else{
            frame.origin.y = 251;
        }
        self.happeningNowView.frame = frame;
        
        
        CGRect frame1 = self.homeAttendanceView.view.frame;
        if (self.bannerIsVisible) {
            frame1.origin.y = 322;
        }else{
            frame1.origin.y = 372;
        }
        self.homeAttendanceView.view.frame = frame1;
        
        CGRect frame2 = self.homeScoreView.view.frame;
        if (self.bannerIsVisible) {
            frame2.origin.y = 322;
        }else{
            frame2.origin.y = 372;
        }
        self.homeScoreView.view.frame = frame2;
        [self.homeScoreView doReset];
        
        
        [UIView commitAnimations];
        
        [self performSelector:@selector(hide) withObject:nil afterDelay:1.0];
        
        self.isMoreShowing = NO;
        
        self.isGameVisible = false;
        */
    //}else{
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        
        int init = 0;
        bool isAd = false;
        if (self.bannerIsVisible) {
            init = 50;
            isAd = true;
        }
        
 
        
        
        
        
        
        CGRect frame2 = self.homeScoreView.view.frame;
        frame2.origin.y = 121;
        if (isAd) {
            frame2.size.height = 245;
        }else{
            frame2.size.height = 295;
        }
        self.homeScoreView.view.frame = frame2;
        
        if (self.homeScoreView.view.hidden == NO) {
            
            self.homeScoreView.isFullScreen = true;
            [self.homeScoreView.fullScreenButton setImage:[UIImage imageNamed:@"smallScreen.png"] forState:UIControlStateNormal];
            
            CGRect frame = self.homeScoreView.view.frame;
            frame.origin.y = 0;
            frame.size.height += 121;
            self.homeScoreView.view.frame = frame;
            
        }
        
        
        
        
        [UIView commitAnimations];
        
        homeScoreView.initY = init;
        
        if (self.bannerIsVisible){
            [self.view bringSubviewToFront:myAd];
            
        }
        
        
        
   // }
    
    
}

-(void)getActivityPhotos:(NSString *)dateString{
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        if (![token isEqualToString:@""]){	
            
       
            
            NSDictionary *response = [ServerAPI getActivity:token maxCount:@"6" refreshFirst:@"" newOnly:@"" mostCurrentDate:dateString totalNumberOfDays:@"" includeDetails:@"true" mediaOnly:@"true"];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.tmpPhotosArray = [NSMutableArray arrayWithArray:[response valueForKey:@"activities"]];
                                                
                if ([self.tmpPhotosArray count] < 6) {
                    self.canLoadMorePhotos = false;
                }else{
                    self.canLoadMorePhotos = true;
                }
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                //[self.errorLabel setHidden:NO];
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    case 208:
                        self.errorString = @"NA";
                        break;
                    default:
                        //log status code?
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                }
            }
        }
        [self performSelectorOnMainThread:@selector(doneActivityPhotos) withObject:nil waitUntilDone:NO];
        
    }
}

-(void)doneActivityPhotos{
        
    bool reset = false;
    if (self.shouldCallStop) {
        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0];
        reset = true;
    }
    
    [self.photoActivity stopAnimating];
    
    if ([self.tmpPhotosArray count] > 0) {
        
        if (reset) {
            
            self.photosArray = [NSMutableArray arrayWithArray:self.tmpPhotosArray];   
            
            
            NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
            [self.photosArray sortUsingDescriptors:[NSArray arrayWithObject:dateSort]];
            
            [self performSelector:@selector(setUpPhotoPage)];
            
        }else{
            
            [self.photosArray addObjectsFromArray:self.tmpPhotosArray];    
            
            
            NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
            [self.photosArray sortUsingDescriptors:[NSArray arrayWithObject:dateSort]];
            
            [self performSelector:@selector(setUpPhotoPage)];
            
        }
      
    }else{
        self.photoDisplayLabel.text = @"*Could not get photos at this time.";

    }
    
}


-(void)setUpPhotoPage{
    
    if ([self.photosArray count] > 0) {
        
        for (UIView *view in [self.photoBackView subviews]) {
            
            if (view != refreshHeaderView3) {
                [view removeFromSuperview];

            }
        }
        
        int finalHeight = 0;

        for (int i = 0; i < [self.photosArray count]; i++) {
            

            int x = 0;
            int y = 0;
            int inity = 30;
            int row = 0;
            
            if ((i%2) == 0) {
                //Left Column
                x = 52;
                
                row = (i + 2)/2;
                
            }else{
                //Right Column
                x = 186;
                row = (i + 1)/2;

            }
            
            y = inity + (row-1)*(82 + 30);
     
            UIView *imageBack = [[UIView alloc] initWithFrame:CGRectMake(x, y, 82, 82)];
            imageBack.backgroundColor = [UIColor blackColor];
            
            ImageButton *insideImageView = [ImageButton buttonWithType:UIButtonTypeCustom];
            
            Activity *tmpActivity = [self.photosArray objectAtIndex:i];
            
            NSData *profileData = [Base64 decode:tmpActivity.thumbnail];
            insideImageView.hidden = NO;
            insideImageView.tag = i;
            
            imageBack.hidden = NO;
            imageBack.backgroundColor = [UIColor blackColor];
            
            
            UIImage *tmpImage = [UIImage imageWithData:profileData];
            imageBack.frame = CGRectMake(x, y, 82, 82);
            
            UIImageView *myImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:profileData]];
            
            if (tmpImage.size.height > tmpImage.size.width) {
                
                imageBack.frame = CGRectMake(x+11, y, 60, 82);
            }else{
                imageBack.frame = CGRectMake(x, y+11, 82, 60);
            }
            
            myImage.frame = CGRectMake(1, 1, imageBack.frame.size.width -2, imageBack.frame.size.height - 2);
            
            if (!tmpActivity.isVideo) {
                
                [insideImageView addTarget:self action:@selector(photoSelected:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                UIImageView *playButton = [[UIImageView alloc] initWithFrame:CGRectMake(myImage.frame.size.width/2 - 15, myImage.frame.size.height/2 -15, 30, 30)];
                playButton.image = [UIImage imageNamed:@"playButtonSmall.png"];
                [myImage addSubview:playButton];
                
                [insideImageView addTarget:self action:@selector(photoSelectedVideo:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            [imageBack addSubview:myImage];
            
            imageBack.layer.masksToBounds = YES;
            imageBack.layer.cornerRadius = 4.0;
            myImage.layer.masksToBounds = YES;
            myImage.layer.cornerRadius = 4.0;
            
            insideImageView.frame = CGRectMake(x, y, 82, 82);
            insideImageView.backgroundColor = [UIColor clearColor];
            
            
            [self.photoBackView addSubview:imageBack];
            [self.photoBackView addSubview:insideImageView];
            
            finalHeight = y + 90;
        
        }
                
        if (self.canLoadMorePhotos) {
            self.morePhotosButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.morePhotosButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.morePhotosButton setTitle:@"Load More Photos" forState:UIControlStateNormal];
            self.morePhotosButton.frame = CGRectMake(60, finalHeight + 20, 200, 34);
            self.morePhotosButton.enabled = YES;
            finalHeight = finalHeight + 65;
            [self.photoBackView addSubview:self.morePhotosButton];
            
            [self.morePhotosButton addTarget:self action:@selector(loadMorePhotos) forControlEvents:UIControlEventTouchUpInside];
            
            UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
            UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [self.morePhotosButton setBackgroundImage:stretch forState:UIControlStateNormal];
        }
        
        self.photoBackView.contentSize = CGSizeMake(320, finalHeight);
        
        [self.photoBackView removeFromSuperview];
        [self.view1 addSubview:self.photoBackView];
        [self.view1 bringSubviewToFront:self.photoBackView];
        
    
    }
}

-(void)loadMorePhotos{
    
    self.morePhotosButton.enabled = NO;
    @try {
        int last = [self.photosArray count] - 1;
        Activity *tmpActivitiy = [self.photosArray objectAtIndex:last];
        
        NSString *dateString = [tmpActivitiy.createdDate substringToIndex:10];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"YYYY-MM-dd"];
        NSDate *theDate = [format dateFromString:dateString];
        theDate = [theDate dateByAddingTimeInterval:-86400];
        
        NSString *newDateString = [format stringFromDate:theDate];

        
        [self.photoActivity startAnimating];
        [self performSelectorInBackground:@selector(getActivityPhotos:) withObject:newDateString];

    }
    @catch (NSException *exception) {
        self.morePhotosButton.enabled = YES;
    }
    
   }
- (void)viewDidUnload
{
    myAd = nil;
    myAd.delegate = nil;
    topScrollView = nil;
    bottomScrollView = nil;
    swipeAlert = nil;
    swipeAlertFront = nil;
    [super viewDidUnload];
    
}

-(void)dealloc{
    @try {
        myAd.delegate = nil;
        myAd = nil;
    }
    @catch (NSException *exception) {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        [GoogleAppEngine sendExceptionCaught:exception inMethod:@"NewActivity.m - dealloc()" theRecordedDate:[NSDate date] theRecordedUserName:mainDelegate.token theInstanceUrl:@""];
    }
   
  
}

@end
