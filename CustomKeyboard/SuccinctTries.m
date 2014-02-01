//
//  SuccinctTries.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/30/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "SuccinctTries.h"
#import "STState.h"

#define NODE_COUNT 758659
#define BIT_COUNT 1517319

@interface SuccinctTries()

@property (nonatomic, strong) NSArray *nodeWords;

@property (nonatomic, strong) NSMutableArray *queue;

@property (nonatomic, strong) NSMutableDictionary *candidate;

@end


@implementation SuccinctTries{
    const char *nodePointers;
    const char *nodeChar;
}

- (id) init
{
    self = [super init];
    if (self) {
        NSString *bitPath = [[NSBundle mainBundle] pathForResource:@"trie_bit_array" ofType:@"txt"];
        NSString* bitString = [NSString stringWithContentsOfFile:bitPath encoding:NSUTF8StringEncoding error:NULL];
        nodePointers = [bitString UTF8String];
        
        NSString *charPath = [[NSBundle mainBundle] pathForResource:@"char_data_array" ofType:@"txt"];
        NSString* charString = [NSString stringWithContentsOfFile:charPath encoding:NSUTF8StringEncoding error:NULL];
        nodeChar = [charString UTF8String];
        
        NSString *stringPath = [[NSBundle mainBundle] pathForResource:@"string_data_array" ofType:@"txt"];
        NSString* stringDump = [NSString stringWithContentsOfFile:stringPath encoding:NSUTF8StringEncoding error:NULL];
        self.nodeWords = [stringDump componentsSeparatedByString:@"\n"];
    }
    
    return self;
}

- (NSMutableArray *) queue
{
    if (!_queue) {
        _queue = [[NSMutableArray alloc] init];
    }
    return _queue;
}

- (NSMutableDictionary *) candidate
{
    if (!_candidate) {
        _candidate = [[NSMutableDictionary alloc] init];
    }
    return _candidate;
}

- (void) runBfsIteration:(char) character
{
    //Node *temp = [self.queue objectAtIndex:0];
    //[self.queue removeObjectAtIndex:0];
    NSMutableArray *localQueue = [[NSMutableArray alloc] init];
    for (STState *state in self.queue) {
        int firstChild = [self firstChild:[state nodeNum]];
        int numChildren = [self getChildren:[state nodeNum]];
        for (int i = 0; i < numChildren; i++) {
            if (nodeChar[firstChild+i] == character) {
                //NSString *newPrefix = [[state prefix] stringByAppendingFormat:@"%c", character];
                [localQueue addObject:[[STState alloc] initAtNode:(firstChild+i) withCurrentPrefix:state.prefix withErrorCount:state.editDist]];
                if (![[self.nodeWords objectAtIndex:(firstChild + i)] isEqualToString:@" "]) {
                    [self.candidate setObject:@"" forKey:[self.nodeWords objectAtIndex:(firstChild + i)]];
                    //[self.candidate setObject:@"" forKey:newPrefix];
                }
            }
        }
    }
    if ([[self.queue objectAtIndex:0] nodeNum] == 0) {
        [self.queue removeObjectAtIndex:0];
    }
    [self.queue addObjectsFromArray:localQueue];
}

- (void) inputCharForWordPrediction:(char) character
{
    if ([self.queue count] == 0) {
        NSString *prefix = [[NSString alloc] init];
        [self.queue addObject:[[STState alloc] initAtNode:0 withCurrentPrefix:prefix withErrorCount:0]];
    } else {
        [self runBfsIteration:character];
    }
    [self runBfsIteration:character];
}

- (NSArray *) getCandidateWords
{
    return [self.candidate allKeys];
}

- (void) resetState
{
    [self.queue removeAllObjects];
    [self.candidate removeAllObjects];
}

- (BOOL) find:(NSString *)word with:(int)start at:(int)nodeNum
{
    if (start < [word length]) {
        int firstChild = [self firstChild:nodeNum];
        int numChildren = [self getChildren:nodeNum];
        for (int i = 0; i < numChildren; i++) {
            //char test1 = self.nodeChar[firstChild+i];
            //char test2=[word characterAtIndex:start];
            if (nodeChar[firstChild+i] == [word characterAtIndex:start]) {
                int node = (firstChild+i);
                return [self find:word with:(start + 1) at:node];
            }
        }
    } else {
        if ([[self.nodeWords objectAtIndex:nodeNum] isEqualToString:word]) {
            return true;
        }
    }
    return false;
}

- (int) firstChild:(int) nodeNum
{
    return ([self selectNode:(nodeNum + 1)] - nodeNum);
}

- (int) getChildren:(int) nodeNum
{
    int firstChild = [self selectNode:(nodeNum + 1)] - nodeNum;
    int nextChild = [self selectNode:(nodeNum + 2)] - nodeNum + 1;
    if (firstChild == -1 || nextChild == -1) {
        NSLog(@"not found");
    }
    return nextChild - firstChild;
}

- (int) rankNode:(int) position
{
    int counter = 0;
    for (int i = 0; i <= position; i++) {
        if(nodePointers[i] == '1') {
            counter++;
        }
    }
    return counter;
}

- (int) selectNode:(int) position
{
    int counter = position;
    for (int i = 0; i < BIT_COUNT; i++) {
        if(nodePointers[i] == '0') {
            counter--;
            if (counter == 0) {
                return i;
            }
        }
    }
    return -1;
}

@end




