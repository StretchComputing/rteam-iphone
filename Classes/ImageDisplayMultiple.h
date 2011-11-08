//
//  ImageDisplayMultiple.h
//  ServiceNow-LiveFeed
//
//  Created by Nick Wroblewski on 10/3/11.
//  Copyright 2011 Fruition Partners. All rights reserved.
//

@interface ImageDisplayMultiple : UIViewController <UIScrollViewDelegate> {

}
@property (nonatomic, strong) NSString *encodedPhoto;
@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) IBOutlet UIScrollView *bigScrollView;
@property (nonatomic, strong) IBOutlet UIImageView *bigImageView;

@property int currentPage;
@property (nonatomic, strong) IBOutlet UIScrollView *myScrollview;
@property bool isPortrait;
@property (nonatomic, strong) IBOutlet UIButton *replyButton;
@property bool isFullScreen;
@property (nonatomic, strong) IBOutlet UITextField *commentText;
@property bool didReply;
@property (nonatomic, strong) NSMutableArray *imageDataArray;


@end



@interface UIDevice (ForceRteamOrien)
- (void) setOrientation:(UIInterfaceOrientation)orientation;
@end
