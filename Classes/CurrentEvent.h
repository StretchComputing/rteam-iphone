//
//  CurrentEvent.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CurrentEvent : NSObject {

	NSString *eventId;
	NSString *eventType;           //'game', 'practice' or 'generic' (or 'scores', 'newTeam')
	NSString *eventName;
	NSString *eventDescription;
	NSString *eventDate;
	
	NSString *teamId;
	NSString *teamName;
	NSString *participantRole;
	
	NSString *imageName;
	NSString *eventLabel;
    NSString *scoreLabel;
	
	NSString *gameInterval;        //games only
	NSString *sport;			   //games only
	NSString *scoreUs;
	NSString *scoreThem;
	NSString *opponent;
	
	NSString *latitude;
	NSString *longitude;
	
	bool isCanceled;
	
}
@property bool isCanceled;
@property (nonatomic, retain) NSString *scoreLabel;

@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *scoreUs;
@property (nonatomic, retain) NSString *scoreThem;
@property (nonatomic, retain) NSString *opponent;
@property (nonatomic, retain) NSString *sport;
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *eventDescription;
@property (nonatomic, retain) NSString *eventDate;

@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *participantRole;

@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSString *eventLabel;

@property (nonatomic, retain) NSString *gameInterval;
@end
