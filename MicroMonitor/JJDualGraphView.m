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

#import "JJDualGraphView.h"

@implementation JJDualGraphView

- (id)initWithFrame:(NSRect)frameRect {
    
    if (self = [super initWithFrame:frameRect]) {
        
        self.data1 = [[NSMutableArray alloc] init];
        self.data2 = [[NSMutableArray alloc] init];
        
        self.automaticMaximum = NO;
        self.style = JJDualGraphStyleOverlay;
        self.minimum = 0.0;
        self.maximum1 = 100.0;
        self.maximum2 = 100.0;
        self.maxValues = 50;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    if (self = [super initWithCoder:coder]) {
        
        self.data1 = [[NSMutableArray alloc] init];
        self.data2 = [[NSMutableArray alloc] init];
        
        self.automaticMaximum = NO;
        self.style = JJDualGraphStyleOverlay;
        self.minimum = 0.0;
        self.maximum1 = 100.0;
        self.maximum2 = 100.0;
        self.maxValues = 50;
    }
    
    return self;
}

// Prepare for IB

- (void)prepareForInterfaceBuilder {
    
    self.automaticMaximum = NO;
    self.style = JJDualGraphStyleOverlay;
    
    self.minimum = 0.0;
    self.maximum1 = 100.0;
    self.maximum2 = 100.0;
    self.maxValues = 50;
    
    for (int i = 0; i < 50; i++)
        [self.data1 addObject: [NSNumber numberWithInt: arc4random()%60 + 20]];
    
    for (int i = 0; i < 50; i++)
        [self.data2 addObject: [NSNumber numberWithInt: arc4random()%60 + 20]];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.origin.x + 0.5, self.bounds.origin.y + 0.5, self.bounds.size.width - 1, self.bounds.size.height - 1) xRadius:2 yRadius:2];
    [borderPath setLineWidth:1.0f];
    
    if (self.style == JJDualGraphStyleOverlay) {
        
        if ([self.data1 count] > 1) {
            
            float ptsPerDataPoint = self.bounds.size.width / self.maxValues;
            
            NSBezierPath *drawPath = [NSBezierPath bezierPath];
            
            [drawPath moveToPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width - ((0) * ptsPerDataPoint), (([self.data1[0] floatValue] - self.minimum) * (self.bounds.size.height - 2) / (self.maximum1 - self.minimum)) + 1)];
            
            for (int i = 1; i < [self.data1 count]; i++) {
                
                if ([self.data1[i] floatValue] == NAN) {
                    
                    self.data1[i] = [NSNumber numberWithFloat:1.0];
                }
                
                if ([self.data1[i] floatValue] > self.maximum1) {
                    
                    self.data1[i] = [NSNumber numberWithFloat:self.maximum1];
                }
                
                if ([self.data1[i] floatValue] < self.minimum) {
                    
                    self.data1[i] = [NSNumber numberWithFloat:self.minimum];
                }
                
                [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width - ((i) * ptsPerDataPoint), (([self.data1[i] floatValue] - self.minimum) * ((self.bounds.size.height) - 2) / (self.maximum1 - self.minimum)) + 1)];
            }
            
            [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width - ([self.data1 count] * ptsPerDataPoint), 1.5f)];
            
            [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width, 1.5f)];
            
            [drawPath closePath];
            
            [self.fillColor1 setFill];
            [drawPath fill];
            
            [self.strokeColor1 setStroke];
            [drawPath stroke];
        }
        
        if ([self.data2 count] > 1) {
            
            float ptsPerDataPoint = self.bounds.size.width / self.maxValues;
            
            NSBezierPath *drawPath = [NSBezierPath bezierPath];
            
            [drawPath moveToPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width - ((0) * ptsPerDataPoint), (([self.data2[0] floatValue] - self.minimum) * (self.bounds.size.height - 2) / (self.maximum2 - self.minimum)) + 1)];
            
            for (int i = 1; i < [self.data2 count]; i++) {
                
                if ([self.data2[i] floatValue] == NAN) {
                    
                    self.data2[i] = [NSNumber numberWithFloat:1.0];
                }
                
                if ([self.data2[i] floatValue] > self.maximum2) {
                    
                    self.data2[i] = [NSNumber numberWithFloat:self.maximum2];
                }
                
                if ([self.data2[i] floatValue] < self.minimum) {
                    
                    self.data2[i] = [NSNumber numberWithFloat:self.minimum];
                }
                
                [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width - ((i) * ptsPerDataPoint), (([self.data2[i] floatValue] - self.minimum) * ((self.bounds.size.height) - 2) / (self.maximum1 - self.minimum)) + 1)];
            }
            
            [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width - ([self.data2 count] * ptsPerDataPoint), 1.5f)];
            
            [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width, 1.5f)];
            
            [drawPath closePath];
            
            [self.fillColor2 setFill];
            [drawPath fill];
            
            [self.strokeColor2 setStroke];
            [drawPath stroke];
        }
    }
    
    if (self.style == JJDualGraphStyleCentered) {
        
        if ([self.data1 count] > 1) {
            
            float ptsPerDataPoint = self.bounds.size.width / self.maxValues;
            
            NSBezierPath *drawPath = [NSBezierPath bezierPath];
            
            [drawPath moveToPoint:NSMakePoint(self.bounds.origin.x + 1 + self.bounds.size.width - ((0) * ptsPerDataPoint), (([self.data1[0] floatValue] - self.minimum) * (self.bounds.size.height - 2) / (self.maximum1 - self.minimum)) + 1)];
            
            for (int i = 1; i < [self.data1 count]; i++) {
                
                if ([self.data1[i] floatValue] == NAN) {
                    
                    self.data1[i] = [NSNumber numberWithFloat:1.0];
                }
                
                if ([self.data1[i] floatValue] > self.maximum1) {
                    
                    self.data1[i] = [NSNumber numberWithFloat:self.maximum1];
                }
                
                if ([self.data1[i] floatValue] < self.minimum) {
                    
                    self.data1[i] = [NSNumber numberWithFloat:self.minimum];
                }
                
                [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + 1 + self.bounds.size.width - ((i) * ptsPerDataPoint), (([self.data1[i] floatValue] - self.minimum) * ((self.bounds.size.height / 2) - 2) / (self.maximum1 - self.minimum)) + 1 + (self.bounds.size.height / 2))];
            }
            
            [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + 0.5 + self.bounds.size.width - ([self.data1 count] * ptsPerDataPoint), (self.bounds.size.height / 2))];
            
            [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + 0.5 + self.bounds.size.width, (self.bounds.size.height / 2))];
            
            [drawPath closePath];
            
            [self.fillColor1 setFill];
            [drawPath fill];
            
            [self.strokeColor1 setStroke];
            [drawPath stroke];
        }
        
        if ([self.data2 count] > 1) {
            
            float ptsPerDataPoint = self.bounds.size.width / self.maxValues;
            
            NSBezierPath *drawPath = [NSBezierPath bezierPath];
            
            [drawPath moveToPoint:NSMakePoint(self.bounds.origin.x + 1 + self.bounds.size.width - ((0) * ptsPerDataPoint), (([self.data2[0] floatValue] - self.minimum) * (self.bounds.size.height - 2) / (self.maximum2 - self.minimum)) + 1)];
            
            for (int i = 1; i < [self.data2 count]; i++) {
                
                if ([self.data2[i] floatValue] == NAN) {
                    
                    self.data2[i] = [NSNumber numberWithFloat:1.0];
                }
                
                if ([self.data2[i] floatValue] > self.maximum2) {
                    
                    self.data2[i] = [NSNumber numberWithFloat:self.maximum2];
                }
                
                if ([self.data2[i] floatValue] < self.minimum) {
                    
                    self.data2[i] = [NSNumber numberWithFloat:self.minimum];
                }
                
                [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + 1 + self.bounds.size.width - ((i) * ptsPerDataPoint), -1 * ((([self.data2[i] floatValue] - self.minimum) * ((self.bounds.size.height / 2) - 2) / (self.maximum2 - self.minimum)) + 1) + (self.bounds.size.height / 2))];
            }
            
            [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + 0.5 + self.bounds.size.width - ([self.data2 count] * ptsPerDataPoint), (self.bounds.size.height / 2))];
            
            [drawPath lineToPoint:NSMakePoint(self.bounds.origin.x + 0.5 + self.bounds.size.width, (self.bounds.size.height / 2))];
            
            [drawPath closePath];
            
            [self.fillColor2 setFill];
            [drawPath fill];
            
            [self.strokeColor2 setStroke];
            [drawPath stroke];
        }
    }
    
    [self.borderColor setStroke];
    [borderPath stroke];
}

- (void)pushValues:(NSArray *)values {
    
    if (!isnan([values[0] floatValue])) {
        
        [self.data1 insertObject:values[0] atIndex:0];
        
        if ([self.data1 count] > self.maxValues) {
            
            [self.data1 removeLastObject];
        }
    }
    
    if (!isnan([values[1] floatValue])) {
        
        [self.data2 insertObject:values[1] atIndex:0];
        
        if ([self.data2 count] > self.maxValues) {
            
            [self.data2 removeLastObject];
        }
    }
    
    if (self.automaticMaximum == YES) {
    
        long double max = 0.001;
        
        for (NSNumber *value in self.data1) {
            
            if ([value doubleValue] > max) {
                
                max = [value doubleValue];
            }
        }
        
        self.maximum1 = max;
        
        max = 0.001;
        
        for (NSNumber *value in self.data2) {
            
            if ([value doubleValue] > max) {
                
                max = [value doubleValue];
            }
        }
        
        self.maximum2 = max;
    }
    
    [self setNeedsDisplay:YES];
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"minimum"] || [keyPath isEqualToString:@"maximum1"] || [keyPath isEqualToString:@"maximum2"] || [keyPath isEqualToString:@"maxValues"]) {
        [self setNeedsDisplay:YES];
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
