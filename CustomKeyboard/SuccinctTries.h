//
//  SuccinctTries.h
//  CustomKeyboard
//
//  Created by Chris Wong on 1/30/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuccinctTries : NSObject

- (void) inputCharForWordPrediction:(char) character;

- (NSArray *) getCandidateRanks;

- (NSMutableDictionary *) candidate;

- (void) resetState;

- (BOOL) find:(NSString *)word with:(int)start at:(int)nodeNum;

@end
