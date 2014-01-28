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

@property (nonatomic, strong) NSMutableArray *queue;

@property (nonatomic, strong) NSMutableArray *candidate;

@end

@implementation STTries

- (NSMutableDictionary *) triesMap
{
    if (!_triesMap) {
        _triesMap = [[NSMutableDictionary alloc] init];
    }
    return _triesMap;
}

- (NSMutableArray *) queue
{
    if (!_queue) {
        _queue = [[NSMutableArray alloc] init];
    }
    return _queue;
}

- (NSMutableArray *) candidate
{
    if (!_candidate) {
        _candidate = [[NSMutableArray alloc] init];
    }
    return _candidate;
}

- (id) init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@""];
        NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        NSArray *words = [content componentsSeparatedByString:@"\n"];
        content = nil;
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

- (void) runBfsIteration:(char) character
{
    //Node *temp = [self.queue objectAtIndex:0];
    //[self.queue removeObjectAtIndex:0];
    NSMutableArray *localQueue = [[NSMutableArray alloc] init];
    for (Node *queuedNode in self.queue) {
        for (Node *child in queuedNode.children) {
            if (child.data == character) {
                [localQueue addObject:child];
                if (child.finalWord) {
                    NSString *test = [[NSString alloc] initWithUTF8String:child.finalWord];
                    if (test) {
                    } else {
                        NSLog(@"");
                    }
                }
            }
        }
    }
    [self.queue addObjectsFromArray:localQueue];
    
}

- (void) startSpellCheck:(char) character
{
    if ([self.queue count] == 0) {
        Node *first = [self.triesMap objectForKey:[NSString stringWithFormat:@"%c" , character]];
        if (first) {
            [self.queue addObject:first];
        }
    } else {
        [self runBfsIteration:character];
    }
}

- (NSMutableArray *) getCandidateWords
{
    for (Node *node in self.queue) {
        if (node.finalWord) {
            NSString *test = [[NSString alloc] initWithUTF8String:node.finalWord];
            if (test) {
                [self.candidate insertObject:test atIndex:0];
            } else {
                NSLog(@"");
            }
        }
    }
    return self.candidate;
}

- (void) resetState
{
    [self.queue removeAllObjects];
    [self.candidate removeAllObjects];
}


@end
