//
//  Notes.h
//  iCoach
//
//  Created by Nick Wroblewski on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject {
	NSString *startDate;
	NSString *endDate;
	NSString *gameId;
	NSString *teamId;
	NSString *timeZone;
	NSString *description;
	NSString *latitude;
	NSString *longitude;
	NSString *opponent;
	NSString *userRole;
	
	NSString *scoreUs;
	NSString *scoreThem;
	NSString *interval;
	
	NSString *sport;
	NSString *teamName;
	NSString *location;
	
	NSString *mvp;
	bool hasMvp;

}
@property bool hasMvp;
@property (nonatomic, retain) NSString *mvp;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *sport;
@property (nonatomic, retain) NSString *scoreUs;
@property (nonatomic, retain) NSString *scoreThem;
@property (nonatomic, retain) NSString *interval;

@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, retain) NSString *timeZone;
@property (nonatomic, retain) NSString *gameId;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *opponent;
@property (nonatomic, retain) NSString *userRole;

@end
