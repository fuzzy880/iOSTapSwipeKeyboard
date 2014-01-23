//
//  Node.h
//  CustomKeyboard
//
//  Created by Chris Wong on 1/23/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

- (id) initWith:(char)charStr;

- (void) add:(const char *)wordArr from:(NSUInteger)start withLength:(NSUInteger)length;

- (BOOL) doesExist:(const char *)wordArr from:(NSUInteger)start withLength:(NSUInteger)length;

@end
