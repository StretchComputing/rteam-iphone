//
//  NewActivity.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface NewActivity : UIViewController <UIScrollViewDelegate, ADBannerViewDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UIScrollView *topScrollView;
    IBOutlet UIScrollView *bottomScrollView;
    
    int numberOfPages;
    int currentPage;
    
    NSMutableArray *viewControllers;
    
    UIView *view1;
    UIView *view2;
    UIView *view3;
    
    UIView *view1Top;
    UIView *view2Top;
    UIView *view3Top;
    
    int currentMiddle;
    
    ADBannerView *myAd;
    BOOL bannerIsVisible;
    
    //3 tables (one in each view) Everything, Sent, Photos
    UITableView *allActivityTable;
    
    //Arrays for the tables
    NSMutableArray *tmpActivitiyArray;
    NSMutableArray *activityArray;

    
    //Misc
    bool newActivityFailed;
    bool hasNewActivity;
}
@property (nonatomic, retain) UIView *view1Top;
@property (nonatomic, retain) UIView *view2Top;
@property (nonatomic, retain) UIView *view3Top;

@property (nonatomic, retain) UITableView *allActivityTable;
@property (nonatomic, retain) NSMutableArray *tmpActivityArray;
@property (nonatomic, retain) NSMutableArray *activityArray;

@property bool  hasNewActivity;
@property bool newActivityFailed;
@property BOOL bannerIsVisible;
@property int currentMiddle;
@property (nonatomic, retain) UIView *view1;
@property (nonatomic, retain) UIView *view2;
@property (nonatomic, retain) UIView *view3;
@property (nonatomic, retain) NSMutableArray *viewControllers;

@property int numberOfPages;
@property int currentPage;
@property (nonatomic, retain) UIScrollView *topScrollView;
@property (nonatomic, retain) UIScrollView *bottomScrollView;

- (void)loadScrollViewWithPage:(int)page;
-(void)setUpScrollView;
-(NSString *)formatDateString:(NSString *)dateSent;

@end
