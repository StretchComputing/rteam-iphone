//
//  VideoDisplay.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoDisplay : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property bool isPlayingMovie;
@property (nonatomic, retain) NSString *movieString;
@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSData *movieData;
@property (nonatomic, strong) NSString *basePath;
@property (nonatomic, strong) NSString *errorString;
@end
