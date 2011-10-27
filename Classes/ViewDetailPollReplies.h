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
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;

@property bool isSender;
@property (nonatomic, strong) NSArray *replyArray;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSArray *allReplyObjects;
@property bool finalized;
@end
