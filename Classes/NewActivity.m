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

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation NewActivity
@synthesize topScrollView, bottomScrollView, viewControllers, numberOfPages, currentPage, view1, view2, view3, currentMiddle, bannerIsVisible,
tmpActivityArray, newActivityFailed, hasNewActivity, activityArray, allActivityTable, view1Top, view2Top, view3Top, allActivityLoadingLabel, allActivityLoadingIndicator, refreshArrow, refreshLabel, refreshSpinner, textPull, textLoading, textRelease, refreshHeaderView, refreshArrow2, refreshLabel2, refreshSpinner2, refreshHeaderView2, textPull2, textLoading2, textRelease2, isLoading, currentTable, myActivityTable, myActivityLoadingLabel, myActivityLoadingIndicator, photosTable, photosLoadingLabel, photosLoadingIndicator, isDragging, shouldCallStop, didInitPhotos, didInitMyActivity, myActivityArray, myAd, fromPost;


-(void)home{
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}

-(void)compose{
    
    ActivityPost *tmp = [[ActivityPost alloc] init];
	tmp.fromClass = self;
	UINavigationController *navController = [[UINavigationController alloc] init];
	
	[navController pushViewController:tmp animated:NO];
	
	[self.navigationController presentModalViewController:navController animated:YES];	
    
    
}
	

-(void)viewWillAppear:(BOOL)animated{
    
    
    if (self.fromPost) {
        self.fromPost = false;
        [self performSelectorInBackground:@selector(getNewActivity) withObject:nil];
        [self performSelectorInBackground:@selector(getMyActivity) withObject:nil];
    }
    
    
    if (myAd.bannerLoaded) {
        myAd.hidden = NO;
    }else{
        myAd.hidden = YES;
    }
    
}
    
    
- (void)viewDidLoad
{
    
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
    
    PhotosActivity *tmp = [[PhotosActivity alloc] init];
    [self.view1 addSubview:tmp.view];
    
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
    
    [self performSelectorInBackground:@selector(getNewActivity) withObject:nil];
    
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
    
    
    //iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 366, 320, 50)];
	//myAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
    
    self.topScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topScrollBack2.png"]];
    
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

    if (currentMiddle == 1) {
        //Photos
        if (!self.didInitPhotos) {
            self.didInitPhotos = false;
            //[self performSelectorInBackground:@selector(getMyActivity) withObject:nil];
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
        
    }else if (currentMiddle == 2){
        //Everyone
        
        
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
            
            
        }        
    }

        
}




- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	if (tableView == self.allActivityTable) {
        
        return [self.activityArray count];
	
	}else if (true) {
		
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

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	NSUInteger row = [indexPath row];
    
    if (tableView == self.allActivityTable) {
        
        if ([[self.activityArray objectAtIndex:row] class] == [Activity class]) {
            
            Activity *tmpActivity = [self.activityArray objectAtIndex:row];
			

                
                NewActivityDetail *theMessage = [[NewActivityDetail alloc] init];
                
                theMessage.displayName = @"NicK Wroblewski";
                theMessage.displayTime = [TableDisplayUtil getDateLabel:tmpActivity.createdDate]; 
                theMessage.displayMessage = tmpActivity.activityText;
                theMessage.messageId = tmpActivity.activityId;
                theMessage.teamId = tmpActivity.teamId;
                theMessage.numLikes = tmpActivity.numLikes;
                theMessage.numDislikes = tmpActivity.numDislikes;
                
                theMessage.currentVote = tmpActivity.vote;
            theMessage.isVideo = tmpActivity.isVideo;
                //theMessage.likes = [NSArray arrayWithArray:messageSelected.likedBy];
                //theMessage.replies = [NSArray arrayWithArray:messageSelected.replies];
                //theMessage.tags = [NSArray arrayWithArray:messageSelected.tags];
                //theMessage.profile = messageSelected.profile;
                
                if ([tmpActivity.thumbnail length] > 0) {
                    theMessage.postImageArray = [NSMutableArray arrayWithObject:[Base64 decode:tmpActivity.thumbnail]];
                }else{
                    theMessage.postImageArray = [NSMutableArray array];
                }
          
                
                //Profile Image
                theMessage.picImageData = [NSData data];
                
         
                [self.navigationController pushViewController:theMessage animated:YES];
                

    
            
        }else{
            //Polls
            
        }
        
    }else{
        //my
        
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
				
				
				
				[self.navigationController pushViewController:poll animated:YES];
			}else {
				
                
                
                ViewMessageReceived *message = [[ViewMessageReceived alloc] init];
				
                
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
                        
            if ([message.messageType isEqualToString:@"poll"]) {
                                
                ViewPollSent *tmp = [[ViewPollSent alloc] init];
                
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
		self.bannerIsVisible = YES;
		myAd.hidden = NO;
		
        [self.view bringSubviewToFront:myAd];
        
	}
}


- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
	    
	if (self.bannerIsVisible) {
		
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
        
    }
}

//Scroll down to refresh method
- (void)refresh {
    // Don't forget to call stopLoading at the end.
    self.shouldCallStop = true;
    
    if ([self.currentTable isEqualToString:@"everyone"]) {
        
        [self performSelectorInBackground:@selector(getNewActivity) withObject:nil];
        
    }else if ([self.currentTable isEqualToString:@"me"]){
        
        [self performSelectorInBackground:@selector(getMyActivity) withObject:nil];
        
    }else if ([self.currentTable isEqualToString:@"photos"]){
        
        
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
            
            
            NSDictionary *response = [ServerAPI getActivity:token :@"25" :@"true" :@"" :dateString :@"20"];
            
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
        [self performSelectorOnMainThread:@selector(doneNewActivity) withObject:nil waitUntilDone:NO];

    }
	
}

-(void)doneNewActivity{
    
    if (self.shouldCallStop) {
        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0];
    }
    
	if (!self.newActivityFailed) {
		self.hasNewActivity = true;
	}
	self.activityArray = [NSMutableArray arrayWithArray:self.tmpActivityArray];
    
    self.allActivityTable.hidden = NO;
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
}


-(void)getPhotos{

    
    [self performSelectorOnMainThread:@selector(donePhotos) withObject:nil waitUntilDone:NO];
}
-(void)donePhotos{
    
}

- (void)viewDidUnload
{
    topScrollView = nil;
    bottomScrollView = nil;
    [super viewDidUnload];

}


    
    

    
   

//Finds the height of a string constrained by the input width
-(int)findHeightForString:(NSString *)message withWidth:(int)width{
    
    CGSize constraints = CGSizeMake(width, 900);
    CGSize totalSize = [message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraints];
    
    return totalSize.height;
    
}


//For clicking on an image inside the message (company feed)
-(void)imageSelected:(id)sender{
    
    NSLog(@"Image Selected");
    
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
    
    ImageDisplayMultiple *newDisplay = [[ImageDisplayMultiple alloc] init];
    newDisplay.activityId = messageId;
    newDisplay.teamId = teamId;
    [self.navigationController pushViewController:newDisplay animated:YES];    
    
}


-(void)videoSelected:(id)sender{
        
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
    
    VideoDisplay *newDisplay = [[VideoDisplay alloc] init];
    newDisplay.activityId = messageId;
    newDisplay.teamId = teamId;
    
    UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = temp;
    
    [self.navigationController pushViewController:newDisplay animated:NO];    
    
}


@end
