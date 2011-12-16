//
//  TraceSession.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/27/11.
//  Copyright (c) Stretch Computing. All rights reserved.
//

#import "TraceSession.h"

@implementation TraceSession

#define NUMBER_EVENTS_STORED 20

static NSMutableArray *traceSession;

+(void)initiateSession{
    
    traceSession = [NSMutableArray array];
    
}

+(void)addEventToSession:(NSString *)event{
    
    if ([traceSession count] < NUMBER_EVENTS_STORED) {
        [traceSession addObject:event];
    }else{
        [traceSession removeObjectAtIndex:0];
        [traceSession addObject:event];
    }
}

+(void)printTraceSession{
    
    for (int i = 0; i < [traceSession count]; i++) {
        NSLog(@"%d: %@", i, [traceSession objectAtIndex:i]);
    }
}
@end