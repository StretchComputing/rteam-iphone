//
//  BoxScoreViewViewController.h
//  rTeam
//
//  Created by Nick Wroblewski on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxScoreViewViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *frontView;

@property (nonatomic, strong) IBOutlet UILabel *scoreUs;
@property (nonatomic, strong) IBOutlet UILabel *scoreThem;
@property (nonatomic, strong) IBOutlet UILabel *nameUs;
@property (nonatomic, strong) IBOutlet UILabel *nameThem;
@property (nonatomic, strong) IBOutlet UILabel *interval;

@end
