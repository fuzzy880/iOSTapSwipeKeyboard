//
//  STState.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/31/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "STState.h"
@interface STState()

@property (nonatomic) int nodeNum;

@property (nonatomic) NSString *prefix;

@property (nonatomic) int editDist;

@end
@implementation STState

- (id) initAtNode:(int) nodeNumber withCurrentPrefix:(NSString *)prefix withErrorCount:(int) editDistance
{
    self = [super init];
    if (self) {
        self.nodeNum = nodeNumber;
        self.editDist = editDistance;
        self.prefix = prefix;
    }
    return self;
}

- (NSString *) prefix
{
    if (!_prefix) {
        _prefix = [[NSString alloc] init];
    }
    
    return _prefix;
}


@end
