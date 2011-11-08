//
//  Team.h
//  iCoach
//
//  Created by Nick Wroblewski on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Team : NSObject {
    

	
}
@property (nonatomic, strong) NSString *teamUrl;
@property bool useTwitter;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *sport;

@end
