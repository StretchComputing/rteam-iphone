//
//  FastActionSheetHome.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FastActionSheetHome : UIActionSheet <UIActionSheetDelegate> {
	
}

+(void)doAction:(UIViewController *)sender :(int)buttonIndex;

@end
