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
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *scoreUs;
@property (nonatomic, strong) NSString *scoreThem;
@property (nonatomic, strong) NSString *interval;

@property (nonatomic, strong)  UILabel *topLabel;
@property (nonatomic, strong)  UILabel *usLabel;
@property (nonatomic, strong)  UILabel *themLabel;
@property (nonatomic, strong)  UILabel *scoreUsLabel;
@property (nonatomic, strong)  UILabel *scoreThemLabel;
@property (nonatomic, strong)  UILabel *intervalLabel;

@property int initY;
@property bool isFullScreen;
@property (nonatomic, strong) UIButton *fullScreenButton;

-(IBAction)fullScreen;
-(void)setLabels;
@end
