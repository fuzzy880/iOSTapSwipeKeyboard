//
//  STTries.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/23/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "STTries.h"
#include "Node.h"
@interface STTries()

@property (nonatomic, strong) NSMutableDictionary *triesMap;

@end

@implementation STTries

- (NSMutableDictionary *) triesMap
{
    if (!_triesMap) {
        _triesMap = [[NSMutableDictionary alloc] init];
    }
    return _triesMap;
}

- (id) init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@""];
        NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        NSArray *words = [content componentsSeparatedByString:@"\n"];
        for (NSString *word in words) {
            const char *wordArr = [word UTF8String];
            NSString *firstChar = [NSString stringWithFormat:@"%c", wordArr[0]];
            Node *charRoot = [self.triesMap objectForKey:firstChar];
            if (!charRoot) {
                charRoot = [[Node alloc] initWith:wordArr[0]];
                [self.triesMap setValue:charRoot forKey:firstChar];
            }
            [charRoot add:wordArr from:1 withLength:[word length]];
        }
        for( NSString *aKey in [self.triesMap allKeys] )
        {
            // do something like a log:
            NSLog(aKey);
        }
    }
    return self;
}

- (BOOL) doesExist:(NSString *) string
{
    const char *wordArr = [string UTF8String];
    NSString *firstChar = [NSString stringWithFormat:@"%c", wordArr[0]];
    Node *charRoot = [self.triesMap objectForKey:firstChar];
    if (charRoot) {
        return [charRoot doesExist:wordArr from:1 withLength:[string length]];
    }
    return false;
}


@end
