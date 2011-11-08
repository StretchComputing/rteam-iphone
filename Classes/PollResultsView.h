//
//  PollResultsView.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PollResultsView : UIViewController {
    

}

@property (nonatomic, strong) IBOutlet UILabel *option1;
@property (nonatomic, strong) IBOutlet UILabel *option2;
@property (nonatomic, strong) IBOutlet UILabel *option3;
@property (nonatomic, strong) IBOutlet UILabel *option4;
@property (nonatomic, strong) IBOutlet UILabel *option5;

@property (nonatomic, strong) IBOutlet UILabel *numOption1;
@property (nonatomic, strong) IBOutlet UILabel *numOption2;
@property (nonatomic, strong) IBOutlet UILabel *numOption3;
@property (nonatomic, strong) IBOutlet UILabel *numOption4;
@property (nonatomic, strong) IBOutlet UILabel *numOption5;

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
