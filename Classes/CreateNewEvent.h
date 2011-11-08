//
//  CreateNewEvent.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CreateNewEvent : UIViewController {
    

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
@property (nonatomic, strong) NSDate *eventDate;
@property (nonatomic, strong) IBOutlet UIDatePicker *eventTime;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

-(IBAction)create;
-(IBAction)createMultiple;
-(IBAction)segmentSelect:(id)sender;

@end
