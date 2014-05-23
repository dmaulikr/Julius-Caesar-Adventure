//
//  ViewController.m
//  Julius Caesar Adventure
//
//  Created by Tong on 5/13/14.
//  Copyright (c) 2014 Tong. All rights reserved.
//

#import "ViewController.h"

#define SOOTHSAYER 0;
#define OCTAVIUS 1;
#define CALPURNIA 2;
#define PORTIA 3;
#define CASSIUS 4;
#define FLAVIUS 5;

@interface ViewController (){
    NSMutableArray* choicesArray;
    NSMutableDictionary* plistRoot;
    NSString* screenTitle;
    int screenNumber;
    int soothsayer;
    int octavius;
    int calpurnia;
    int portia;
    int cassius;
    int flavius;
    NSString* character;
}

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
    screenTitle = @"0";
    screenNumber = 0;
    soothsayer = 0; octavius = 0; calpurnia = 0; portia = 0; cassius = 0; flavius = 0;

    // Make stuff look pretty
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choicesBG"]]];
    
    UIImage* topImage;
    if (IsIphone5)
    {
        topImage = [UIImage imageNamed:@"longTopBG"];
    }
    else topImage = [UIImage imageNamed:@"shortTopBG"];
    [self.imageView setImage:topImage];
    
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self.statusBarView setBackgroundColor:[UIColor blackColor]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Display first thing
    NSString *path = [[NSBundle mainBundle] pathForResource:screenTitle ofType:@"html" inDirectory:@"Screens"];
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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Updating on selection and whatnot

- (void)updateChoicesArray
{
    if ([screenTitle hasSuffix:@"_"]){
        choicesArray = [plistRoot objectForKey:[screenTitle substringToIndex:(screenTitle.length - 1)]];
    }
    else
        choicesArray = [plistRoot objectForKey:@"Continue"];
    [self.tableView reloadData];
}

- (void)updateDisplay:(NSIndexPath *)indexPath direction:(NSString *)direction
{
    
    
    if ([direction isEqualToString:@"BACK"])
    {
        screenTitle = @"0";
        screenNumber = 0;
    }
    else if ([direction isEqualToString:@"NEXT"])
    {
        screenNumber++;
        if (screenNumber < 10)
        {
            screenTitle = [NSString stringWithFormat:@"%d", screenNumber];
            screenTitle = [screenTitle stringByAppendingString:@"_"];
        }
        else
        {
            if (screenNumber == 10)
                [self chooseChar];
            NSString* secondPart = [NSString stringWithFormat:@"%d", screenNumber - 10];
            secondPart = [secondPart stringByAppendingString:@"_"];
            screenTitle = [character stringByAppendingString:secondPart];
        }
    }
    else
    {
        NSInteger selected = indexPath.row;
        NSString *selectedStr = [NSString stringWithFormat:@"%ld", (long)selected];
        if (screenNumber > 0)
            screenTitle = [screenTitle substringToIndex:(screenTitle.length - 1)];
        screenTitle = [screenTitle stringByAppendingString:selectedStr];
        [self addPoints];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:screenTitle ofType:@"html" inDirectory:@"Screens"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (void)addPoints
{
    int screenInt = [screenTitle intValue];
    
    switch (screenInt)
    {
        case 00:
            soothsayer++; octavius++;
            break;
        case 01:
            calpurnia++; portia++; cassius++; flavius++;
            break;
        case 10:
            soothsayer+=4; calpurnia++;
            break;
        case 20:
            portia+=2 ; soothsayer+=2;
            break;
        case 21:
            calpurnia++; cassius+=2; octavius+=2; flavius+=3;
            break;
        case 30:
            portia+=3; octavius+=4;
            break;
        case 31:
            soothsayer+=2; calpurnia+=4;
            break;
        case 32:
            flavius+=3; cassius+=4;
            break;
        case 40:
            soothsayer++; cassius++; calpurnia++; flavius+=2; octavius+=3;
            break;
        case 41:
            calpurnia++; portia+=2; cassius+=3;
            break;
        case 42:
            cassius++; portia+=2;
            break;
        case 43:
            portia++; soothsayer++; calpurnia+=4;
        case 50:
            soothsayer++; cassius +=4;
            break;
        case 51:
            flavius+=2; portia+=3; octavius+=4;
            break;
        case 52:
            portia++; soothsayer++; calpurnia+=4;
            break;
        case 53:
            flavius++; cassius++; soothsayer+=3;
            break;
        case 60:
            cassius++; soothsayer++; calpurnia+=2; octavius+=3;
            break;
        case 61:
            octavius++; flavius+=3;
            break;
        case 62:
            cassius+=2; portia+=2; soothsayer+=2;
            break;
        case 70:
            portia+=2; calpurnia+=2;
            break;
        case 71:
            portia++; octavius+=2; cassius+=2; flavius+=2; soothsayer+=2;
            break;
        case 80:
            cassius++; flavius++; portia++; octavius+=3;
            break;
        case 81:
            flavius+=2; cassius+=2;
            break;
        case 82:
            portia++; soothsayer++; calpurnia+=4;
            break;
        case 90:
            flavius++; portia+=3; octavius+=4;
            break;
        case 91:
            flavius+=2; soothsayer+=3; cassius+=3;
            break;
        case 92:
            soothsayer++; calpurnia+=3;
            break;
        default:
            break;
    }
}

- (void)chooseChar
{
    int pointsArray[6] = {soothsayer, octavius, calpurnia, portia, cassius, flavius};
    int maxIndex = 0;
    int max = pointsArray[0];
    for (int i = 1; i < 6; i++)
    {
        if (pointsArray[i] > max)
        {
            maxIndex = i;
            max = pointsArray[i];
        }
    }
    
    switch (maxIndex)
    {
        case 0:
            character = @"soothsayer";
            break;
        case 1:
            character = @"octavius";
            break;
        case 2:
            character = @"calpurnia";
            break;
        case 3:
            character = @"portia";
            break;
        case 4:
            character = @"cassius";
            break;
        case 5:
            character = @"flavius";
            break;
        default:
            break;
    }
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
    
    UIImageView *cellBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBG"]];
 
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    // Configure the cell...
    cell.textLabel.text = [choicesArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.backgroundView = cellBackground;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString* direction;
    
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Go back"])
    {
        direction = @"BACK";
    }
    else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Continue"])
    {
        direction = @"NEXT";
    }
    else direction = @"RESULT";
    
    [self updateDisplay:indexPath direction:direction];
    [self updateChoicesArray];
}

@end
