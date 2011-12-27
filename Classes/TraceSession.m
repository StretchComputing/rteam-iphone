//
//  TraceSession.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/27/11.
//  Copyright (c) Stretch Computing. All rights reserved.
//

#import "TraceSession.h"
#import "rTeamAppDelegate.h"

@implementation TraceSession

#define NUMBER_EVENTS_STORED 20

static NSMutableArray *traceSession;
static NSMutableArray *traceTimeStamps;


+(void)initiateSession{
    
    traceSession = [NSMutableArray array];
    traceTimeStamps = [NSMutableArray array];
    
}

+(void)addEventToSession:(NSString *)event{
    
    if ([traceSession count] < NUMBER_EVENTS_STORED) {
        [traceSession addObject:event];
        [traceTimeStamps addObject:[NSDate date]];
    }else{
        [traceSession removeObjectAtIndex:0];
        [traceSession addObject:event];
        [traceTimeStamps removeObject:0];
        [traceTimeStamps addObject:[NSDate date]];
    }
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *tmpTrace = @"";
    NSString *tmpTraceTime = @"";
    
    
    for (int i = 0; i < [traceSession count]; i++) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSS"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        if (i == ([traceSession count] - 1)) {
            tmpTrace = [tmpTrace stringByAppendingFormat:@"%@", [traceSession objectAtIndex:i]];
            
            tmpTraceTime = [tmpTraceTime stringByAppendingFormat:@"%@", dateString];

        }else{
            tmpTrace = [tmpTrace stringByAppendingFormat:@"%@,", [traceSession objectAtIndex:i]];
            tmpTraceTime = [tmpTraceTime stringByAppendingFormat:@"%@,", dateString];

        }
    }
    
    mainDelegate.lastTwenty = [NSString stringWithString:tmpTrace];
    mainDelegate.lastTwentyTime = [NSString stringWithString:tmpTraceTime];
    [mainDelegate saveUserInfo];
}

+(NSMutableArray *)getActions{
    
    return [NSMutableArray arrayWithArray:traceSession];
}

+(NSMutableArray *)getTimestamps{
    return [NSMutableArray arrayWithArray:traceTimeStamps];

}

+(void)setSavedArray:(NSMutableArray *)savedArray :(NSMutableArray *)savedArrayTime{
    
    traceSession = [NSMutableArray arrayWithArray:savedArray];
    traceTimeStamps = [NSMutableArray arrayWithArray:savedArrayTime];
}

+(void)printTraceSession{
    
    for (int i = 0; i < [traceSession count]; i++) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
        NSString *dateString = [dateFormatter stringFromDate:[traceTimeStamps objectAtIndex:i]];
        
        NSLog(@"%d: %@ - %@", i, [traceSession objectAtIndex:i], dateString);
    }
}
@end