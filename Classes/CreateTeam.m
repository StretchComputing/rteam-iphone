//
//  CoachCreateTeam.m
//  iCoach
//
//  Created by Nick Wroblewski on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CreateTeam.h"
#import "NewTeam.h"
#import "NewOtherTeam.h"
#import "FastActionSheet.h"
#import "TraceSession.h"

@implementation CreateTeam
@synthesize  fromHome;


-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"CreateTeam - View Will Appear"];

}
-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

- (void)viewDidLoad {
	self.title=@"New Team";
    
    if (self.fromHome) {
       	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
        [self.navigationItem setLeftBarButtonItem:homeButton]; 
    }

	
	
} 


-(void)home{
	
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}




-(void)football{
	NewTeam *tmp = [[NewTeam alloc] init];
	tmp.from = @"Football";
    tmp.fromHome = self.fromHome;
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)basketball{
	NewTeam *tmp = [[NewTeam alloc] init];
	tmp.from = @"Basketball";
    tmp.fromHome = self.fromHome;
    
	[self.navigationController pushViewController:tmp animated:YES];
}
-(void)baseball{
	NewTeam *tmp = [[NewTeam alloc] init];
	tmp.from = @"Baseball";
    tmp.fromHome = self.fromHome;
    
	[self.navigationController pushViewController:tmp animated:YES];
}
-(void)soccer{
	NewTeam *tmp = [[NewTeam alloc] init];
	tmp.from = @"Soccer";
    tmp.fromHome = self.fromHome;
    
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)hockey{
	NewTeam *tmp = [[NewTeam alloc] init];
	tmp.from = @"Hockey";
    tmp.fromHome = self.fromHome;
    
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)lacrosse{
	NewTeam *tmp = [[NewTeam alloc] init];
	tmp.from = @"Lacrosse";
    tmp.fromHome = self.fromHome;
    
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)tennis{
	NewTeam *tmp = [[NewTeam alloc] init];
	tmp.from = @"Tennis";
    tmp.fromHome = self.fromHome;
    
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)volleyball{
	NewTeam *tmp = [[NewTeam alloc] init];
	tmp.from = @"Volleyball";
    tmp.fromHome = self.fromHome;
    
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)other{
	NewOtherTeam *tmp = [[NewOtherTeam alloc] init];
    tmp.fromHome = self.fromHome;
    
	[self.navigationController pushViewController:tmp animated:YES];
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}



@end
