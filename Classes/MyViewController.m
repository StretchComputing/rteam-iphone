/*
     File: MyViewController.m
 Abstract: A controller for a single page of content. For this application, pages simply display text on a colored background. The colors are retrieved from a static color list.
 

 
*/

#import "MyViewController.h"


@implementation MyViewController

@synthesize pageNumberLabel;

// Creates the color list the first time this method is invoked. Returns one color object from the list.
+ (UIColor *)pageControlColorWithIndex:(NSUInteger)index {
	return [UIColor whiteColor];
 
}

// Load the view nib and initialize the pageNumber ivar.
- (id)initWithPageNumber:(int)page {
    if (self == [super initWithNibName:@"MyView" bundle:nil]) {
        pageNumber = page;
    }
    return self;
}

- (void)viewDidUnload{
	
	pageNumberLabel = nil;
	[super viewDidUnload];
}

- (void)dealloc {
    [pageNumberLabel release];
    [super dealloc];
}

// Set the label and background color when the view has finished loading.
- (void)viewDidLoad {
    pageNumberLabel.text = [NSString stringWithFormat:@"Page %d", pageNumber + 1];
    self.view.backgroundColor = [MyViewController pageControlColorWithIndex:pageNumber];
}

@end
