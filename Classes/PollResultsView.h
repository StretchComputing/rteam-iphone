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

@property (nonatomic, retain) UILabel *option1;
@property (nonatomic, retain) UILabel *option2;
@property (nonatomic, retain) UILabel *option3;
@property (nonatomic, retain) UILabel *option4;
@property (nonatomic, retain) UILabel *option5;

@property (nonatomic, retain) UILabel *numOption1;
@property (nonatomic, retain) UILabel *numOption2;
@property (nonatomic, retain) UILabel *numOption3;
@property (nonatomic, retain) UILabel *numOption4;
@property (nonatomic, retain) UILabel *numOption5;

@property (nonatomic, retain) NSString *o1;
@property (nonatomic, retain) NSString *o2;
@property (nonatomic, retain) NSString *o3;
@property (nonatomic, retain) NSString *o4;
@property (nonatomic, retain) NSString *o5;

@property (nonatomic, retain) NSString *no1;
@property (nonatomic, retain) NSString *no2;
@property (nonatomic, retain) NSString *no3;
@property (nonatomic, retain) NSString *no4;
@property (nonatomic, retain) NSString *no5;

-(void)setLabels;
@end
