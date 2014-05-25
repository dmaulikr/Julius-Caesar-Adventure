//
//  StartViewController.m
//  Julius Caesar Adventure
//
//  Created by Tong on 5/23/14.
//  Copyright (c) 2014 Tong. All rights reserved.
//

#import "StartViewController.h"
#import "HelpViewController.h"

@interface StartViewController (){
    int heggPresses;
}

@end

@implementation StartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IsIphone5)
    {
        [_imageView setImage:[UIImage imageNamed:@"start.png"]];
    }
    else
    {
        [_imageView setImage:[UIImage imageNamed:@"start4.png"]];
        
        CGRect startFrame = [self.startButton frame];
        CGRect helpFrame = [self.helpButton frame];
        CGRect creditsFrame = [self.creditsButton frame];
        
        startFrame.origin.y-=40;
        helpFrame.origin.y-=40;
        creditsFrame.origin.y-=40;
        
        [self.startButton setFrame:startFrame];
        [self.helpButton setFrame:helpFrame];
        [self.creditsButton setFrame:creditsFrame];
        
        [self.startButton removeFromSuperview];
        [self.helpButton removeFromSuperview];
        [self.creditsButton removeFromSuperview];
        
        [self.view addSubview:self.startButton];
        [self.view addSubview:self.helpButton];
        [self.view addSubview:self.creditsButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    heggPresses = 0;
}


#pragma mark - Navigation

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}*/

- (IBAction)buttonPressed:(id)sender
{
    if (sender == self.startButton)
    {
        [self performSegueWithIdentifier:@"startSegue" sender:self];
    }
    else if (sender == self.helpButton)
    {
        [self performSegueWithIdentifier:@"showHelp" sender:self];
    }
    else if (sender == self.creditsButton)
    {
        [self performSegueWithIdentifier:@"showCredits" sender:self];
    }
    else if (sender == self.heggButton)
    {
        heggPresses++;
        if (heggPresses == 7)
        {
            [self performSegueWithIdentifier:@"easterHegg" sender:self];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showHelp"])
    {
        HelpViewController* helpViewController = (HelpViewController *)[segue destinationViewController];
        helpViewController.isCredits = NO;
    }
    else if ([[segue identifier] isEqualToString:@"showCredits"])
    {
        HelpViewController* helpViewController = (HelpViewController *)[segue destinationViewController];
        helpViewController.isCredits = YES;
    }
    else if ([[segue identifier] isEqualToString:@"easterHegg"])
    {
        HelpViewController* helpViewController = (HelpViewController *)[segue destinationViewController];
        helpViewController.isHegg = YES;
    }
}


@end
