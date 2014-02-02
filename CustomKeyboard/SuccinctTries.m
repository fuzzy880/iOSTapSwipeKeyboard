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

@property (nonatomic, strong) NSArray *nodeWords;

@property (nonatomic, strong) NSArray *nodeRank;

@property (nonatomic, strong) NSArray *nodePointerDir;


@property (nonatomic, strong) NSMutableArray *queue;

@property (nonatomic, strong) NSMutableDictionary *candidate;

@end


@implementation SuccinctTries

- (id) init
{
    self = [super init];
    if (self) {
        NSString *bitPath = [[NSBundle mainBundle] pathForResource:@"trie_bit_array_v2" ofType:@"txt"];
        self.nodePointers = [NSString stringWithContentsOfFile:bitPath encoding:NSUTF8StringEncoding error:NULL];
        //nodePointers = [bitString UTF8String];
        
        NSString *charPath = [[NSBundle mainBundle] pathForResource:@"char_data_array_v2" ofType:@"txt"];
        self.nodeChar = [NSString stringWithContentsOfFile:charPath encoding:NSUTF8StringEncoding error:NULL];
        //nodeChar = [charString UTF8String];
        
        NSString *rankPath = [[NSBundle mainBundle] pathForResource:@"rank_data_array_v2" ofType:@"txt"];
        NSString* rankDump = [NSString stringWithContentsOfFile:rankPath encoding:NSUTF8StringEncoding error:NULL];
        self.nodeWords = [rankDump componentsSeparatedByString:@"\n"];
        
        NSString *stringPath = [[NSBundle mainBundle] pathForResource:@"string_data_array_v2" ofType:@"txt"];
        NSString* stringDump = [NSString stringWithContentsOfFile:stringPath encoding:NSUTF8StringEncoding error:NULL];
        self.nodeRank = [stringDump componentsSeparatedByString:@"\n"];
        
        NSString *bitDirPath = [[NSBundle mainBundle] pathForResource:@"trie_bit_dir_v2" ofType:@"txt"];
        NSString* bitDirDump = [NSString stringWithContentsOfFile:bitDirPath encoding:NSUTF8StringEncoding error:NULL];
        self.nodePointerDir = [bitDirDump componentsSeparatedByString:@"\n"];
        NSLog(@"%d", [self firstChild:608]);
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
            if ([self.nodeChar characterAtIndex:firstChild+i] == character) {
                NSString *newPrefix = [[state prefix] stringByAppendingFormat:@"%c", character];
                [localQueue addObject:[[STState alloc] initAtNode:(firstChild+i) withCurrentPrefix:newPrefix withErrorCount:state.editDist]];
                int test = (firstChild + i);
                if (![[self.nodeWords objectAtIndex:(firstChild + i)] isEqualToString:@" "]) {
                    NSString *test1111 = [self.nodeWords objectAtIndex:(firstChild + i)];
                    NSNumber *rank = [NSNumber numberWithInt:[[self.nodeWords objectAtIndex:(firstChild + i)] intValue]];
                    [self.candidate setObject:newPrefix forKey:rank];
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

- (NSArray *) getCandidateRanks
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
            if ([self.nodeChar characterAtIndex:(firstChild+i)] == [word characterAtIndex:start]) {
                int node = (firstChild+i);
                return [self find:word with:(start + 1) at:node];
            }
        }
    } else {
        if ([[self.nodeRank objectAtIndex:nodeNum] isEqualToString:word]) {
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
//    int dirIndex = position/50;
//    int leftover = position%50;
//    int count = 0;
//    for (int q = dirIndex; q <= position; q++) {
//        if([self.nodePointers characterAtIndex:q] == '1') {
//            count++;
//        }
//    }
    
    int counter = 0;
    for (int i = 0; i <= position; i++) {
        if([self.nodePointers characterAtIndex:i] == '1') {
            counter++;
        }
    }
//    if (counter == (count + [[self.nodePointerDir objectAtIndex:dirIndex] intValue])) {
//        NSLog(@"truee");
//    } else {
//        NSLog(@"flase");
//    }
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




