//
//  CGEventHandler.h
//  GamePadDocker
//
//  Created by David Lewis on 11/30/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

@import Foundation;

@interface CGEventHandler : NSObject
@property (strong,nonatomic) NSMutableData *keyState;
@property (strong, nonatomic) NSMutableDictionary *gamepadConfigurations;

- (void)updateState:(NSData *)gamepadState;
- (void)updateConfig:(NSDictionary *)configurations;
@end
