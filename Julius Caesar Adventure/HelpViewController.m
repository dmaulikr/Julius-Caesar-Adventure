//
//  HelpViewController.m
//  Julius Caesar Adventure
//
//  Created by Tong on 5/24/14.
//  Copyright (c) 2014 Tong. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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
    if (self.isCredits && !self.isHegg)
    {
        if (IsIphone5)
            self.imageView.image = [UIImage imageNamed:@"credits.png"];
        else
            self.imageView.image = [UIImage imageNamed:@"credits4.png"];
    }
    else if (!self.isHegg)
    {
        if (IsIphone5)
            self.imageView.image = [UIImage imageNamed:@"help.png"];
        else
            self.imageView.image = [UIImage imageNamed:@"help4.png"];
    }
    
    // Easter hegg
    else if (self.isHegg)
    {
        NSArray* hwalepillar = [NSArray arrayWithObjects:[UIImage imageNamed:@"hwale1"], [UIImage imageNamed:@"hwale2"], nil];
        self.imageView.animationImages = hwalepillar;
        self.imageView.animationDuration = 0.01;
        [self.imageView startAnimating];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)onClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
