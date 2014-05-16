//
//  ViewController.m
//  Julius Caesar Adventure
//
//  Created by Tong on 5/13/14.
//  Copyright (c) 2014 Tong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSMutableArray* choicesArray;
    NSString* screenTitle;
    NSMutableDictionary* plistRoot;
}

//@property (weak, nonatomic) IBOutlet UITextView *TextView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    [_webView setDelegate:self];
    
    choicesArray = [[NSMutableArray alloc] init];
    
    // [self.TextView setText:@"You wake up in a forest."];
    screenTitle = @"0";
    NSString *path = [[NSBundle mainBundle] pathForResource:screenTitle ofType:@"html" inDirectory:@"screens"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    
    // Load plist with choices
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Choices" ofType:@"plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:plistPath])
    {
        plistRoot = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
        choicesArray = [plistRoot objectForKey:screenTitle];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Updating on selection

- (void)updateChoicesArray:(NSString *)screen
{
    /*if ([choicesArray[0] isEqualToString:@"Look around"])
    {
        choicesArray = [NSMutableArray arrayWithObjects:@"Go back", nil];
    }
    else
    {
        choicesArray = [NSMutableArray arrayWithObjects:@"Look around", @"Go back to sleep", nil];
    }*/
    choicesArray = [plistRoot objectForKey:screenTitle];
    [self.tableView reloadData];
}

- (void)updateDisplay:(NSIndexPath *)indexPath direction:(NSString *)goingBack
{
    if ([goingBack isEqualToString:@"YES"])
        screenTitle = @"0";
    else
    {
        NSInteger selected = indexPath.row;
        NSString *selectedStr = [NSString stringWithFormat:@"%ld", (long)selected];
        screenTitle = [screenTitle stringByAppendingString:selectedStr];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:screenTitle ofType:@"html" inDirectory:@"screens"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return choicesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
 
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    // Configure the cell...
    cell.textLabel.text = [choicesArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
 
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString* goingBack;
    
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Go back"])
    {
        goingBack = @"YES";
    }
    else goingBack = @"NO";
    
    [self updateDisplay:indexPath direction:goingBack];
    [self updateChoicesArray:screenTitle];
}

@end
