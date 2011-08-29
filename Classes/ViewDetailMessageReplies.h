//
//  ViewDetailMessageReplies.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewDetailMessageReplies : UIViewController <UITableViewDelegate, UIActionSheetDelegate, UITableViewDataSource> {
	
	NSArray *replyArray;
	NSString *teamId;
	NSArray *allReplyObjects;
	
	bool finalized;
	bool getInfo;
	NSString *threadId;
	
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
@property (nonatomic, retain) NSString *threadId;
@property bool getInfo;
@property (nonatomic, retain) NSArray *replyArray;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSArray *allReplyObjects;
@property bool finalized;
@end
