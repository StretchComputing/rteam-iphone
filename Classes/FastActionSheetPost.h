//
//  FastActionSheetPost.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FastActionSheetPost : UIActionSheet <UIActionSheetDelegate> {
	
}

+(void)doAction:(UIViewController *)sender :(int)buttonIndex;

@end