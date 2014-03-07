//
//  SuccinctTries.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/30/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "SuccinctTries.h"
#import "STState.h"

#define BIT_COUNT 1517319

@interface SuccinctTries()


@property (nonatomic, strong) NSString *nodePointers;

@property (nonatomic, strong) NSString *nodeChar;

@property (nonatomic, strong) NSArray *wordRank;

@property (nonatomic, strong) NSArray *nodeBitVector;

@property (nonatomic, strong) NSMutableArray *bfsQueue;

@property (nonatomic, strong) NSMutableDictionary *candidate;

@property (nonatomic, strong) NSMutableDictionary *prefixes;


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
        self.nodeBitVector = [bitDirDump componentsSeparatedByString:@"\n"];
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

- (NSMutableDictionary *) prefixes
{
    if (!_prefixes) {
        _prefixes = [[NSMutableDictionary alloc] init];
    }
    return _prefixes;
}

/**
 * Finds the position of the ith 0 bit
 *
 * Determines the position of the ith 0 bit by lookup into a directory that
 * relates the number of 0 bits seen at every 50th position.  The remainder is
 * then counted up from that position.  If there is no ith 0 bit, -1 is returned.
 */
- (int) selectNode:(int) position
{
    int bitDirIndex = position/50;
    int count = position - bitDirIndex*50;
    if (bitDirIndex*50 > 0) {
        count++;
    }
    int qWin = [[self.nodeBitVector objectAtIndex:bitDirIndex] intValue];
    for (int q = qWin; q < BIT_COUNT; q++) {
        if ([self.nodePointers characterAtIndex:q] == '0') {
            count--;
            if (count == 0) {
                return q;
            }
        }
    }
    
    return -1;
}

/**
 * Determines the first child's node number of the given node
 *
 */
- (int) firstChild:(int) nodeNum
{
    return ([self selectNode:(nodeNum + 1)] - nodeNum);
}

/**
 * Determines the number of children for a given node
 *
 */
- (int) getChildren:(int) nodeNum
{
    int firstChild = [self selectNode:(nodeNum + 1)] - nodeNum;
    int nextChild = [self selectNode:(nodeNum + 2)] - nodeNum - 1;
    if (firstChild == -1 || nextChild == -1) {
        NSLog(@"not found");
    }
    return nextChild - firstChild;
}

/**
 * Add the state to queue if it does not exist already
 *
 */
- (void) addStateToQueue:(STState *) state
{
    if ([self.prefixes objectForKey:state.prefix] == nil) {
        [self.bfsQueue addObject:state];
        [self.prefixes setObject:@"" forKey:state.prefix];
    }
}


/**
 * Add an array of states to the queue
 *
 */
- (void) addStatesToQueue:(NSMutableArray *) states
{
    for (STState *state in states) {
        [self addStateToQueue:state];
    }
}

/**
 * Start the word prediction heuristic with the first character
 *
 */
- (void) startWordPrediction:(char) character
{
    NSString *prefix = [[NSString alloc] initWithFormat:@"%c", character];
    int firstChild = [self firstChild:0];
    int numChildren = [self getChildren:0];
    
    for (int i = 0; i < numChildren; i++) {
        int curr = firstChild + i;
        if ([self.nodeChar characterAtIndex:curr] == character) {
            [self addStateToQueue:[[STState alloc] initAtNode:curr withCurrentPrefix:prefix withErrorCount:0]];
            return;
        }
    }
}

/**
 * Run an iteration of BFS with the next character
 *
 * Check the children of every state and if a child matches the character, push
 * the state onto the queue.  If discovered a node that makes up a word, add word
 * and rank to list of candidates
 */
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
    [self addStatesToQueue:localQueue];
}

/**
 * Run a BFS iteration for the character twice to handle repeated characters
 */
- (void) nextCharacter:(char) character
{
    [self runBfsIteration:character];
    [self runBfsIteration:character];
}

/**
 * Get the discovered words and its frequency ranking
 *
 */
- (NSArray *) getWordRankings
{
    return [self.candidate allKeys];
}

/**
 * Flush the state of heuristic
 */
- (void) resetState
{
    [self.bfsQueue removeAllObjects];
    [self.candidate removeAllObjects];
    [self.prefixes removeAllObjects];
}

/**
 * Checks if word exists in trie
 */
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

@end
