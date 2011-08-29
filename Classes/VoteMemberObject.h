//
//  VoteMemberObject.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VoteMemberObject : NSObject {

	NSString *memberName;
	NSString *memberId;
	int numVotes;
}

@property (nonatomic, retain) NSString *memberName;
@property (nonatomic, retain) NSString *memberId;
@property int numVotes;

@end
