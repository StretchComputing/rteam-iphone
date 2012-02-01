//
//  CreateNewEventGameday.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CreateNewEventGameday : UIViewController {
    
    
}
@property (nonatomic, strong) IBOutlet UIButton *createMultipleButton;
@property (nonatomic, strong) IBOutlet UILabel *createSingleLabel;
@property (nonatomic, strong) IBOutlet UIButton *createButton;
@property (nonatomic, strong) IBOutlet UILabel *error;
@property bool teamListFailed;
@property bool haveTeamList;
@property (nonatomic, strong) NSArray *teamList;
@property (nonatomic, strong) IBOutlet UISegmentedControl *selection;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) IBOutlet UIDatePicker *eventDateTime;

-(IBAction)create;
-(IBAction)createMultiple;
-(IBAction)segmentSelect:(id)sender;

@end
