//
//  CGEventHandler.m
//  GamePadDocker
//
//  Created by David Lewis on 11/30/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import "CGEventHandler.h"

@implementation CGEventHandler {
    CGEventSourceRef eventSource;
//    CGEventRef aButtonEventRef, bButtonEventRef, xButtonEventRef, yButtonEventRef, startButtonEventRef, selectButtonEventRef;
    CGEventRef aButtonDownEventRef, bButtonDownEventRef, xButtonDownEventRef, yButtonDownEventRef, startButtonDownEventRef, selectButtonDownEventRef, aButtonUpEventRef, bButtonUpEventRef, xButtonUpEventRef, yButtonUpEventRef, startButtonUpEventRef, selectButtonUpEventRef, mouseMoveYEventRef, mouseMoveXEventRef;
    CGPoint mouseLocation;
    CGRect screenResolution;
    NSNumber *mouseSensitivity;
    BOOL aButtonState, bButtonState, xButtonState, yButtonState, startButtonState, selectButtonState, dPadUpState, dPadDownState, dPadLeftState, dPadRightState;
}

- (id)init  {
    if (self = [super init]) {
        eventSource = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    }
    screenResolution = [[NSScreen mainScreen] frame];
    mouseLocation = [NSEvent mouseLocation];
    NSLog(@"Mouse Position x:%f y:%f", mouseLocation.x, mouseLocation.y);
    NSLog(@"Screen Size x:%f y:%f", screenResolution.size.width, screenResolution.size.height);
    mouseSensitivity = [NSNumber numberWithInt:3];
    return self;
}

- (void)updateState:(NSData *)gamepadState {
    self.keyState = [NSMutableData dataWithData:gamepadState];
    [self processJoyPadState:*(GamepadState *)self.keyState.bytes];
    [self updateMousePosition:*(GamepadState *)self.keyState.bytes];
}

- (void)processJoyPadState:(GamepadState)currentState {
    short int stateFlags = currentState.stateFlags;
    short int aState, bState, xState, yState, startState, selectState, dUp, dDown, dLeft, dRight;
    
    /* Here we get our new states and check them against the old. 
     If our new state is different from our previous state, we should
     either begin or end the corresponding key event. */
    
    aState = stateFlags & A_BUTTON_MASK;
    if (aState > 0){
        aState = 1;
        if (aButtonState == NO)
            [self beginKeyEvent:(CGKeyCode)self.gamepadConfigurations.a];
        aButtonState = YES;
    } else {
        aState = 0;
        if (aButtonState == YES)
            [self endKeyEvent:(CGKeyCode)self.gamepadConfigurations.a];
        aButtonState  = NO;
    }
    
    bState = stateFlags & B_BUTTON_MASK;
    if (bState > 0) {
        bState = 1;
        if (bButtonState == NO)
            [self beginKeyEvent:(CGKeyCode)self.gamepadConfigurations.b];
        bButtonState = YES;
    } else {
        bState = 0;
        if (bButtonState == YES)
            [self endKeyEvent:(CGKeyCode)self.gamepadConfigurations.b];

        bButtonState = NO;
    }
    
    xState = stateFlags & X_BUTTON_MASK;
    if (xState > 0) {
        xState = 1;
        if (xButtonState == NO)
            [self beginKeyEvent:(CGKeyCode)self.gamepadConfigurations.x];
        xButtonState = YES;
    } else {
        xState = 0;
        if (xButtonState == YES)
            [self endKeyEvent:(CGKeyCode)self.gamepadConfigurations.x];
        xButtonState = NO;
    }
    
    yState = stateFlags & Y_BUTTON_MASK;
    if (yState > 0) {
        yState = 1;
        if (yButtonState == NO)
            [self beginKeyEvent:(CGKeyCode)self.gamepadConfigurations.y];
        yButtonState = YES;
    } else {
        yState = 0;
        if (yButtonState == YES)
            [self endKeyEvent:(CGKeyCode)self.gamepadConfigurations.y];
        yButtonState = NO;
    }
    
    startState = stateFlags & START_BUTTON_MASK;
    if (startState > 0) {
        startState = 1;
        if (startButtonState == NO)
            [self beginKeyEvent:(CGKeyCode)self.gamepadConfigurations.start];
        startButtonState = YES;
    } else {
        startState = 0;
        if (startButtonState == YES)
            [self endKeyEvent:(CGKeyCode)self.gamepadConfigurations.start];
        startButtonState = NO;
    }
    
    selectState = stateFlags & SELECT_BUTTON_MASK;
    if (selectState > 0) {
        selectState = 1;
        if (startButtonState == NO)
            [self beginKeyEvent:(CGKeyCode)self.gamepadConfigurations.start];
        selectButtonState = YES;
    } else {
        selectState = 0;
        if (startButtonState == YES)
            [self endKeyEvent:(CGKeyCode)self.gamepadConfigurations.start];
        selectButtonState = NO;
    }
    
    dUp = stateFlags & DPAD_UP_MASK;
    if (dUp > 0) {
        dUp = 1;
        if (dPadUpState == NO)
            [self beginKeyEvent:(CGKeyCode)self.gamepadConfigurations.dpadUp];
        dPadUpState = YES;
    } else {
        dUp = 0;
        if (dPadUpState == YES)
            [self endKeyEvent:(CGKeyCode)self.gamepadConfigurations.dpadUp];
        dPadUpState = NO;
    }
    
    dDown = stateFlags & DPAD_DOWN_MASK;
    if (dDown > 0) {
        dDown = 1;
        if (dPadDownState == NO)
            [self beginKeyEvent:(CGKeyCode)self.gamepadConfigurations.dpadDown];
        dPadDownState = YES;
    } else {
        dDown = 0;
        if (dPadDownState == YES)
            [self endKeyEvent:(CGKeyCode)self.gamepadConfigurations.dpadDown];
        dPadDownState = NO;
    }
    
    dLeft = stateFlags & DPAD_LEFT_MASK;
    if (dLeft > 0) {
        dLeft = 1;
        if (dPadLeftState == NO)
            [self beginKeyEvent:(CGKeyCode)self.gamepadConfigurations.dpadLeft];
        dPadLeftState = YES;
    } else {
        dLeft = 0;
        if (dPadLeftState == YES)
            [self endKeyEvent:(CGKeyCode)self.gamepadConfigurations.dpadLeft];
        dPadLeftState = NO;
    }
    
    dRight = stateFlags & DPAD_RIGHT_MASK;
    if (dRight > 0) {
        dRight = 1;
        if (dPadRightState == NO)
            [self beginKeyEvent:(CGKeyCode)self.gamepadConfigurations.dpadRight];
        dPadRightState = YES;
    } else {
        dRight = 0;
        if (dPadRightState == YES)
            [self endKeyEvent:(CGKeyCode)self.gamepadConfigurations.dpadRight];
        dPadRightState = NO;
    }
    
    NSLog(@"deltaX: %6.2f\t\tdeltaY: %6.2f", currentState.deltaX, currentState.deltaY);
    NSLog(@"%d %d %d %d %d %d %d %d %d %d", dRight, dLeft, dDown, dUp, selectState, startState, yState, xState, bState, aState);
}

