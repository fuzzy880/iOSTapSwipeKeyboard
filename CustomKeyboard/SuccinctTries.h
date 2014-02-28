//
//  SuccinctTries.h
//  CustomKeyboard
//
//  Created by Chris Wong on 1/30/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuccinctTries : NSObject

- (void) nextCharacter:(char) character;

- (NSArray *) getWordRankings;

- (NSMutableDictionary *) candidate;

- (void) startWordPrediction:(char) character;

- (void) resetState;

- (BOOL) find:(NSString *)word with:(int)start at:(int)nodeNum;

@end
