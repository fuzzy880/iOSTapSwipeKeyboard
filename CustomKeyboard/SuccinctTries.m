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

@property (nonatomic, strong) NSString *nodePointers;

@property (nonatomic, strong) NSString *nodeChar;

@property (nonatomic, strong) NSArray *wordRank;

@property (nonatomic, strong) NSArray *nodePointerDir;

@property (nonatomic, strong) NSMutableArray *bfsQueue;

@property (nonatomic, strong) NSMutableDictionary *candidate;

@end


@implementation SuccinctTries

- (id) init
{
    self = [super init];
    if (self) {
        NSString *bitPath = [[NSBundle mainBundle] pathForResource:@"trie_bit_array_v2" ofType:@"txt"];
        self.nodePointers = [NSString stringWithContentsOfFile:bitPath encoding:NSUTF8StringEncoding error:NULL];
        
        NSString *charPath = [[NSBundle mainBundle] pathForResource:@"char_data_array_v2" ofType:@"txt"];
        self.nodeChar = [NSString stringWithContentsOfFile:charPath encoding:NSUTF8StringEncoding error:NULL];
        
        NSString *rankPath = [[NSBundle mainBundle] pathForResource:@"rank_data_array_v2" ofType:@"txt"];
        NSString* rankDump = [NSString stringWithContentsOfFile:rankPath encoding:NSUTF8StringEncoding error:NULL];
        self.wordRank = [rankDump componentsSeparatedByString:@"\n"];
        
        
        NSString *bitDirPath = [[NSBundle mainBundle] pathForResource:@"trie_bit_dir_v2" ofType:@"txt"];
        NSString* bitDirDump = [NSString stringWithContentsOfFile:bitDirPath encoding:NSUTF8StringEncoding error:NULL];
        self.nodePointerDir = [bitDirDump componentsSeparatedByString:@"\n"];
        NSLog(@"%d", [self firstChild:608]);
    }

    return self;
}

- (NSMutableArray *) bfsQueue
{
    if (!_bfsQueue) {
        _bfsQueue = [[NSMutableArray alloc] init];
    }
    return _bfsQueue;
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
    NSMutableArray *localQueue = [[NSMutableArray alloc] init];
    for (STState *state in self.bfsQueue) {
        int firstChild = [self firstChild:[state nodeNum]];
        int numChildren = [self getChildren:[state nodeNum]];
        
        for (int i = 0; i < numChildren; i++) {
            int nodeNum = firstChild + i;
            if ([self.nodeChar characterAtIndex:nodeNum] == character) {
                NSString *newPrefix = [[state prefix] stringByAppendingFormat:@"%c", character];
                [localQueue addObject:[[STState alloc] initAtNode:nodeNum withCurrentPrefix:newPrefix withErrorCount:state.editDist]];
                if (![[self.wordRank objectAtIndex:(firstChild + i)] isEqualToString:@" "]) {
                    NSNumber *rank = [NSNumber numberWithInt:[[self.wordRank objectAtIndex:nodeNum] intValue]];
                    [self.candidate setObject:newPrefix forKey:rank];
                }
            }
        }
    }
    if ([[self.bfsQueue objectAtIndex:0] nodeNum] == 0) {
        [self.bfsQueue removeObjectAtIndex:0];
    }
    [self.bfsQueue addObjectsFromArray:localQueue];
}

- (void) inputCharForWordPrediction:(char) character
{
    if ([self.bfsQueue count] == 0) {
        NSString *prefix = [[NSString alloc] init];
        [self.bfsQueue addObject:[[STState alloc] initAtNode:0 withCurrentPrefix:prefix withErrorCount:0]];
    } else {
        [self runBfsIteration:character];
    }
    [self runBfsIteration:character];
}

- (NSArray *) getCandidateRanks
{
    return [self.candidate allKeys];
}


- (void) resetState
{
    [self.bfsQueue removeAllObjects];
    [self.candidate removeAllObjects];
}

- (BOOL) find:(NSString *)word with:(int)start at:(int)nodeNum
{
    if (start < [word length]) {
        int firstChild = [self firstChild:nodeNum];
        int numChildren = [self getChildren:nodeNum];
        for (int i = 0; i < numChildren; i++) {
            if ([self.nodeChar characterAtIndex:(firstChild+i)] == [word characterAtIndex:start]) {
                int node = (firstChild+i);
                return [self find:word with:(start + 1) at:node];
            }
        }
    } else {
        if (![[self.wordRank objectAtIndex:nodeNum] isEqualToString:@" "]) {
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
    int nextChild = [self selectNode:(nodeNum + 2)] - nodeNum - 1;
    if (firstChild == -1 || nextChild == -1) {
        NSLog(@"not found");
    }
    return nextChild - firstChild;
}

- (int) rankNode:(int) position
{
    int counter = 0;
    for (int i = 0; i <= position; i++) {
        if([self.nodePointers characterAtIndex:i] == '1') {
            counter++;
        }
    }
    return counter;
}

- (int) selectNode:(int) position
{
    int dirIndex = position/50;

    int count = position - dirIndex*50;
    if (dirIndex*50 > 0) {
        count++;
    }
    int qWin = [[self.nodePointerDir objectAtIndex:dirIndex] intValue];
    for (int q = qWin; q < BIT_COUNT; q++) {
        if([self.nodePointers characterAtIndex:q] == '0') {
            count--;
            if (count == 0) {
                return q;
            }
        }
    }

    return -1;
}

@end




