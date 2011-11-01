//
//  AllEventCalList.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AllEventCalList : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

}
@property bool isCancel;
@property (nonatomic, strong) NSString *gameIdCanceled;
@property (nonatomic, strong) NSString *practiceIdCanceled;
@property (nonatomic, strong) NSString *eventIdCanceled;

@property int cancelSection;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *deleteActivity;
@property int cancelRow;
@property (nonatomic, strong) UIActionSheet *canceledAction;
@property bool scrolledOnce;
@property (nonatomic, strong) IBOutlet UITableView *calendarList;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property int initialSegment;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIToolbar *bottomBar;
@property (nonatomic, strong) NSArray *allGames;
@property (nonatomic, strong) NSArray *allPractices;
@property (nonatomic, strong) NSArray *allEvents;
@property (nonatomic, strong) NSArray *events;

-(void)buildDateArray;
-(NSString *)getDateForObject:(id)event;
-(void)scrollToCurrent;
@end
