//
//  MyLineView.m
//  iCoach
//
//  Created by Nick Wroblewski on 6/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyLineView.h"


@implementation MyLineView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	// Drawing code
	
	CGContextRef context = UIGraphicsGetCurrentContext(); // get current context
	
	// Drawing lines with a white stroke color
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 0.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 1.0);
	
	// Draw a single line from left to right
	CGContextMoveToPoint(context, 10.0, 30.0);
	CGContextAddLineToPoint(context, 310.0, 30.0);
	CGContextStrokePath(context);
}

- (void)dealloc {
    [super dealloc];
}


@end
