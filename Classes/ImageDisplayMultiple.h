//
//  ImageDisplayMultiple.h
//  ServiceNow-LiveFeed
//
//  Created by Nick Wroblewski on 10/3/11.
//  Copyright 2011 Fruition Partners. All rights reserved.
//

@interface ImageDisplayMultiple : UIViewController <UIScrollViewDelegate> {
    
    NSMutableArray *imageDataArray;
    IBOutlet UITextField *commentText;
    IBOutlet UIButton *replyButton;
    
    bool didReply;
    bool isFullScreen;
    bool isPortrait;
    
    
    IBOutlet UIScrollView *myScrollview;
    
    
    int currentPage;
    
    IBOutlet UIScrollView *bigScrollView;
    IBOutlet UIImageView *bigImageView;
    
    
}
@property (nonatomic, retain) NSString *encodedPhoto;
@property (nonatomic, retain) NSString *activityId;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UIScrollView *bigScrollView;
@property (nonatomic, retain) UIImageView *bigImageView;

@property int currentPage;
@property (nonatomic, retain) UIScrollView *myScrollview;
@property bool isPortrait;
@property (nonatomic, retain) UIButton *replyButton;
@property bool isFullScreen;
@property (nonatomic, retain) UITextField *commentText;
@property bool didReply;
@property (nonatomic, retain) NSMutableArray *imageDataArray;

@end
