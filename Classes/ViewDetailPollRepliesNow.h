//
//  ViewDetailPollRepliesNow.h
//  rTeam
//
//  Created by Nick Wroblewski on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewDetailPollRepliesNow : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
    
}
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivity;

@property bool isSender;
@property (nonatomic, strong) NSArray *replyArray;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSArray *allReplyObjects;
@property bool finalized;
@end
