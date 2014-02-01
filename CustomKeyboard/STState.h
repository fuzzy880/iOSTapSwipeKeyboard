//
//  STState.h
//  CustomKeyboard
//
//  Created by Chris Wong on 1/31/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STState : NSObject

- (id) initAtNode:(int) nodeNumber withCurrentPrefix:(NSString *)prefix withErrorCount:(int) editDistance;

- (NSString *) prefix;

- (int) nodeNum;

- (int) editDist;

@end
