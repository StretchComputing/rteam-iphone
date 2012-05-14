//
//  CalendarEventObject.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalendarEventObject : NSObject {
    
	NSDate *eventDate;
	NSDate *eventTime;
	NSString *eventType;
}
@property (nonatomic, strong) NSDate *eventDate;
@property (nonatomic, strong) NSDate *eventTime;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *infoText;

@end
