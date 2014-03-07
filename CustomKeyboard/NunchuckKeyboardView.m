//
//  NunchuckKeyboardView.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/19/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "NunchuckKeyboardView.h"
#include "SuccinctTries.h"

#define KEYBOARDORDER @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p", @"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l", @"z", @"x", @"c", @"v", @"b", @"n", @"m"]

#define ROW1START 0

#define ROW1END 9

#define ROW2START 10

#define ROW2END 18

#define ROW3START 19

#define ROW3END 25

@interface NunchuckKeyboardView() {
    dispatch_queue_t queue;
}

@property (nonatomic, strong) NSMutableArray *buttonsPressed;

@property (nonatomic, strong) NSArray *wordsList;

@property (nonatomic, strong) NSArray *filtered;

@property (nonatomic, strong) NSMutableString *stringBuffer;

@property (nonatomic) BOOL *capsLockBool;

@property (nonatomic, strong) SuccinctTries *wordDictionary;

@property (nonatomic) int lastRow;

@property (nonatomic) int rowDirection;

@property (nonatomic) int minWordLength;


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
        self.wordDictionary = [[SuccinctTries alloc] init];
        queue = dispatch_queue_create("inputQueue", 0);
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

- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    
    for (UIButton *b in self.characterKeys) {
        if(CGRectContainsPoint(b.frame, location)) {
            [self characterEntered:b];
            [self saveButtonHistory:b];
        }
    }
}

- (void)touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    
    for (UIButton *b in self.characterKeys) {
        if(CGRectContainsPoint(b.frame, location)) {
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


- (IBAction)returnKey:(id)sender {
}

- (IBAction)capsPressed
{
}

- (IBAction)numberKeyPressed
{
}

- (IBAction)returnPressed
{
}

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
    if ([self.stringBuffer length] == 0) {
        return;
    }
    dispatch_async(queue, ^{
        [self generateSuggestions];
        [self.stringBuffer setString:@""];
    });
}

- (void) characterEntered: (UIButton *) key
{
    NSString *keyCharacter = [[[key titleLabel] text] lowercaseString];
    char character = [keyCharacter characterAtIndex:0];
    [self.stringBuffer appendString:keyCharacter];
    dispatch_async(queue, ^{
        if ([self.stringBuffer length] == 1) {
            [self startFatFingerPrediction:character];
        } else {
            [self.wordDictionary nextCharacter:character];
        }
    });
    [self minWordLength:keyCharacter];
    //[self appendStringToDelegate:keyCharacter];
}

- (void) appendStringToDelegate:(NSString *) string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setText:)]) {
        NSString *previousText = [self.delegate text];
        [self.delegate performSelector:@selector(setText:) withObject:[previousText stringByAppendingString:string]];
    }
}


/**
 * Start word heuristics with the first character the user entered and its adjacent characters on the keyboard
 *
 */
- (void) startFatFingerPrediction:(char) character
{
    NSString *key = [[NSString alloc] initWithFormat:@"%c", character];
    
    NSUInteger index = [KEYBOARDORDER indexOfObject:key];
    if (index == NSNotFound) {
        return;
    }
    [self.wordDictionary startWordPrediction:character];
    if (index - 1 >= ROW1START) {
        [self.wordDictionary startWordPrediction:[[KEYBOARDORDER objectAtIndex:index - 1] characterAtIndex:0]];
    }
    if (index + 1 <= ROW3END) {
        [self.wordDictionary startWordPrediction:[[KEYBOARDORDER objectAtIndex:index + 1] characterAtIndex:0]];
    }
}

/**
 * Choose a word from list of candidates that has the highest ranking or the first and last character
 * matches what first and last character of user input.
 *
 */
- (void) generateSuggestions
{
    NSString *matchedWord;
    NSSortDescriptor *lowToHigh = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSMutableArray *ranks = [[NSMutableArray alloc] initWithArray:[self.wordDictionary getWordRankings]];
    [ranks sortUsingDescriptors:[NSArray arrayWithObject:lowToHigh]];
    
    for (NSNumber *rank in ranks) {
        NSString *candidate = [[self.wordDictionary candidate] objectForKey:rank];
        if (!matchedWord) {
            matchedWord = candidate;
        }
        if ([candidate length] > self.minWordLength) {
            if (([candidate characterAtIndex:([candidate length] - 1)] == [self.stringBuffer characterAtIndex:([self.stringBuffer length] - 1)])
                && ([candidate characterAtIndex:0] == [self.stringBuffer characterAtIndex:0])) {
                    matchedWord = candidate;
                    break;
            }
        }
        NSLog(@"%@", candidate);
    }
    NSLog(@"%@ %d", self.stringBuffer, self.minWordLength);
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (matchedWord) {
            [self appendStringToDelegate:[matchedWord stringByAppendingString:@" "]];
        }
    });
    
    [self.wordDictionary resetState];
    [self resetMinWordLength];
}

/**
 * Get the row the pressed key is in
 *
 */
- (int) keyboardRow:(NSString *)key
{
    NSUInteger index = [KEYBOARDORDER indexOfObject:key];
    if (index >= ROW1START && index <= ROW1END) {
        return 1;
    } else if (index >= ROW2START && index <= ROW2END) {
        return 2;
    } else if (index >= ROW3START && index <= ROW3END) {
        return 3;
    }
    return -1;
}

/**
 * Get the minimum word length of an inputted sequence
 *
 * Row transitions indicate a character will exist in the final word
 * To determine the minimum word length, increment the count when the
 * the swipe changes vertical direction.
 */
- (void) minWordLength:(NSString *)key
{
    int row = [self keyboardRow:key];
    if (row != self.lastRow) {
        if (row < self.lastRow) {
            if (self.rowDirection != -1) {
                self.rowDirection = -1;
                self.minWordLength = self.minWordLength + 1;
            }
        } else {
            if (self.rowDirection != 1) {
                self.rowDirection = 1;
                self.minWordLength = self.minWordLength + 1;
            }
        }
        self.lastRow = row;
    }
}

- (void) resetMinWordLength
{
    self.minWordLength = 0;
    self.lastRow = 0;
    self.rowDirection = 0;
}

@end
