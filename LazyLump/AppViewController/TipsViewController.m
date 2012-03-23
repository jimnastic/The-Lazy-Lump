//
//  TipsViewController.m
//  LazyLump
//
//  Created by iMobDev Technologies Pvt. Ltd. on 16/03/12.
//  Copyright (c) 2012 iMobDev Tech. All rights reserved.
//

#import "TipsViewController.h"

@implementation TipsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (IBAction)TwitterBtnClicked:(id)sender 
{
    NSLog(@"Twitter Click");
}

- (IBAction)FacebookBtnClicked:(id)sender
{
    NSLog(@"FacebookClick");
}

- (IBAction)LazyLumplinkClicked:(id)sender {
    NSLog(@"Link Click");
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.jollywombat.com"]];
}

- (IBAction)BackBtnClicked:(id)sender {
//    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}
@end