- (void)updateMousePosition:(GamepadState)currentState {
    float deltaX = currentState.deltaX, deltaY=currentState.deltaY;
    if (deltaX == 0 && deltaY == 0)
        return;
    
    CGPoint newMousePosition = mouseLocation;
    
    newMousePosition.x += (int)deltaX / [mouseSensitivity intValue];
    newMousePosition.y += (int)deltaY / [mouseSensitivity intValue];
    mouseMoveYEventRef = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, CGPointMake(newMousePosition.x, newMousePosition.y), kCGMouseButtonLeft);
    mouseMoveXEventRef = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, CGPointMake(newMousePosition.x, newMousePosition.x), kCGMouseButtonLeft);
    CGEventPost(kCGHIDEventTap, mouseMoveXEventRef);
    CGEventPost(kCGHIDEventTap, mouseMoveYEventRef);
    CFRelease(mouseMoveXEventRef);
    CFRelease(mouseMoveYEventRef);
    NSLog(@"NewMouse X:%f\tY:%f", newMousePosition.x, newMousePosition.y);
    mouseLocation = newMousePosition;
}

- (void)updateConfig:(NSData *)configurations {
    GamepadConfiguration currentConfiguration = self.gamepadConfigurations;
    GamepadConfiguration *currentConfigPtr = &currentConfiguration;
    [configurations getBytes:currentConfigPtr length:sizeof(GamepadConfiguration)];
    [self compareAndUpdateCGEventRefs:self.gamepadConfigurations against:currentConfiguration];
    self.gamepadConfigurations = currentConfiguration;
}

