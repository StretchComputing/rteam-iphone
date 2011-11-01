//
//  HomeScoreView.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeScoreView : UIViewController {
    

}
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *scoreUs;
@property (nonatomic, strong) NSString *scoreThem;
@property (nonatomic, strong) NSString *interval;

@property (nonatomic, strong) IBOutlet UILabel *topLabel;
@property (nonatomic, strong) IBOutlet UILabel *usLabel;
@property (nonatomic, strong) IBOutlet UILabel *themLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreUsLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreThemLabel;
@property (nonatomic, strong) IBOutlet UILabel *intervalLabel;

@property int initY;
@property bool isFullScreen;
@property (nonatomic, strong) IBOutlet UIButton *fullScreenButton;

-(IBAction)fullScreen;
-(void)setLabels;
@end
