//
//  NunchuckKeyboardView.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/19/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "NunchuckKeyboardView.h"
#include "SuccinctTries.h"

@interface NunchuckKeyboardView() {
    dispatch_queue_t queue;
}

@property (nonatomic, strong) NSMutableArray *buttonsPressed;

@property (nonatomic, strong) NSArray *wordsList;

@property (nonatomic, strong) NSArray *filtered;

@property (nonatomic, strong) NSMutableString *stringBuffer;

@property (nonatomic) BOOL *capsLockBool;

@property (nonatomic, strong) SuccinctTries *wordDictionary;

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
//        self.wordDictionary = [[STTries alloc] init];
//        if ([self.wordDictionary doesExist:@"aberrational"])
//        {
//            NSLog(@"does exist");
//        } else {
//            NSLog(@"does not exist");
//
//        }
        self.wordDictionary = [[SuccinctTries alloc] init];
        queue = dispatch_queue_create("inputQueue", 0);
        NSLog(@"%d", [self.wordDictionary find:@"teet" with:0 at:0]);
    }

    return self;
}

- (NSMutableArray *) buttonsPressed
{
    if (!_buttonsPressed) {
        _buttonsPressed = [[NSMutableArray alloc] init];
    }
    return _buttonsPressed;
}

- (NSMutableString *) stringBuffer
{
    if (!_stringBuffer) {
        _stringBuffer = [[NSMutableString alloc] init];
    }
    return _stringBuffer;
}

- (NSArray *) filtered
{
    if (!_filtered) {
        _filtered = [[NSArray alloc] init];
    }
    return _filtered;
}


- (IBAction)returnKey:(id)sender {
}

- (void) setUpKeyboardKeys
{
    for (UIButton *key in self.characterKeys) {
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

//hold down delete
- (IBAction)backSpacePressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setText:)]) {
        NSString *previousText = [self.delegate text];
        if ([previousText length] > 0) {
            previousText = [previousText substringToIndex:[previousText length] - 1];
            [self.delegate performSelector:@selector(setText:) withObject:previousText];

        }
    }
}

- (IBAction)spacePressed {
    //Analyze buffer
    dispatch_async(queue, ^{
        [self generateSuggestions];
        [self.stringBuffer setString:@""];
        //
    });
    [self appendStringToDelegate:@" "];
}

- (IBAction)capsPressed {
}

- (IBAction)numberKeyPressed {
}

- (IBAction)returnPressed {
    [self appendStringToDelegate:@"\n"];
}

- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    
    for (UIButton *b in self.characterKeys) {
        
         if ([b subviews].count > 1) {
         [[[b subviews] objectAtIndex:1] removeFromSuperview];
         }
        
        if(CGRectContainsPoint(b.frame, location)) {
            [self addKeyToolTip:b];
            [self characterEntered:b];
            [self saveButtonHistory:b];
        }
    }
}

- (void)touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    
    for (UIButton *b in self.characterKeys) {
        if(CGRectContainsPoint(b.frame, location)) {
            [self addKeyToolTip:b];
            if (![self isButtonRepeated:b]) {
                [self saveButtonHistory:b];
                [self characterEntered:b];
            }
        }
    }
}


- (void) touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    for (UIButton *b in self.characterKeys) {
        if(CGRectContainsPoint(b.frame, location)) {
            if (![self isButtonRepeated:b]) {
                [self characterEntered:b];
            }
        }
    }
}

- (void) addKeyToolTip: (UIButton *) key
{
    
}

- (void) characterEntered: (UIButton *) key
{

    NSString *keyCharacter = [[[key titleLabel] text] lowercaseString];
    const char *character = [keyCharacter UTF8String];
    [self.stringBuffer appendString:keyCharacter];
    dispatch_async(queue, ^{
        [self.wordDictionary inputCharForWordPrediction:character[0]];
    });
    
    [self appendStringToDelegate:keyCharacter];
}

- (void) appendStringToDelegate:(NSString *) string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setText:)]) {
        NSString *previousText = [self.delegate text];
        [self.delegate performSelector:@selector(setText:) withObject:[previousText stringByAppendingString:string]];
    }
}

- (void) saveButtonHistory:(UIButton *) key
{
    for (UIButton *button in self.buttonsPressed) {
        if (key == button) {
            return;
        }
    }
    if ([self.buttonsPressed count] >= 2) {
        [self.buttonsPressed removeObjectAtIndex:0];
    }
    [self.buttonsPressed addObject:key];
}

- (BOOL) isButtonRepeated:(UIButton *) key
{
    for (UIButton *button in self.buttonsPressed) {
        if (key == button) {
            return true;
        }
    }
    
    if ([self.buttonsPressed count] >= 2) {
        [self.buttonsPressed removeAllObjects];
    }
    return false;
}


- (void) generateSuggestions
{
    NSSortDescriptor *lowToHigh = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *candidate = [self.wordDictionary getCandidateRanks];
    NSMutableArray *ranks = [[NSMutableArray alloc] initWithArray:candidate];
    [ranks sortUsingDescriptors:[NSArray arrayWithObject:lowToHigh]];
    for (NSNumber *rank in ranks) {
        NSLog(@"%@", [[self.wordDictionary candidate] objectForKey:rank]);
    }
    [self.wordDictionary resetState];
}




@end
