//
//  PollResultsView.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PollResultsView : UIViewController {
    
	IBOutlet UILabel *option1;
	IBOutlet UILabel *option2;
	IBOutlet UILabel *option3;
	IBOutlet UILabel *option4;
	IBOutlet UILabel *option5;
	
	IBOutlet UILabel *numOption1;
	IBOutlet UILabel *numOption2;
	IBOutlet UILabel *numOption3;
	IBOutlet UILabel *numOption4;
	IBOutlet UILabel *numOption5;
	
	NSString *o1;
	NSString *o2;
	NSString *o3;
	NSString *o4;
	NSString *o5;
	
	NSString *no1;
	NSString *no2;
	NSString *no3;
	NSString *no4;
	NSString *no5;
}

@property (nonatomic, strong) UILabel *option1;
@property (nonatomic, strong) UILabel *option2;
@property (nonatomic, strong) UILabel *option3;
@property (nonatomic, strong) UILabel *option4;
@property (nonatomic, strong) UILabel *option5;

@property (nonatomic, strong) UILabel *numOption1;
@property (nonatomic, strong) UILabel *numOption2;
@property (nonatomic, strong) UILabel *numOption3;
@property (nonatomic, strong) UILabel *numOption4;
@property (nonatomic, strong) UILabel *numOption5;

@property (nonatomic, strong) NSString *o1;
@property (nonatomic, strong) NSString *o2;
@property (nonatomic, strong) NSString *o3;
@property (nonatomic, strong) NSString *o4;
@property (nonatomic, strong) NSString *o5;

@property (nonatomic, strong) NSString *no1;
@property (nonatomic, strong) NSString *no2;
@property (nonatomic, strong) NSString *no3;
@property (nonatomic, strong) NSString *no4;
@property (nonatomic, strong) NSString *no5;

-(void)setLabels;
@end
