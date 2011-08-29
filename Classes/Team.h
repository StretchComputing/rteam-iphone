//
//  Team.h
//  iCoach
//
//  Created by Nick Wroblewski on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Team : NSObject {

	NSString *name;
	NSString *teamId;
	NSString *userRole;  //The role of the current user for this team;
	NSString *sport;
	NSString *teamUrl;
	bool useTwitter;
	
}
@property (nonatomic, retain) NSString *teamUrl;
@property bool useTwitter;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *sport;

@end
