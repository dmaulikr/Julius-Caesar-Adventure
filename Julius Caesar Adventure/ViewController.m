//
//  ViewController.m
//  Julius Caesar Adventure
//
//  Created by Tong on 5/13/14.
//  Copyright (c) 2014 Tong. All rights reserved.
//

#import "ViewController.h"
#import "ResultViewController.h"

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
    screenTitle = @"0_";
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
    
    //[self setNeedsStatusBarAppearanceUpdate];
    [self.statusBarView setBackgroundColor:[UIColor clearColor]];
    
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
        choicesArray = [plistRoot objectForKey:@"0"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.comingBack)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


#pragma mark - Updating on selection and whatnot

- (void)updateChoicesArray
{
    if ([screenTitle hasSuffix:@"_"]){
        choicesArray = [plistRoot objectForKey:[screenTitle substringToIndex:(screenTitle.length - 1)]];
    }
    else
    {
        choicesArray = [plistRoot objectForKey:screenTitle];
        if (choicesArray == nil)
            choicesArray = [plistRoot objectForKey:@"Continue"];
    }
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
            else if (screenNumber == 14)
            {
                if ([character isEqualToString:@"soothsayer"] && soothsayer > 0)
                    screenNumber++;
                else if ([character isEqualToString:@"octavius"] && octavius > 0)
                    screenNumber++;
                else if ([character isEqualToString:@"calpurnia"] && calpurnia > 0)
                    screenNumber++;
                else if ([character isEqualToString:@"portia"] && portia > 0)
                    screenNumber++;
            }
            NSString* secondPart = [NSString stringWithFormat:@"%d", screenNumber - 10];
            secondPart = [secondPart stringByAppendingString:@"_"];
            screenTitle = [character stringByAppendingString:secondPart];
        }
    }
    else if ([direction isEqualToString:@"DIED"])
    {
        [self performSegueWithIdentifier:@"showDeath" sender:self];
    }
    else if ([direction isEqualToString:@"DONE"])
    {
        [self performSegueWithIdentifier:@"showSuccess" sender:self];
    }
    else if ([direction isEqualToString:@"RESULT"])
    {
        NSInteger selected = indexPath.row;
        NSString *selectedStr = [NSString stringWithFormat:@"%ld", (long)selected];
        screenTitle = [screenTitle substringToIndex:(screenTitle.length - 1)];
        screenTitle = [screenTitle stringByAppendingString:selectedStr];
        [self addPoints];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:screenTitle ofType:@"html" inDirectory:@"Screens"];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:path isDirectory:NO])
    {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    }
}

- (void)addPoints
{
    int screenInt;
    if (screenNumber > 10)
    {
        NSString* lastTwo = [screenTitle substringFromIndex:(screenTitle.length - 2)];
        screenInt = [lastTwo intValue];
    }
    else screenInt = [screenTitle intValue];

    if (screenNumber < 10)
    {
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
                portia++; soothsayer++; calpurnia+=4;
            case 50:
                soothsayer+=3; cassius +=4;
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
    else if (screenNumber > 10 && [character isEqualToString:@"soothsayer"])
    {
        switch (screenInt)
        {
            case 01:
                soothsayer-=10;
                break;
            case 12:
                soothsayer-=15;
                break;
            case 20:
                soothsayer-=10;
                break;
            case 31:
                soothsayer-=100;
                break;
            default:
                break;
        }
    }
    else if (screenNumber > 10 && [character isEqualToString:@"octavius"])
    {
        switch (screenInt)
        {
            case 11:
                octavius-= 10;
                break;
            case 21:
                octavius-= 10;
                break;
            case 31:
                octavius-= 15;
            default:
                break;
        }
    }
    else if (screenNumber > 10 && [character isEqualToString:@"calpurnia"])
    {
        switch (screenInt)
        {
            case 00:
                calpurnia-=10;
                break;
            case 11:
                calpurnia-=15;
                break;
            case 30:
                calpurnia-=15;
                break;
            default:
                break;
        }
    }
    else if (screenNumber > 10 && [character isEqualToString:@"portia"])
    {
        switch (screenInt)
        {
            case 01:
                portia-=15;
                break;
            case 02:
                portia-=100;
                break;
            case 11:
                portia-=15;
                break;
            default:
                break;                
        }
    }
}

- (void)chooseChar
{
    int pointsArray[4] = {soothsayer, octavius, calpurnia, portia};
    int maxIndex = 0;
    int max = pointsArray[0];
    for (int i = 1; i < 4; i++)
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
        /*case 4:
            character = @"cassius";
            break;
        case 5:
            character = @"flavius";
            break;*/
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
    cell.textLabel.font = [UIFont fontWithName:@"IowanOldStyle-Bold" size:17.0];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString* direction;
    
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Go back"])
        direction = @"BACK";
    else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Continue"])
        direction = @"NEXT";
    else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Ouch..."])
        direction = @"DIED";
    else if (screenNumber == 15 && indexPath.row == 0)
        direction = @"DONE";
    else
        direction = @"RESULT";
    
    [self updateDisplay:indexPath direction:direction];
    [self updateChoicesArray];
}

#pragma mark - Navigation

- (IBAction)buttonPressed:(id)sender
{
    if (sender == self.logoButton)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@""
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:@"Back to Start"
                                      otherButtonTitles:nil];
        [actionSheet showInView:[self view]];
    }
}

- (IBAction)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Back to Start"])
    {
        soothsayer = 0; octavius = 0; calpurnia = 0; portia = 0; cassius = 0; flavius = 0;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDeath"])
    {
        ResultViewController* resultViewController = (ResultViewController *)[segue destinationViewController];
        [resultViewController setTypesicle:@"DEAD"];
    }
    else if ([[segue identifier] isEqualToString:@"showSuccess"])
    {
        ResultViewController* resultViewController = (ResultViewController *)[segue destinationViewController];
        [resultViewController setTypesicle:@"YAY"];
        [resultViewController setCharacter:character];
    }
}

@end
