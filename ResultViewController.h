//
//  ResultViewController.h
//  Julius Caesar Adventure
//
//  Created by Tong on 5/24/14.
//  Copyright (c) 2014 Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController <UIWebViewDelegate>

@property NSString* typesicle;
@property NSString* character;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *againButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
