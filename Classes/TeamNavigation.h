//
//  TeamNavigation.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TeamNavigation : UINavigationController{

	NSString *teamName;
	NSString *teamId;
	NSString *userRole;
	NSString *sport;
	NSString *teamUrl;
}

@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) NSString *sport;
@property (nonatomic, retain) NSString *teamUrl;
@end
