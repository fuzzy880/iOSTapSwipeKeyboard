//
//  NunchuckKeyboardView.m
//  CustomKeyboard
//
//  Created by Chris Wong on 1/19/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import "NunchuckKeyboardView.h"

@implementation NunchuckKeyboardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;

    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
