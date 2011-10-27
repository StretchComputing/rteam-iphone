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
@property (nonatomic, strong) NSString *scoreLabel;

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *scoreUs;
@property (nonatomic, strong) NSString *scoreThem;
@property (nonatomic, strong) NSString *opponent;
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSString *eventDate;

@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *participantRole;

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *eventLabel;

@property (nonatomic, strong) NSString *gameInterval;
@end
