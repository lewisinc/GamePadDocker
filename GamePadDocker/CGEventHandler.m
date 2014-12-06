//
//  CGEventHandler.m
//  GamePadDocker
//
//  Created by David Lewis on 11/30/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import "CGEventHandler.h"
typedef uint16_t CGKeyCode;

@implementation CGEventHandler {
    CGEventSourceRef eventSource;
    CGKeyCode aButton, bButton, xButton, yButton, startButton, selectButton;
    
}

- (id)init  {
    if (self = [super init]) {
        eventSource = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    }
    return self;
}
- (void)updateState:(NSData *)gamepadState {
    
//    CGEventRef saveCommandDown = CGEventCreateKeyboardEvent(source, (CGKeyCode)1, YES);
//    CGEventSetFlags(saveCommandDown, kCGEventFlagMaskCommand);
//    CGEventRef saveCommandUp = CGEventCreateKeyboardEvent(source, (CGKeyCode)1, NO);
//    
//    CGEventPost(kCGAnnotatedSessionEventTap, saveCommandDown);
//    CGEventPost(kCGAnnotatedSessionEventTap, saveCommandUp);
//    
//    CFRelease(saveCommandUp);
//    CFRelease(saveCommandDown);
}
- (void)updateConfig:(NSDictionary *)configurations {
    self.gamepadConfigurations = [NSMutableDictionary dictionaryWithDictionary:configurations];

}
- (void)done {
    CFRelease(eventSource);
}
@end
