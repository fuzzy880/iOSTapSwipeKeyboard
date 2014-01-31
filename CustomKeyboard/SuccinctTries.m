//
//  SuccinctTries.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/30/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "SuccinctTries.h"
#define NODE_COUNT 758659

@interface SuccinctTries()

@property (nonatomic) const char *nodePointers;

@property (nonatomic) const char *nodeChar;

@property (nonatomic, strong) NSArray *nodeWords;

@end


@implementation SuccinctTries

- (id) init
{
    self = [super init];
    if (self) {
        //self.nodePointers = CFBitVectorCreateMutable(NULL, 0);
        NSString *bitPath = [[NSBundle mainBundle] pathForResource:@"trie_bit_array" ofType:@"txt"];
        NSString* bitString = [NSString stringWithContentsOfFile:bitPath encoding:NSUTF8StringEncoding error:NULL];
        self.nodePointers = [bitString UTF8String];
        /*for (int i = 0; i < [bitString length]; i++) {
            CFBitVectorSetBitAtIndex(self.nodePointers, i, bitArray[i]);
        }*/
        
        NSString *charPath = [[NSBundle mainBundle] pathForResource:@"char_data_array" ofType:@"txt"];
        NSString* charString = [NSString stringWithContentsOfFile:charPath encoding:NSUTF8StringEncoding error:NULL];
        self.nodeChar = [charString UTF8String];
        
        NSString *stringPath = [[NSBundle mainBundle] pathForResource:@"string_data_array" ofType:@"txt"];
        NSString* stringDump = [NSString stringWithContentsOfFile:stringPath encoding:NSUTF8StringEncoding error:NULL];
        self.nodeWords = [stringDump componentsSeparatedByString:@"\n"];
        NSLog(@"");
    }
    
    return self;
}

@end




