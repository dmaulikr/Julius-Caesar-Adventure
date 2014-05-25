//
//  ResultViewController.m
//  Julius Caesar Adventure
//
//  Created by Tong on 5/24/14.
//  Copyright (c) 2014 Tong. All rights reserved.
//

#import "ResultViewController.h"
#import "ViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

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
    
    if ([self.typesicle isEqualToString:@"DEAD"])
    {
        if (IsIphone5)
        {
            [self.imageView setImage:[UIImage imageNamed:@"dead"]];
        }
        else [self.imageView setImage:[UIImage imageNamed:@"dead4"]];
        
        [self.webView removeFromSuperview];
    }
    else if ([self.typesicle isEqualToString:@"YAY"])
    {
        [self.imageView setImage:[UIImage imageNamed:self.character]];
       
        [self.webView setDelegate:self];
        [self.webView setBackgroundColor:[UIColor clearColor]];
        [self.webView setOpaque:NO];
        NSString *path = [[NSBundle mainBundle] pathForResource:self.character ofType:@"html" inDirectory:@"Screens"];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender
{
    if (sender == self.againButton)
    {
        ViewController* viewController = (ViewController *)[self presentingViewController];
        [viewController setComingBack:YES];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
