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
@property (nonatomic, retain) NSDate *eventDate;
@property (nonatomic, retain) NSDate *eventTime;
@property (nonatomic, retain) NSString *eventType;
@end
