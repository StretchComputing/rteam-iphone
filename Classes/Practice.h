//
//  Web.h
//  iCoach
//
//  Created by Nick Wroblewski on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Practice : NSObject {

    
	
}
@property bool isCanceled;
@property (nonatomic, strong) NSString *messageThreadId;
@property (nonatomic, strong )NSString *teamName;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *timeZone;
@property (nonatomic, strong) NSString *practiceId;
@property (nonatomic, strong) NSString *ppteamId;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *userRole;
@end
