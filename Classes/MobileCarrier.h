//
//  MobileCarrier.h
//  rTeam
//
//  Created by Nick Wroblewski on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MobileCarrier : NSObject {
    
    NSString *name;
    NSString *code;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *code;

@end
