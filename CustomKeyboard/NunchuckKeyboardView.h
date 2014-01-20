//
//  NunchuckKeyboardView.h
//  CustomKeyboard
//
//  Created by Chris Wong on 1/19/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NunchuckKeyboardView : UIView

@property (nonatomic, weak) id delegate;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *characterKeys;

@property (strong, nonatomic) IBOutlet UIButton *capsLock;

@property (strong, nonatomic) IBOutlet UIButton *backSpace;

@property (strong, nonatomic) IBOutlet UIButton *numberKey;

@property (strong, nonatomic) IBOutlet UIButton *space;

@property (strong, nonatomic) IBOutlet UIButton *returnKey;

-(void) setUpKeyboardKeys;

@end
