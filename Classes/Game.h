//
//  Notes.h
//  iCoach
//
//  Created by Nick Wroblewski on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject {

    
}
@property bool hasMvp;
@property (nonatomic, strong) NSString *mvp;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *scoreUs;
@property (nonatomic, strong) NSString *scoreThem;
@property (nonatomic, strong) NSString *interval;

@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *timeZone;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *opponent;
@property (nonatomic, strong) NSString *userRole;

@end
