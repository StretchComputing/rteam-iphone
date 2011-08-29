//
//  HomeScoreView.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeScoreView : UIViewController {
    
    IBOutlet UIButton *fullScreenButton;
    bool isFullScreen;
    int initY;
    
    //Team Name, score us, score them, interval
    NSString *teamName;
    NSString *scoreUs;
    NSString *scoreThem;
    NSString *interval;
    
    IBOutlet UILabel *topLabel;
    IBOutlet UILabel *usLabel;
    IBOutlet UILabel *themLabel;
    IBOutlet UILabel *scoreUsLabel;
    IBOutlet UILabel *scoreThemLabel;
    IBOutlet UILabel *intervalLabel;
}
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *scoreUs;
@property (nonatomic, retain) NSString *scoreThem;
@property (nonatomic, retain) NSString *interval;

@property (nonatomic, retain)  UILabel *topLabel;
@property (nonatomic, retain)  UILabel *usLabel;
@property (nonatomic, retain)  UILabel *themLabel;
@property (nonatomic, retain)  UILabel *scoreUsLabel;
@property (nonatomic, retain)  UILabel *scoreThemLabel;
@property (nonatomic, retain)  UILabel *intervalLabel;

@property int initY;
@property bool isFullScreen;
@property (nonatomic, retain) UIButton *fullScreenButton;

-(IBAction)fullScreen;
-(void)setLabels;
@end
