//
// Copyright (C) 2015-2016 jackw01.
//
// This file is part of MicroMonitor.
//
// MicroMonitor is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// MicroMonitor is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with MicroMonitor. If not, see <http://www.gnu.org/licenses/>.
//

#import "MMMemoryLevelIndicator.h"

@implementation MMMemoryLevelIndicator

// Prepare for IB
- (void)prepareForInterfaceBuilder {
    
    self.minimum = 0;
    self.maximum = 8.0;
    self.value = 6.5;
    self.valueActive = 2.0;
    self.valueWired = 1.0;
    self.valueCompressed = 1.5;
    self.valueInactive = 2.0;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if (self.valueActive != 0 && self.valueCompressed != 0 && self.valueInactive != 0 && self.valueWired != 0) {
    
        NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.origin.x + 0.5, self.bounds.origin.y + 0.5, self.bounds.size.width - 1, self.bounds.size.height - 1) xRadius:2 yRadius:2];
        [borderPath setLineWidth:1.0f];
        
        // Calculate the widths of sections representing each memory segment
        float locationActive = (self.valueActive - self.minimum) * self.bounds.size.width / (self.maximum - self.minimum);
        float locationWired = (self.valueWired - self.minimum) * self.bounds.size.width / (self.maximum - self.minimum);
        float locationCompressed = (self.valueCompressed - self.minimum) * self.bounds.size.width / (self.maximum - self.minimum);
        float locationInactive = (self.valueInactive - self.minimum) * self.bounds.size.width / (self.maximum - self.minimum);
        
        // Draw used memory
        NSBezierPath *drawPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(0.5, 0.5, locationActive, self.bounds.size.height - 1) xRadius:1 yRadius:1];
        
        [self.fillColorActive setFill];
        [drawPath fill];
        
        drawPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(locationActive + 1.5, 0.5, locationWired, self.bounds.size.height - 1) xRadius:1 yRadius:1];
        
        [self.fillColorWired setFill];
        [drawPath fill];
        
        drawPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(locationActive + locationWired + 2.5, 0.5, locationCompressed, self.bounds.size.height - 1) xRadius:1 yRadius:1];
        
        [self.fillColorCompressed setFill];
        [drawPath fill];
        
        drawPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(locationActive + locationWired + locationCompressed + 3.5, 0, locationInactive, self.bounds.size.height - 1) xRadius:1 yRadius:1];
        
        [self.fillColorInactive setFill];
        [drawPath fill];

        // Draw separators
        drawPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(locationActive + 0.5, 0.5, 1.5, self.bounds.size.height - 1) xRadius:1 yRadius:1];
        
        [self.borderColor setFill];
        [drawPath fill];
        
        drawPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(locationActive + locationWired + 1.5, 0.5, 1.5, self.bounds.size.height - 1) xRadius:1 yRadius:1];
        
        [drawPath fill];
        
        drawPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(locationActive + locationWired + locationCompressed + 2.5, 0, 1.5, self.bounds.size.height - 1) xRadius:1 yRadius:1];
        
        [drawPath fill];
        
        drawPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(locationActive + locationWired + locationCompressed + locationInactive + 3.5, 0, 1.5, self.bounds.size.height - 1) xRadius:1 yRadius:1];
        
        [drawPath fill];
        
        // Draw the bezel
        [self.borderColor setStroke];
        [borderPath stroke];
        
        // Preload images
        NSImage *a = [NSImage imageNamed:@"MMIconActive"];
        NSImage *i = [NSImage imageNamed:@"MMIconInactive"];
        NSImage *w = [NSImage imageNamed:@"MMIconWired"];
        NSImage *c = [NSImage imageNamed:@"MMIconCompressed"];
        
        // Draw labels
        if (locationActive >= (self.bounds.size.width / 40)) {
            
            [a drawAtPoint:CGPointMake(3, (self.bounds.size.height - a.size.height) / 2) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
        }
        
        if (locationWired >= (self.bounds.size.width / 40)) {
            
            [w drawAtPoint:CGPointMake(locationActive + 4, (self.bounds.size.height - w.size.height) / 2) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
        }
        
        if (locationCompressed >= (self.bounds.size.width / 40)) {
            
            [c drawAtPoint:CGPointMake(locationActive + locationWired + 5, (self.bounds.size.height - c.size.height) / 2) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
        }
        
        if (locationInactive >= (self.bounds.size.width / 40)) {
            
            [i drawAtPoint:CGPointMake(locationActive + locationWired + locationCompressed + 6, (self.bounds.size.height - i.size.height) / 2) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
        }
    }
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"fillColor"] || [keyPath isEqualToString:@"borderColor"] || [keyPath isEqualToString:@"minimum"] || [keyPath isEqualToString:@"maximum"] || [keyPath isEqualToString:@"value"] || [keyPath isEqualToString:@"valueActive"] || [keyPath isEqualToString:@"valueInactive"] || [keyPath isEqualToString:@"valueWired"] || [keyPath isEqualToString:@"valueCompressed"]) {
        [self setNeedsDisplay:YES];
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
