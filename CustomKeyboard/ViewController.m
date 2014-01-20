//
//  ViewController.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/18/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "ViewController.h"
#import "NunchuckKeyboardView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NunchuckKeyboardView *keyboard = [[NunchuckKeyboardView alloc] init];
    [keyboard setDelegate:self.textField];
    [self.textField setInputView:keyboard];
    [keyboard setUpKeyboardKeys];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
