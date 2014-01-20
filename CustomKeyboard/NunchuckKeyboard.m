//
//  NunchuckKeyboard.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/19/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "NunchuckKeyboard.h"
#import "NunchuckKeyboardView.h"

@interface NunchuckKeyboard ()

@end

@implementation NunchuckKeyboard

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void) setUpKeyButtons
{
    for (UIButton *key in self.keys) {
        key.layer.cornerRadius = 5;
        key.layer.borderWidth = 1;
        key.layer.borderColor = key.tintColor.CGColor;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setUpKeyButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self.view];
    
    for (UIButton *b in self.keys) {
        /*
         if ([b subviews].count > 1) {
            [[[b subviews] objectAtIndex:1] removeFromSuperview];
        }
         */
        if(CGRectContainsPoint(b.frame, location))
        {
            NSLog(@"%@", b.currentTitle);

            /*[self addPopupToButton:b];
            [[UIDevice currentDevice] playInputClick];
            [self characterPressed:b];
            self.lastButtonPressed = b;*/
        }
    }
}

-(void)touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self.view];
    
    for (UIButton *b in self.keys) {
        /*
        if ([b subviews].count > 1) {
          [[[b subviews] objectAtIndex:1] removeFromSuperview];
        }
         */
        if(CGRectContainsPoint(b.frame, location))
        {
            NSLog(@"%@", b.currentTitle);

            /*[self addPopupToButton:b];
            if (self.lastButtonPressed != b) {
                self.lastButtonPressed = b;
                [self characterPressed:b];
            }*/
        }
    }
}


-(void) touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInView:self.view];
    
    for (UIButton *b in self.keys) {
        /*
         if ([b subviews].count > 1) {
            [[[b subviews] objectAtIndex:1] removeFromSuperview];
        }
         */
        if(CGRectContainsPoint(b.frame, location))
        {
            NSLog(@"%@", b.currentTitle);
            /*[self characterPressed:b];
            self.lastButtonPressed = nil;*/
            
        }
    }
}


- (IBAction)keySwipedEnter:(UIButton *)sender {
    //NSLog(@"%@",[sender titleLabel]);

}

- (IBAction)keySwipedOutside:(UIButton *)sender {
    //NSLog(@"%@",[sender titleLabel]);

}

- (IBAction)keySwipedCancel:(UIButton *)sender {
    //NSLog(@"%@",[sender titleLabel]);
}

@end
