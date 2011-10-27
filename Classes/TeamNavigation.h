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

@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *teamUrl;
@end
