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

@implementation NewActivity
@synthesize topScrollView, bottomScrollView, viewControllers, numberOfPages, currentPage, view1, view2, view3, currentMiddle, bannerIsVisible,
tmpActivityArray, newActivityFailed, hasNewActivity, activityArray, allActivityTable, view1Top, view2Top, view3Top;


-(void)home{
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}

-(void)compose{
    
    
}
	
    
    
- (void)viewDidLoad
{
    [self performSelectorInBackground:@selector(getNewActivity) withObject:nil];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setRightBarButtonItem:addButton];
	[addButton release];
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose)];
	[self.navigationItem setLeftBarButtonItem:composeButton];
	[composeButton release];
    
    self.numberOfPages = 3;
    [self setUpScrollView];

    
    int y = self.bottomScrollView.frame.size.height;
    
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, y)];
    self.view1.backgroundColor = [UIColor blackColor];
    [self.bottomScrollView addSubview:self.view1];
    
    self.view2 = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, y)];
    self.view2.backgroundColor = [UIColor redColor];
    [self.bottomScrollView addSubview:self.view2];
    
    self.view3 = [[UIView alloc] initWithFrame:CGRectMake(640, 0, 320, y)];
    self.view3.backgroundColor = [UIColor yellowColor];
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
    centerLabel.text = @"Everything";
    leftLabel.text = @"Photos";
    rightLabel.text = @"Outgoing";
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
    centerLabel1.text = @"Outgoing";
    leftLabel1.text = @"Everything";
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
    leftLabel2.text = @"Outgoing";
    rightLabel2.text = @"Everything";
    [self.view1Top addSubview:centerLabel2];
    [self.view1Top addSubview:rightLabel2];
    [self.view1Top addSubview:leftLabel2];
    
    
    //*******Done labels for top
    
    
   
    
    
    
    
    
    self.title = @"Activity";
    
    //iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 366, 320, 50)];
	//myAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
    
    
    self.allActivityTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view2.frame.size.width, self.view2.frame.size.height) style:UITableViewStylePlain];
    self.allActivityTable.dataSource = self;
    self.allActivityTable.delegate = self;
    [self.view2 addSubview:self.allActivityTable];
    [self.view2 bringSubviewToFront:self.allActivityTable];
  
    
    self.tmpActivityArray = [NSMutableArray array];
    self.activityArray = [NSMutableArray array];
    
    [super viewDidLoad];
}


-(void)setUpScrollView{
	
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < self.numberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
	
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
        [controller release];
    }
        
    self.currentPage = 1;
    self.currentMiddle = 2;
    //[self loadScrollViewWithPage:1];

    CGPoint tmpPoint = CGPointMake(320, 0);
    [self.bottomScrollView setContentOffset:tmpPoint animated:NO];
	
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //[self loadScrollViewWithPage:1];
    //[self loadScrollViewWithPage:2];

}


- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= self.numberOfPages) return;

    [self.view1 removeFromSuperview];
    [self.view2 removeFromSuperview];
    [self.view3 removeFromSuperview];
   
    int y = self.bottomScrollView.frame.size.height;

    if (currentMiddle == 1) {
        
        self.view1.frame = CGRectMake(320, 0, 320, y);
        [self.bottomScrollView addSubview:self.view1];
        
        self.view2.frame = CGRectMake(640, 0, 320, y);
        self.view2.backgroundColor = [UIColor redColor];
        [self.bottomScrollView addSubview:self.view2];
        
        self.view3.frame = CGRectMake(0, 0, 320, y);
        self.view3.backgroundColor = [UIColor yellowColor];
        [self.bottomScrollView addSubview:self.view3];
        
    }else if (currentMiddle == 2){
        
        self.view1.frame = CGRectMake(0, 0, 320, y);
        self.view1.backgroundColor = [UIColor blackColor];
        [self.bottomScrollView addSubview:self.view1];
        
        self.view2.frame = CGRectMake(320, 0, 320, y);
        self.view2.backgroundColor = [UIColor redColor];
        [self.bottomScrollView addSubview:self.view2];
        
        self.view3.frame = CGRectMake(640, 0, 320, y);
        self.view3.backgroundColor = [UIColor yellowColor];
        [self.bottomScrollView addSubview:self.view3];
    }else{
        
        self.view1.frame = CGRectMake(640, 0, 320, y);
        self.view1.backgroundColor = [UIColor blackColor];
        [self.bottomScrollView addSubview:self.view1];
        
        self.view2.frame = CGRectMake(0, 0, 320, y);
        self.view2.backgroundColor = [UIColor redColor];
        [self.bottomScrollView addSubview:self.view2];
        
        self.view3.frame = CGRectMake(320, 0, 320, y);
        self.view3.backgroundColor = [UIColor yellowColor];
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
        
        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
        // [self loadScrollViewWithPage:page - 1];
        //[self loadScrollViewWithPage:page];
        //[self loadScrollViewWithPage:page + 1];
        
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

    }

        
}


