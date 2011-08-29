//
//  ViewDetailPollReplies.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewDetailPollReplies : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

	NSArray *replyArray;
	NSString *teamId;
	NSArray *allReplyObjects;
	
	bool finalized;
	bool isSender;
	
	IBOutlet UITableView *myTableView;
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	
	NSArray *members;
}
@property (nonatomic, retain) NSArray *members;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;

@property bool isSender;
@property (nonatomic, retain) NSArray *replyArray;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSArray *allReplyObjects;
@property bool finalized;
@end
