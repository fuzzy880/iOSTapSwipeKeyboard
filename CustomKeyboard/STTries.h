//
//  STTries.h
//  CustomKeyboard
//
//  Created by Chris Wong on 1/23/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STTries : NSObject

- (BOOL) doesExist:(NSString *) string;

- (void) inputCharForWordPrediction:(char) character;

- (NSMutableArray *) getCandidateWords;

- (void) resetState;

@end
