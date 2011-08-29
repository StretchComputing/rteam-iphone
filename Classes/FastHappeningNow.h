//
//  FastHappeningNow.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FastHappeningNow : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UIActionSheetDelegate > {
	NSArray *events;
		
	IBOutlet UILabel *error;
	NSString *errorString;
	
		
	UIActivityIndicatorView *eventActivity;
	IBOutlet UILabel *eventActivityLabel;
	IBOutlet UITableView *eventsTableView;
	IBOutlet UIActivityIndicatorView *loadingActivity;
    
    int actionRow;
    
    IBOutlet UIActivityIndicatorView *largeActivity;
	
}
@property (nonatomic, retain) UIActivityIndicatorView *largeActivity;
@property int actionRow;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, retain) UITableView *eventsTableView;
@property (nonatomic, retain) NSString *errorString;

@property (nonatomic, retain) UILabel *eventActivityLabel;
@property (nonatomic, retain) UIActivityIndicatorView *eventActivity;

@property (nonatomic, retain) UILabel *error;
@property (nonatomic, retain) NSArray *events;


-(void)getAllEvents;
@end
