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

#import "JJLevelIndicator.h"

@implementation JJLevelIndicator

// Prepare for IB
- (void)prepareForInterfaceBuilder {
    
    self.minimum = 0;
    self.maximum = 100;
    self.value = 50;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if (self.value < self.minimum) {
        
        self.value = self.minimum;
    }
    
    if (self.value > self.maximum) {
        
        self.value = self.maximum;
    }
    
    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.origin.x + 0.5, self.bounds.origin.y + 0.5, self.bounds.size.width - 1, self.bounds.size.height - 1) xRadius:2 yRadius:2];
    [borderPath setLineWidth:1.0f];
    
    // Calculate width of bar
    float portionWidth = (self.value - self.minimum) * (self.bounds.size.width - 4) / (self.maximum - self.minimum);
    
    NSBezierPath *drawPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.origin.x + 0.5, self.bounds.origin.y + 0.5, portionWidth, self.bounds.size.height - 1) xRadius:1 yRadius:1];
    
    [self.fillColor setFill];
    [drawPath fill];
    
    drawPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(portionWidth + 0.5, 0, 1.5, self.bounds.size.height - 1) xRadius:1 yRadius:1];
    
    [self.borderColor setFill];
    [drawPath fill];
    
    // Draw the bezel
    [self.borderColor setStroke];
    [borderPath stroke];
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"fillColor"] || [keyPath isEqualToString:@"borderColor"] || [keyPath isEqualToString:@"minimum"] || [keyPath isEqualToString:@"maximum"] || [keyPath isEqualToString:@"value"]) {
        [self setNeedsDisplay:YES];
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


@end
