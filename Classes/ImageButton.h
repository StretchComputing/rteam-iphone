//
//  ImageButton.h
//  ServiceNow LiveFeed
//
//  Created by Nick Wroblewski on 9/11/11.
//  Copyright 2011 Fruition Partners. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageButton : UIButton {
    
    NSString *messageId;
    int rowPlaced;
}
@property int rowPlaced;
@property (nonatomic, retain) NSString *messageId;
@end