-(void)getNewActivity{
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	
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
        
		
		NSDictionary *response = [ServerAPI getActivity:token :@"" :@"true" :@"" :dateString :@"20"];
		
		[format release];
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
	[pool drain];
}

-(void)doneNewActivity{
    
	if (!self.newActivityFailed) {
		self.hasNewActivity = true;
	}
	self.activityArray = [NSMutableArray arrayWithArray:self.tmpActivityArray];
    
	//self.isUpdating = false;
	//[self.updatingActivity stopAnimating];
	//[self.postActivity stopAnimating];
    
	[self.allActivityTable reloadData];
	
	//[self performSelectorInBackground:@selector(getUserVotes) withObject:nil];
	
	
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	if (tableView == self.allActivityTable) {
        
        return [self.activityArray count];
	
	}else if (true) {
		return 1;
	}else {
        //Post Team
		return 1;
	}
    
    	
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	if (tableView == self.allActivityTable) {
		
		NSInteger row = [indexPath row];
		
		Activity *tmp = [self.activityArray objectAtIndex:row];
		bool isPic = false;
		bool isVid = false;
		
		if ((tmp.thumbnail == nil)  || ([tmp.thumbnail isEqualToString:@""])){
			isPic = false;
		}else {
			isPic = true;
		}
		
		if (tmp.isVideo) {
			isVid = true;
		}
		
		NSString *tmpString1 = [NSString stringWithFormat:@"%@", tmp.activityText];
        
		static NSString *FirstLevelCell=@"FirstLevelCell";
		static NSString *FirstLevelCellPic=@"FirstLevelCellPic";
        
		static NSString *SecondLevelCell=@"SecondLevelCell";
		static NSString *SecondLevelCellPic=@"SecondLevelCellPic";
        
		static NSString *ThirdLevelCell=@"ThirdLevelCell";
		static NSString *ThirdLevelCellPic=@"ThirdLevelCellPic";
        
		static NSString *FourthLevelCell=@"FourthLevelCell";
		static NSString *FourthLevelCellPic=@"FourthLevelCellPic";
        
        
		
		
		
        static NSInteger textTag = 1;
        static NSInteger dateTag = 2;
        static NSInteger teamTag = 3;
		
		static NSInteger thumbsUpTag = 4;
		static NSInteger thumbsDownTag = 5;
		static NSInteger starOneTag = 6;
		static NSInteger starTwoTag = 7;
		static NSInteger starThreeTag = 8;
		static NSInteger postPicTag = 9;
		static NSInteger playButtonTag = 10;
        
        
		UITableViewCell *cell;
		
		if ([tmpString1 length] < 40) {
			
			if (isPic) {
				cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCellPic];
			}else {
				cell =  [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
                
			}
            
            
		}else if ([tmpString1 length] < 80) {
			
			if (isPic) {
				cell = [tableView dequeueReusableCellWithIdentifier:SecondLevelCellPic];
			}else {
				cell =  [tableView dequeueReusableCellWithIdentifier:SecondLevelCell];
				
			}
            
		}else if ([tmpString1 length] < 140) {
			
			if (isPic) {
				cell = [tableView dequeueReusableCellWithIdentifier:ThirdLevelCellPic];
			}else {
				cell =  [tableView dequeueReusableCellWithIdentifier:ThirdLevelCell];
				
			}
            
			
		}else {
			
			if (isPic) {
				cell = [tableView dequeueReusableCellWithIdentifier:FourthLevelCellPic];
			}else {
				cell =  [tableView dequeueReusableCellWithIdentifier:FourthLevelCell];
				
			}
            
		}
        
        
        if (cell == nil){
            
            if ([tmpString1 length] < 40) {
                
                if (isPic) {
                    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FirstLevelCellPic] autorelease];
                    
                }else {
                    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FirstLevelCell] autorelease];
                    
                }
                
                
            }else if ([tmpString1 length] < 80) {
                
                if (isPic) {
                    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SecondLevelCellPic] autorelease];
                    
                }else {
                    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SecondLevelCell] autorelease];
                    
                }
                
            }else if ([tmpString1 length] < 140) {
                
                if (isPic) {
                    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:ThirdLevelCellPic] autorelease];
                    
                }else {
                    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:ThirdLevelCell] autorelease];
                    
                }
                
                
            }else {
                
                if (isPic) {
                    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FourthLevelCellPic] autorelease];
                    
                }else {
                    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FourthLevelCell] autorelease];
                    
                }
                
            }
            
            
            CGRect frame;
            frame.origin.x = 5;
            frame.origin.y = 5;
            frame.size.height = 80;
            frame.size.width = 300;
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
            textLabel.tag = textTag;
            [cell.contentView addSubview:textLabel];
            [textLabel release];
            
            frame.origin.y = 83;
            frame.size.height = 14;
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
            dateLabel.tag = dateTag;
            [cell.contentView addSubview:dateLabel];
            [dateLabel release];
            
            UILabel *teamCellLabel = [[UILabel alloc] initWithFrame:frame];
            teamCellLabel.tag = teamTag;
            [cell.contentView addSubview:teamCellLabel];
            [teamCellLabel release];
            
            
            
            
            
            CGRect test1 = CGRectMake(0, 0, 25, 25);
            UIImageView *starOne = [[UIImageView alloc] initWithFrame:test1];
            starOne.tag = starOneTag;
            [starOne setImage:[UIImage imageNamed:@"fullStar.png"]];
            starOne.opaque = YES; // explicitly opaque for performance
            [cell.contentView addSubview:starOne];
            [starOne release];
            
            UIImageView *starTwo = [[UIImageView alloc] initWithFrame:test1];
            starTwo.tag = starTwoTag;
            [starTwo setImage:[UIImage imageNamed:@"fullStar.png"]];
            starTwo.opaque = YES; // explicitly opaque for performance
            [cell.contentView addSubview:starTwo];
            [starTwo release];
            
            UIImageView *starThree = [[UIImageView alloc] initWithFrame:test1];
            starThree.tag = starThreeTag;
            [starThree setImage:[UIImage imageNamed:@"fullStar.png"]];
            starThree.opaque = YES; // explicitly opaque for performance
            [cell.contentView addSubview:starThree];
            [starThree release];
            
            CGRect frame1 = CGRectMake(100, 83, 60, 80);
            UIImageView *postPic = [[UIImageView alloc] initWithFrame:frame1];
            postPic.tag = postPicTag;
            postPic.opaque = YES; // explicitly opaque for performance
            [cell.contentView addSubview:postPic];
            [postPic release];
            
            frame1 = CGRectMake(115, 108, 30, 30);
            UIImageView *playButtonPic = [[UIImageView alloc] initWithFrame:frame1];
            playButtonPic.tag = playButtonTag;
            playButtonPic.image = [UIImage imageNamed:@"playButtonSmall.png"];
            playButtonPic.opaque = YES; // explicitly opaque for performance
            [cell.contentView addSubview:playButtonPic];
            [playButtonPic release];
            
            
        }
		
        
        
        UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:textTag];
        UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
        UILabel *teamCellLabel = (UILabel *)[cell.contentView viewWithTag:teamTag];
		/*
         UIButton *thumbsUp = (UIButton *)[cell.contentView viewWithTag:thumbsUpTag];
         UIButton *thumbsDown = (UIButton *)[cell.contentView viewWithTag:thumbsDownTag];
		 */
		
		UIButton *thumbsUp = [UIButton buttonWithType:UIButtonTypeCustom];
		thumbsUp.tag = thumbsUpTag;
		[thumbsUp setImage:[UIImage imageNamed:@"thumbsUp.png"] forState:UIControlStateNormal];
		[thumbsUp addTarget:self action:@selector(voteUp:) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:thumbsUp];
		
		UIButton *thumbsDown = [UIButton buttonWithType:UIButtonTypeCustom];
		thumbsDown.tag = thumbsDownTag;
		[thumbsDown setImage:[UIImage imageNamed:@"thumbsDown.png"] forState:UIControlStateNormal];
		[thumbsDown addTarget:self action:@selector(voteDown:) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:thumbsDown];
		
		thumbsUp.tag = row;
		thumbsDown.tag = row;
		
		UIImageView *starOne = (UIImageView *)[cell.contentView viewWithTag:starOneTag];
		UIImageView *starTwo = (UIImageView *)[cell.contentView viewWithTag:starTwoTag];
		UIImageView *starThree = (UIImageView *)[cell.contentView viewWithTag:starThreeTag];
		
		UIImageView *postPic = (UIImageView *)[cell.contentView viewWithTag:postPicTag];
        postPic.layer.masksToBounds = YES;
        postPic.layer.cornerRadius = 3.0;
        
		UIImageView *playButton = (UIImageView *)[cell.contentView viewWithTag:playButtonTag];
		
		if (isVid) {
			playButton.hidden = NO;
		}else{
			playButton.hidden = YES;
		}
        
        
		
        textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        dateLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        dateLabel.textColor = [UIColor grayColor];
		
		teamCellLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
		teamCellLabel.textColor = [UIColor blueColor];
		
        
        if (false) {
            
        }else {
            
            textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            textLabel.textColor = [UIColor blackColor];
            textLabel.textAlignment = UITextAlignmentLeft;
            
            [dateLabel setHidden:NO];
            Activity *tmp = [self.activityArray objectAtIndex:row];
            
            
            NSString *tmpThumbnail = tmp.thumbnail;
            
            bool isPortrait = true;
            
            if ((tmpThumbnail == nil)  || ([tmpThumbnail isEqualToString:@""])){
                
                postPic.hidden = YES;
                
            }else {
                isPic = true;
                postPic.hidden = NO;
                NSData *profileData = [Base64 decode:tmpThumbnail];
                [postPic setImage:[UIImage imageWithData:profileData]];
                UIImage *tmpImage = [UIImage imageWithData:profileData];
                
                if (tmpImage.size.height > tmpImage.size.width) {
                    //Portrait
                    isPortrait = true;
                }else{
                    //Landscape
                    isPortrait = false;
                }
            }
            
            
            dateLabel.text = [self formatDateString:tmp.createdDate];
            teamCellLabel.text = tmp.teamName;
            
            NSString *tmpString = [NSString stringWithFormat:@"%@", tmp.activityText];
            
            //float numStars = [self getNumberOfStars:tmp.numLikes :tmp.numDislikes];
            float numStars = 2;
            
            if ([tmp.vote isEqualToString:@"like"]) {
                
                [thumbsUp setImage:[UIImage imageNamed:@"thumbsUpGreen.png"] forState:UIControlStateNormal];
                [thumbsDown setImage:[UIImage imageNamed:@"thumbsDown.png"] forState:UIControlStateNormal];
                
            }else if ([tmp.vote isEqualToString:@"dislike"]) {
                
                [thumbsUp setImage:[UIImage imageNamed:@"thumbsUp.png"] forState:UIControlStateNormal];
                [thumbsDown setImage:[UIImage imageNamed:@"thumbsDownGreen.png"] forState:UIControlStateNormal];
                
            }else {
                
                [thumbsUp setImage:[UIImage imageNamed:@"thumbsUp.png"] forState:UIControlStateNormal];
                [thumbsDown setImage:[UIImage imageNamed:@"thumbsDown.png"] forState:UIControlStateNormal];
                
            }
            
            if (numStars == 0.0) {
                //
                
                starOne.image = [UIImage imageNamed:@"emptyStar.png"];
                starTwo.image = [UIImage imageNamed:@"emptyStar.png"];
                starThree.image = [UIImage imageNamed:@"emptyStar.png"];
                
            }else if (numStars == 0.5) {
                
                starOne.image = [UIImage imageNamed:@"halfStar.png"];
                starTwo.image = [UIImage imageNamed:@"emptyStar.png"];;
                starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
                
            }else if (numStars == 1.0) {
                
                starOne.image = [UIImage imageNamed:@"fullStar.png"];
                starTwo.image = [UIImage imageNamed:@"emptyStar.png"];;
                starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
                
                
            }else if (numStars == 1.5) {
                
                starOne.image = [UIImage imageNamed:@"fullStar.png"];
                starTwo.image = [UIImage imageNamed:@"halfStar.png"];
                starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
                
            }else if (numStars == 2.0) {
                
                starOne.image = [UIImage imageNamed:@"fullStar.png"];
                starTwo.image = [UIImage imageNamed:@"fullStar.png"];
                starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
                
                
            }else if (numStars == 2.5) {
                
                starOne.image = [UIImage imageNamed:@"fullStar.png"];
                starTwo.image = [UIImage imageNamed:@"fullStar.png"];
                starThree.image = [UIImage imageNamed:@"halfStar.png"];
                
                
            }else if (numStars == 3.0) {
                
                starOne.image = [UIImage imageNamed:@"fullStar.png"];
                starTwo.image = [UIImage imageNamed:@"fullStar.png"];
                starThree.image = [UIImage imageNamed:@"fullStar.png"];
                
                
            }
            
            
            
            
            teamCellLabel.backgroundColor = [UIColor clearColor];
            
            if ([tmpString length] < 40) {
                textLabel.numberOfLines = 1;
                textLabel.frame = CGRectMake(5, 5, 300, 15);
                dateLabel.frame = CGRectMake(5, 21, 100, 14);
                
                if (isVid || isPic){
                    teamCellLabel.frame = CGRectMake(5, 35, 80, 45);
                }else{
                    teamCellLabel.frame = CGRectMake(5, 38, 175, 15);
                }
                
                if (isPic) {
                    thumbsUp.frame = CGRectMake(275, 53, 34, 34);
                    thumbsDown.frame = CGRectMake(241, 53, 34, 34);
                    
                    starOne.frame = CGRectMake(180, 69, 15, 14);
                    starTwo.frame = CGRectMake(200, 69, 15, 14);
                    starThree.frame = CGRectMake(220, 69, 15, 14);
                    
                    if (isPortrait){
                        postPic.frame = CGRectMake(96, 30, 60, 80);
                        playButton.frame = CGRectMake(111, 55, 30, 30);
                        
                    }else{
                        postPic.frame = CGRectMake(86, 50, 80, 60);
                        playButton.frame = CGRectMake(111, 65, 30, 30);
                        
                        
                    }
                    
                }else {
                    
                    thumbsUp.frame = CGRectMake(275, 23, 34, 34);
                    thumbsDown.frame = CGRectMake(241, 23, 34, 34);
                    
                    starOne.frame = CGRectMake(180, 39, 15, 14);
                    starTwo.frame = CGRectMake(200, 39, 15, 14);
                    starThree.frame = CGRectMake(220, 39, 15, 14);
                    
                }
                
                
                
                
            }else if ([tmpString length] < 80) {
                textLabel.numberOfLines = 2;
                textLabel.frame = CGRectMake(5, 5, 300, 36);
                dateLabel.frame = CGRectMake(5, 42, 100, 14);
                
                if (isVid || isPic){
                    teamCellLabel.frame = CGRectMake(5, 56, 80, 45);
                }else{
                    teamCellLabel.frame = CGRectMake(5, 59, 175, 15);
                }
                
                
                if (isPic) {
                    thumbsUp.frame = CGRectMake(275, 74, 34, 34);
                    thumbsDown.frame = CGRectMake(241, 74, 34, 34);
                    
                    starOne.frame = CGRectMake(180, 90, 15, 14);
                    starTwo.frame = CGRectMake(200, 90, 15, 14);
                    starThree.frame = CGRectMake(220, 90, 15, 14);
                    
                    if (isPortrait){
                        postPic.frame = CGRectMake(96, 51, 60, 80);
                        
                        playButton.frame = CGRectMake(111, 76, 30, 30);
                        
                    }else{
                        //postPic.frame = CGRectMake(106, 86, 60, 45);
                        postPic.frame = CGRectMake(86, 71, 80, 60);
                        playButton.frame = CGRectMake(111, 86, 30, 30);
                        
                        
                    }
                    
                    
                }else {
                    
                    thumbsUp.frame = CGRectMake(275, 46, 34, 34);
                    thumbsDown.frame = CGRectMake(241, 46, 34, 34);
                    
                    starOne.frame = CGRectMake(180, 62, 15, 14);
                    starTwo.frame = CGRectMake(200, 62, 15, 14);
                    starThree.frame = CGRectMake(220, 62, 15, 14);
                    
                }
                
                
            }else if ([tmpString length] < 140) {
                textLabel.numberOfLines = 3;
                textLabel.frame = CGRectMake(5, 5, 300, 50);
                dateLabel.frame = CGRectMake(5, 59, 100, 14);
                
                if (isVid || isPic){
                    teamCellLabel.frame = CGRectMake(5, 73, 80, 45);
                }else{
                    teamCellLabel.frame = CGRectMake(5, 76, 175, 15);
                }
                
                
                if (isPic) {
                    thumbsUp.frame = CGRectMake(275, 91, 34, 34);
                    thumbsDown.frame = CGRectMake(241, 91, 34, 34);
                    
                    starOne.frame = CGRectMake(180, 107, 15, 14);
                    starTwo.frame = CGRectMake(200, 107, 15, 14);
                    starThree.frame = CGRectMake(220, 107, 15, 14);
                    
                    if (isPortrait){
                        postPic.frame = CGRectMake(96, 68, 60, 80);
                        playButton.frame = CGRectMake(11, 93, 30, 30);
                        
                    }else{
                        // postPic.frame = CGRectMake(106, 103, 60, 45);
                        postPic.frame = CGRectMake(86, 88, 80, 60);
                        playButton.frame = CGRectMake(111, 103, 30, 30);
                        
                        
                    }
                    
                    
                }else {
                    
                    thumbsUp.frame = CGRectMake(275, 57, 34, 34);
                    thumbsDown.frame = CGRectMake(241, 57, 34, 34);
                    
                    starOne.frame = CGRectMake(180, 73, 15, 14);
                    starTwo.frame = CGRectMake(200, 73, 15, 14);
                    starThree.frame = CGRectMake(220, 73, 15, 14);
                    
                }
                
            }else {
                textLabel.numberOfLines = 4;
                textLabel.frame = CGRectMake(5, 5, 300, 68);
                dateLabel.frame = CGRectMake(5, 78, 100, 14);
                
                if (isVid || isPic){
                    teamCellLabel.frame = CGRectMake(5, 92, 80, 45);
                }else{
                    teamCellLabel.frame = CGRectMake(5, 95, 175, 15);
                }
                
                
                if (isPic) {
                    thumbsUp.frame = CGRectMake(275, 110, 34, 34);
                    thumbsDown.frame = CGRectMake(241, 110, 34, 34);
                    
                    starOne.frame = CGRectMake(180, 126, 15, 14);
                    starTwo.frame = CGRectMake(200, 126, 15, 14);
                    starThree.frame = CGRectMake(220, 126, 15, 14);
                    
                    if (isPortrait){
                        postPic.frame = CGRectMake(96, 87, 60, 80);
                        playButton.frame = CGRectMake(111, 112, 30, 30);
                        
                    }else{
                        postPic.frame = CGRectMake(86, 107, 80, 60);
                        playButton.frame = CGRectMake(111, 122, 30, 30);
                        
                    }
                    
                    
                }else {
                    
                    thumbsUp.frame = CGRectMake(275, 81, 34, 34);
                    thumbsDown.frame = CGRectMake(241, 81, 34, 34);
                    
                    starOne.frame = CGRectMake(180, 97, 15, 14);
                    starTwo.frame = CGRectMake(200, 97, 15, 14);
                    starThree.frame = CGRectMake(220, 97, 15, 14);
                    
                }
                
                
            }
            
            if (isVid || isPic){
                teamCellLabel.numberOfLines = 3;
                teamCellLabel.lineBreakMode = UILineBreakModeWordWrap;
            }else{
                
                teamCellLabel.numberOfLines = 1;
                teamCellLabel.lineBreakMode = UILineBreakModeTailTruncation;
            }
            
            textLabel.text = tmp.activityText;
            
        }
		
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
	}else if (true) { //next table
        
				
	}else { //last table
		
		        
		
	}
    
}


