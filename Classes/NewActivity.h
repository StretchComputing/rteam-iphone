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
    UIActivityIndicatorView *allActivityLoadingIndicator;
    UILabel *allActivityLoadingLabel;
    
    UITableView *myActivityTable;
    UIActivityIndicatorView *myActivityLoadingIndicator;
    UILabel *myActivityLoadingLabel;
    
    
    //Arrays for the tables
    NSMutableArray *tmpActivitiyArray;
    NSMutableArray *activityArray;
    
    
    
    //Try pull down refresh code
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    UIView *refreshHeaderView2;
    UILabel *refreshLabel2;
    UIImageView *refreshArrow2;
    UIActivityIndicatorView *refreshSpinner2;
    NSString *textPull2;
    NSString *textRelease2;
    NSString *textLoading2;
    
    
    BOOL isLoading;
    BOOL isDragging;
    bool shouldCallStop;
    NSString *currentTable; //everyone, me, photos
    
    
    //Misc
    bool newActivityFailed;
    bool hasNewActivity;
    
    //
    bool didInitMyActivity;
    bool didInitPhotos;
}
@property (nonatomic, retain) NSMutableArray *myActivityArray;  //Holds messages sent/received, polls sent/received
@property bool didInitPhotos;
@property bool didInitMyActivity;
@property bool shouldCallStop;
@property BOOL isDragging;
@property (nonatomic, strong) UITableView *myActivityTable;
@property (nonatomic, strong) UIActivityIndicatorView *myActivityLoadingIndicator;
@property (nonatomic, strong) UILabel *myActivityLoadingLabel;

@property (nonatomic, strong) UITableView *photosTable;
@property (nonatomic, strong) UIActivityIndicatorView *photosLoadingIndicator;
@property (nonatomic, strong) UILabel *photosLoadingLabel;

@property (nonatomic, strong) NSString *currentTable;
@property BOOL isLoading;
@property (nonatomic, strong) UIView *refreshHeaderView2;
@property (nonatomic, strong) UILabel *refreshLabel2;
@property (nonatomic, strong) UIImageView *refreshArrow2;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner2;
@property (nonatomic, strong) NSString *textPull2;
@property (nonatomic, strong) NSString *textRelease2;
@property (nonatomic, strong) NSString *textLoading2;

@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshArrow;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, strong) NSString *textPull;
@property (nonatomic, strong) NSString *textRelease;
@property (nonatomic, strong) NSString *textLoading;

@property (nonatomic, strong) UIActivityIndicatorView *allActivityLoadingIndicator;
@property (nonatomic, strong) UILabel *allActivityLoadingLabel;
@property (nonatomic, strong) UIView *view1Top;
@property (nonatomic, strong) UIView *view2Top;
@property (nonatomic, strong) UIView *view3Top;

@property (nonatomic, strong) UITableView *allActivityTable;
@property (nonatomic, strong) NSMutableArray *tmpActivityArray;
@property (nonatomic, strong) NSMutableArray *activityArray;

@property bool  hasNewActivity;
@property bool newActivityFailed;
@property BOOL bannerIsVisible;
@property int currentMiddle;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@property int numberOfPages;
@property int currentPage;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;

- (void)loadScrollViewWithPage:(int)page;
-(void)setUpScrollView;
-(NSString *)formatDateString:(NSString *)dateSent;
- (void)setupStrings;
- (void)addPullToRefreshHeader;
-(void)startLoading;
-(void)refresh;
-(int)findHeightForString:(NSString *)message withWidth:(int)width;

@end
