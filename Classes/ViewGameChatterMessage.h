//
//  ViewGameChatterMessage.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewGameChatterMessage : UIViewController <UIActionSheetDelegate> {

	NSString *senderName;
	NSString *messageDate;
	NSString *messageSubject;
	NSString *messageBody;
	
	IBOutlet UILabel *topLabel;
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *bottomLabel;
	
	IBOutlet UITextView *textView;
}
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) NSString *senderName;
@property (nonatomic, retain) NSString *messageDate;
@property (nonatomic, retain) NSString *messageSubject;
@property (nonatomic, retain) NSString *messageBody;

@property (nonatomic, retain)  UILabel *topLabel;
@property (nonatomic, retain)  UILabel *dateLabel;
@property (nonatomic, retain) UILabel *bottomLabel;

@end
