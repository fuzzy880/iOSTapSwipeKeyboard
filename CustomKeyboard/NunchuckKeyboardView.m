//
//  NunchuckKeyboardView.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/19/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "NunchuckKeyboardView.h"
@interface NunchuckKeyboardView()

@property (nonatomic, strong) UIButton *lastButton;

@end

@implementation NunchuckKeyboardView

- (id)init
{
    CGRect frame = CGRectMake(0, 0, 320, 216);
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NunchuckKeyboard" owner:self options:nil];
		[[nib objectAtIndex:0] setFrame:frame];
        self = [nib objectAtIndex:0];
        self.userInteractionEnabled = YES;

    }

    return self;
}

- (IBAction)returnKey:(id)sender {
}

- (void) setUpKeyboardKeys
{
    NSLog(@"test");
    for (UIButton *key in self.characterKeys) {
        NSLog(@"%@",key.currentTitle);
        key.layer.cornerRadius = 5;
        key.layer.borderWidth = 1;
        key.layer.borderColor = key.tintColor.CGColor;
    }
    self.capsLock.layer.cornerRadius = 5;
    self.capsLock.layer.borderWidth = 1;
    self.capsLock.layer.borderColor = self.capsLock.tintColor.CGColor;
    
    self.backSpace.layer.cornerRadius = 5;
    self.backSpace.layer.borderWidth = 1;
    self.backSpace.layer.borderColor = self.backSpace.tintColor.CGColor;
    
    self.numberKey.layer.cornerRadius = 5;
    self.numberKey.layer.borderWidth = 1;
    self.numberKey.layer.borderColor = self.numberKey.tintColor.CGColor;
    
    self.space.layer.cornerRadius = 5;
    self.space.layer.borderWidth = 1;
    self.space.layer.borderColor = self.space.tintColor.CGColor;
    
    self.returnKey.layer.cornerRadius = 5;
    self.returnKey.layer.borderWidth = 1;
    self.returnKey.layer.borderColor = self.returnKey.tintColor.CGColor;
}

- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    
    for (UIButton *b in self.characterKeys) {
        
         if ([b subviews].count > 1) {
         [[[b subviews] objectAtIndex:1] removeFromSuperview];
         }
        
        if(CGRectContainsPoint(b.frame, location))
        {
            NSLog(@"touchesBegan%@", b.currentTitle);
            [self addKeyToolTip:b];
            [self characterEntered:b];
            self.lastButton = b;
            
            /*[self addPopupToButton:b];
             [[UIDevice currentDevice] playInputClick];
             [self characterPressed:b];
             self.lastButtonPressed = b;*/
        }
    }
}

-(void)touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    
    for (UIButton *b in self.characterKeys) {
        /*
         if ([b subviews].count > 1) {
         [[[b subviews] objectAtIndex:1] removeFromSuperview];
         }
         */
        if(CGRectContainsPoint(b.frame, location))
        {
            [self addKeyToolTip:b];
            if (self.lastButton != b) {
                self.lastButton = b;
                [self characterEntered:b];
                NSLog(@"touchesMoved%@", b.currentTitle);
            }
            /*[self addPopupToButton:b];
             if (self.lastButtonPressed != b) {
             self.lastButtonPressed = b;
             [self characterPressed:b];
             }*/
        }
    }
}


-(void) touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    for (UIButton *b in self.characterKeys) {
        /*
         if ([b subviews].count > 1) {
         [[[b subviews] objectAtIndex:1] removeFromSuperview];
         }
         */
        if(CGRectContainsPoint(b.frame, location))
        {
            if (self.lastButton != b) {
                NSLog(@"touchedEnded%@", b.currentTitle);
                [self characterEntered:b];
            }
            self.lastButton = nil;
            /*[self characterPressed:b];
             self.lastButtonPressed = nil;*/
            
        }
    }
}

- (void) addKeyToolTip: (UIButton *) key
{
    
}

- (void) characterEntered: (UIButton *) key
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setText:)]) {
        NSString *previousText = [self.delegate text];
        [self.delegate performSelector:@selector(setText:) withObject:[previousText stringByAppendingString:[[key titleLabel] text]]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
