//
//  NunchuckKeyboard.h
//  CustomKeyboard
//
//  Created by Chris Wong on 1/19/14.
//  Copyright (c) 2014 Chris Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NunchuckKeyboard : UIViewController

@property (nonatomic, weak) id delegate;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keys;

- (IBAction)keySwipedEnter:(UIButton *)sender;

- (IBAction)keySwipedOutside:(UIButton *)sender;

- (IBAction)keySwipedCancel:(UIButton *)sender;


@end