- (void)compareAndUpdateCGEventRefs:(GamepadConfiguration)previousConfiguration against:(GamepadConfiguration)newConfiguration {
    if (previousConfiguration.a != newConfiguration.a) {
        if (aButtonDownEventRef != 0)
            CFRelease(aButtonDownEventRef);
        if (aButtonUpEventRef != 0)
            CFRelease(aButtonUpEventRef);
    }
    if (previousConfiguration.b != newConfiguration.b) {
        if (bButtonDownEventRef != 0)
            CFRelease(bButtonDownEventRef);
        if (bButtonUpEventRef != 0)
            CFRelease(bButtonUpEventRef);
    }
    if (previousConfiguration.x != newConfiguration.x) {
        if (xButtonDownEventRef != 0)
            CFRelease(xButtonDownEventRef);
        if (xButtonUpEventRef != 0)
            CFRelease(xButtonUpEventRef);
    }
    if (previousConfiguration.y != newConfiguration.y) {
        if (yButtonDownEventRef != 0)
            CFRelease(yButtonDownEventRef);
        if (yButtonUpEventRef != 0)
            CFRelease(yButtonUpEventRef);
    }
    if (previousConfiguration.start != newConfiguration.start) {
        if (startButtonDownEventRef != 0)
            CFRelease(startButtonDownEventRef);
        if (startButtonUpEventRef != 0)
            CFRelease(startButtonUpEventRef);
    }
    if (previousConfiguration.select != newConfiguration.select) {
        if (selectButtonDownEventRef != 0)
            CFRelease(selectButtonDownEventRef);
        if (selectButtonUpEventRef != 0)
            CFRelease(selectButtonUpEventRef);
    }
}

- (void)beginKeyEvent:(CGKeyCode)keyCode {
    if (keyCode == self.gamepadConfigurations.a) {
        aButtonDownEventRef = CGEventCreateKeyboardEvent(NULL, keyCode, true);
        CGEventPost(kCGHIDEventTap, aButtonDownEventRef);
    } else if (keyCode == self.gamepadConfigurations.b) {
        bButtonDownEventRef = CGEventCreateKeyboardEvent(NULL, keyCode, true);
        CGEventPost(kCGHIDEventTap, bButtonDownEventRef);
    } else if (keyCode == self.gamepadConfigurations.x) {
        xButtonDownEventRef = CGEventCreateKeyboardEvent(NULL, keyCode, true);
        CGEventPost(kCGHIDEventTap, xButtonDownEventRef);
    } else if (keyCode == self.gamepadConfigurations.y) {
        yButtonDownEventRef = CGEventCreateKeyboardEvent(NULL, keyCode, true);
        CGEventPost(kCGHIDEventTap, yButtonDownEventRef);
    } else if (keyCode == self.gamepadConfigurations.start) {
        startButtonDownEventRef = CGEventCreateKeyboardEvent(NULL, keyCode, true);
        CGEventPost(kCGHIDEventTap, startButtonDownEventRef);
    } else if (keyCode == self.gamepadConfigurations.select) {
        selectButtonDownEventRef = CGEventCreateKeyboardEvent(NULL, keyCode, true);
        CGEventPost(kCGHIDEventTap, selectButtonDownEventRef);
    }
    /*
    // Only necessary if the directional pad doesn't activate mouse events
    else if (keyCode == self.gamepadConfigurations.dpadUp) {
     
    } else if (keyCode == self.gamepadConfigurations.dpadDown) {
        
    } else if (keyCode == self.gamepadConfigurations.dpadLeft) {
        
    } else if (keyCode == self.gamepadConfigurations.dpadRight) {
        
    } 
     */
}

- (void)endKeyEvent:(CGKeyCode)keyCode {
    if (keyCode == self.gamepadConfigurations.a) {
        aButtonUpEventRef = CGEventCreateKeyboardEvent(NULL, keyCode, false);
        CGEventPost(kCGSessionEventTap, aButtonUpEventRef);
    } else if (keyCode == self.gamepadConfigurations.b) {
        bButtonUpEventRef = CGEventCreateKeyboardEvent(NULL, keyCode, false);
        CGEventPost(kCGSessionEventTap, bButtonUpEventRef);
    } else if (keyCode == self.gamepadConfigurations.x) {
        xButtonUpEventRef = CGEventCreateKeyboardEvent(NULL, keyCode, false);
        CGEventPost(kCGSessionEventTap, xButtonUpEventRef);
    } else if (keyCode == self.gamepadConfigurations.y) {
        yButtonUpEventRef = CGEventCreateKeyboardEvent(NULL, keyCode, false);
        CGEventPost(kCGSessionEventTap, yButtonUpEventRef);
    } else if (keyCode == self.gamepadConfigurations.start) {
        startButtonUpEventRef = CGEventCreateKeyboardEvent(NULL, keyCode, false);
        CGEventPost(kCGSessionEventTap, startButtonUpEventRef);
    } else if (keyCode == self.gamepadConfigurations.select) {
        selectButtonUpEventRef = CGEventCreateKeyboardEvent(NULL, keyCode, false);
        CGEventPost(kCGSessionEventTap, selectButtonUpEventRef);
    }
    /*
     // Only necessary if the directional pad doesn't activate mouse events
     else if (keyCode == self.gamepadConfigurations.dpadUp) {
     
     } else if (keyCode == self.gamepadConfigurations.dpadDown) {
     
     } else if (keyCode == self.gamepadConfigurations.dpadLeft) {
     
     } else if (keyCode == self.gamepadConfigurations.dpadRight) {
     
     }
     */

}
@end
