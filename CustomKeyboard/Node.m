//
//  Node.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/23/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "Node.h"

@interface Node()

@property (nonatomic) char data;

@property (nonatomic, strong) NSMutableArray *children;

@end

@implementation Node

- (NSMutableArray *) children
{
    if (!_children) {
        _children = [[NSMutableArray alloc] init];
    }
    return _children;
}

- (id) initWith:(char)character
{
    self = [super init];
    if (self) {
        self.data = character;
    }
    return self;
}



- (void) add:(const char *)wordArr from:(NSUInteger)start withLength:(NSUInteger)length
{
    if (start < length) {
        for (Node *node in self.children) {
            if ([node data] == wordArr[start]) {
                [node add:wordArr from:start+1 withLength:length];
                return;
            }
        }
        Node *temp = [[Node alloc] initWith:wordArr[start]];
        [temp add:wordArr from:start+1 withLength:length];
        [self.children addObject:temp];
    }
}

- (BOOL) doesExist:(const char *)wordArr from:(NSUInteger)start withLength:(NSUInteger)length
{
    if (start < length) {
        for (Node *node in self.children) {
            if ([node data] == wordArr[start]) {
                return [node doesExist:wordArr from:start+1 withLength:length];
            }
        }
    }
    if (start == length) {
        if ([self.children count] == 0 || self.children == nil) {
            return true;
        }
        for (Node *node in self.children) {
            if ([node data] == '\r') {
                return true;
            }
        }
    }
    return false;
}




@end