//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (tableView == self.allActivityTable) {
		
		NSInteger row = [indexPath row];
        
		Activity *tmp = [self.activityArray objectAtIndex:row];
        
        
		NSString *tmpString = [NSString stringWithFormat:@"%@", tmp.activityText];
        
		if ([tmpString length] < 40) {
			if ([tmp.thumbnail isEqualToString:@""]) {
				return 57;
			}else {
				return 115;
			}
		}else if ([tmpString length] < 80) {
			if ([tmp.thumbnail isEqualToString:@""]) {
				return 80;
			}else {
				return 138;
			}
		}else if ([tmpString length] < 140) {
			if ([tmp.thumbnail isEqualToString:@""]) {
				return 91;
			}else {
				return 149;
			}
		}else {
			if ([tmp.thumbnail isEqualToString:@""]) {
				return 115;
			}else {
				return 173;
			}
		}
	}else {
		return 40;
	}
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    /*
	NSUInteger row = [indexPath row];
	
	if (tableView == self.allActivityTable) {
		
		if (self.canLoadMore && (row == [self.tweetsArray count])) {
            
			[self.loadMoreActivity startAnimating];
			[self performSelectorInBackground:@selector(loadMoreMethod) withObject:nil];
            
		}else {
			
			self.fromCamera = false;
			
			Activity *tmpActivity = [self.tweetsArray objectAtIndex:row];
			
			if (tmpActivity.isVideo) {
				ActivityDetailVideo *next = [[ActivityDetailVideo alloc] init];
				next.stringText = tmpActivity.activityText;
				next.dateText = [self formatDateString:tmpActivity.createdDate];
				
				
				next.numStars = [self getNumberOfStars:tmpActivity.numLikes :tmpActivity.numDislikes];
				
				next.currentVote = tmpActivity.vote;
				next.activityId = tmpActivity.activityId;
				next.teamId = tmpActivity.teamId;
				next.likes = tmpActivity.numLikes;
				next.dislikes = tmpActivity.numDislikes;
				
				[self.navigationController pushViewController:next animated:YES];
				
			}else {
				ActivityDetail *next = [[ActivityDetail alloc] init];
				next.stringText = tmpActivity.activityText;
				next.dateText = [self formatDateString:tmpActivity.createdDate];
				
				if (![tmpActivity.thumbnail isEqualToString:@""]) {
					next.isImage = true;
				}else {
					next.isImage = false;
				}
				
				next.numStars = [self getNumberOfStars:tmpActivity.numLikes :tmpActivity.numDislikes];
				
				next.currentVote = tmpActivity.vote;
				next.activityId = tmpActivity.activityId;
				next.teamId = tmpActivity.teamId;
				next.likes = tmpActivity.numLikes;
				next.dislikes = tmpActivity.numDislikes;
				
				[self.navigationController pushViewController:next animated:YES];
				
			}
        }
        
		
	}else if (tableView == self.connectTwitterTable) {
		
		
	}else {
		
		        
	}
    
    */
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
	
	[dateFormat release];
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
		
		//myAd.hidden = YES;
		self.bannerIsVisible = NO;
		
		
        
		
		
	}
	
	
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
		[actionSheet release];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
    [FastActionSheet doAction:self :buttonIndex];

	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}


- (void)viewDidUnload
{
    topScrollView = nil;
    bottomScrollView = nil;
    [super viewDidUnload];

}

- (void)dealloc
{
    [viewControllers release];
    [topScrollView release];
    [bottomScrollView release];
    [view1 release];
    [view2 release];
    [view3 release];
    [tmpActivityArray release];
    [activityArray release];
    [allActivityTable release];
    [view1Top release];
    [view2Top release];
    [view3Top release];
    [super dealloc];
}


@end
