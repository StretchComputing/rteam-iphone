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
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;

@property bool isSender;
@property (nonatomic, strong) NSString *threadId;
@property bool getInfo;
@property (nonatomic, strong) NSArray *replyArray;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSArray *allReplyObjects;
@property bool finalized;
@end
