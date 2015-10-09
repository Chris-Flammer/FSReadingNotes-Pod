//
//  FSViewController.m
//  FSReadingNotes
//
//  Created by Chris Flammer on 10/09/2015.
//  Copyright (c) 2015 Chris Flammer. All rights reserved.
//

#import "FSViewController.h"
#import "FSReadingNotes.h"

@interface FSViewController ()

@end

@implementation FSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)goToReadingNotes:(id)sender {
   
    NSBundle *rootBundle = [NSBundle bundleForClass:[FSAllNotesVC class]];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:[rootBundle URLForResource:@"FSReadingNotes" withExtension:@"bundle"]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FSReadingNotesSB" bundle:resourceBundle];
    UINavigationController *overlay = [storyboard instantiateInitialViewController];
    [self presentViewController:overlay animated:YES completion:nil];
    
    
}



@end
