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

#import "JJGraphView.h"

@implementation JJGraphView

- (id)initWithFrame:(NSRect)frameRect {
    
    if (self = [super initWithFrame:frameRect]) {
        
        self.data = [[NSMutableArray alloc] init];
    
        self.minimum = 0.0;
        self.maximum = 100.0;
        self.maxValues = 50;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    if (self = [super initWithCoder:coder]) {
        
        self.data = [[NSMutableArray alloc] init];
        
        self.minimum = 0.0;
        self.maximum = 100.0;
        self.maxValues = 50;
    }
    
    return self;
}

// Prepare for IB
- (void)prepareForInterfaceBuilder {
    
    self.minimum = 0.0;
    self.maximum = 100.0;
    self.maxValues = 50;
    
    for (int i = 0; i < 50; i++)
        [self.data addObject: [NSNumber numberWithInt: arc4random()%60 + 20]];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if ([self.data count] > 1) {
        
        NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.origin.x + 0.5, self.bounds.origin.y + 0.5, self.bounds.size.width - 1, self.bounds.size.height - 1) xRadius:2 yRadius:2];
        [borderPath setLineWidth:1.0f];
        
        float ptsPerDataPoint = self.bounds.size.width / self.maxValues;
        
        NSBezierPath *drawPath = [NSBezierPath bezierPath];
        
        [drawPath moveToPoint:NSMakePoint(self.bounds.origin.x + 1 + self.bounds.size.width - ((0) * ptsPerDataPoint), (([self.data[0] floatValue] - self.minimum) * (self.bounds.size.height - 2) / (self.maximum - self.minimum)) + 1)];
        
        for (int i = 1; i < [self.data count]; i++) {
            
            if ([self.data[i] floatValue] == NAN) {
                
                self.data[i] = [NSNumber numberWithFloat:1.0];
            }
            
            if ([self.data[i] floatValue] > self.maximum) {
                
                self.data[i] = [NSNumber numberWithFloat:self.maximum];
            }
            
            if ([self.data[i] floatValue] < self.minimum) {
                
                self.data[i] = [NSNumber numberWithFloat:self.minimum];
            }
            
            [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + 1 + self.bounds.size.width - ((i) * ptsPerDataPoint), (([self.data[i] floatValue] - self.minimum) * (self.bounds.size.height - 2) / (self.maximum - self.minimum)) + 1)];
        }
        
        [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + 0.5 + self.bounds.size.width - ([self.data count] * ptsPerDataPoint), 1.5f)];
         
        [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + 0.5 + self.bounds.size.width, 1.5f)];

        [drawPath closePath];
        
        [self.fillColor setFill];
        [drawPath fill];
        
        [self.strokeColor setStroke];
        [drawPath stroke];
        
        [self.borderColor setStroke];
        [borderPath stroke];
    }
}

- (void)pushValue:(NSNumber *)value {
    
    if (!isnan([value floatValue])) {
        
        [self.data insertObject:value atIndex:0];
        
        if ([self.data count] > self.maxValues) {
            
            [self.data removeLastObject];
        }
        
        [self setNeedsDisplay:YES];
    }
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"strokeColor"] || [keyPath isEqualToString:@"fillColor"] || [keyPath isEqualToString:@"borderColor"] || [keyPath isEqualToString:@"minimum"] || [keyPath isEqualToString:@"maximum"] || [keyPath isEqualToString:@"maxValues"]) {
        [self setNeedsDisplay:YES];
    }

    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
