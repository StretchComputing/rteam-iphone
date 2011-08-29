//
//  FastActionSheet.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FastActionSheet : UIActionSheet <UIActionSheetDelegate> {

}

+(void)doAction:(UIViewController *)sender :(int)buttonIndex;
	
@end
