//
//  CGEventHandler.h
//  GamePadDocker
//
//  Created by David Lewis on 11/30/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

@import Foundation;
@import Carbon;
@import AppKit;

//Gamepad State Masks
#define A_BUTTON_MASK       0x0001
#define B_BUTTON_MASK       0x0002
#define X_BUTTON_MASK       0x0004
#define Y_BUTTON_MASK       0x0008
#define START_BUTTON_MASK   0x0010
#define SELECT_BUTTON_MASK  0x0020
#define DPAD_UP_MASK        0x0040
#define DPAD_DOWN_MASK      0x0080
#define DPAD_LEFT_MASK      0x0100
#define DPAD_RIGHT_MASK     0x0200

typedef uint16_t CGKeyCode;

typedef struct {
    float deltaX, deltaY;
    short int stateFlags;
} GamepadState;

typedef struct {
    CGKeyCode a, b, x, y,
    start,
    select,
    dpadUp,
    dpadDown,
    dpadLeft,
    dpadRight;
} GamepadConfiguration;

typedef struct {
    float deltaX, deltaY;
} JoystickDelta;


@interface CGEventHandler : NSObject
@property (strong,nonatomic) NSMutableData *keyState;
@property (nonatomic) GamepadConfiguration gamepadConfigurations;

- (void)updateState:(NSData *)gamepadState;
- (void)updateConfig:(NSData *)configurations;
@end
