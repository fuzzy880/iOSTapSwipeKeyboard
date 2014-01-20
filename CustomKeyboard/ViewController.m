//
//  ViewController.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/18/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "ViewController.h"
#import "NunchuckKeyboard.h"
@interface ViewController () {
    NunchuckKeyboard *keyboard;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*UIToolbar *keyboardView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 568, 320, 568/3)];
    keyboardView.barStyle = UIBarStyleBlack;
    keyboardView.translucent = YES;*/
    
    keyboard = [[NunchuckKeyboard alloc]initWithNibName:@"NunchuckKeyboard" bundle:nil];
    
    [self.textField setInputView:keyboard.view];
    [keyboard setDelegate:self.textField];
    
    /*UIButton *bKey = [UIButton buttonWithType:UIButtonTypeSystem];
    bKey.layer.cornerRadius = 2;
    bKey.layer.borderWidth = 1;
    bKey.layer.borderColor = [UIColor whiteColor].CGColor;
    [bKey setTitle:@"b" forState:UIControlStateNormal];
    bKey.frame = CGRectMake(200, 40, 35, 51);
    bKey.backgroundColor = [UIColor lightGrayColor];
    [bKey addTarget:self action:@selector(loadText) forControlEvents:UIControlEventTouchUpInside];
    // this just simply adds the button onto the keyboard view
    [keyboardView addSubview:bKey];*/

	// Do any additional setup after loading the view, typically from a nib.
}

- (void) loadText {
    NSString *textString = self.textField.text;
    self.textField.text = [textString stringByAppendingString:@"b"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
