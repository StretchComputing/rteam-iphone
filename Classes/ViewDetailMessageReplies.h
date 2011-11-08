//
//  ViewDetailMessageReplies.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewDetailMessageReplies : UIViewController <UITableViewDelegate, UIActionSheetDelegate, UITableViewDataSource> {
	
	}
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivity;

@property bool isSender;
@property (nonatomic, strong) NSString *threadId;
@property bool getInfo;
@property (nonatomic, strong) NSArray *replyArray;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSArray *allReplyObjects;
@property bool finalized;
@end
