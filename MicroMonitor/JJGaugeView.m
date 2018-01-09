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

#import "JJGaugeView.h"

#define DEGREES_TO_RADIANS(x) (x * M_PI/180.0)

@implementation JJGaugeView

- (id)initWithFrame:(NSRect)frameRect {
    
    if (self = [super initWithFrame:frameRect]) {
        
        self.minimum = 0.0;
        self.maximum = 100.0;
        self.value = 50;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    if (self = [super initWithCoder:coder]) {
        
        self.minimum = 0.0;
        self.maximum = 100.0;
        self.value = 50;
    }
    
    return self;
}

// Prepare for IB
- (void)prepareForInterfaceBuilder {
    
    self.minimum = 0;
    self.maximum = 100;
    self.value = arc4random()%80 + 10;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Draw the track path
    NSBezierPath *trackPath = [NSBezierPath bezierPath];
    
    [trackPath appendBezierPathWithArcWithCenter:NSMakePoint(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:(self.bounds.size.width / 2) - self.trackMargin startAngle:-45 endAngle:225];
    
    [trackPath setLineWidth:self.trackWidth];
    [self.trackColor setStroke];
    [trackPath stroke];
    
    // Cap off the value to avoid misdrawing
    if (self.value <= self.minimum) {
        
        self.value = self.minimum;
    }
    
    if (self.value >= self.maximum) {
        
        self.value = self.maximum;
    }
    
    // Calculate the angle of the needle and add 135 because the default needle is pointed up
    float angle = (((self.value - self.minimum) * 270 / (self.maximum - self.minimum)) * -1) + 135;
    
    // Create the rotation transform using a custom matrix
    CGAffineTransform rotation = CGAffineTransformMakeRotationAt(DEGREES_TO_RADIANS(angle), CGPointMake(self.bounds.origin.x + (self.bounds.size.width / 2), (self.bounds.origin.y + (self.bounds.size.height / 2))));
    
    // Rotate the context
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    [NSGraphicsContext saveGraphicsState];
    
    CGContextConcatCTM(context, rotation);
    
    // Draw the needle path
    NSBezierPath *needlePath = [NSBezierPath bezierPath];
    
    [needlePath moveToPoint:NSMakePoint(self.bounds.size.width / 2, self.bounds.size.height)];
    [needlePath lineToPoint:NSMakePoint((self.bounds.size.width / 2) - self.needleWidth, self.bounds.size.height / 2)];
    [needlePath lineToPoint:NSMakePoint((self.bounds.size.width / 2) + self.needleWidth, self.bounds.size.height / 2)];
    [needlePath closePath];
    
    [self.needleColor setFill];
    [needlePath fill];
    
    // Restore the context state
    [NSGraphicsContext restoreGraphicsState];
}

CGAffineTransform CGAffineTransformMakeRotationAt(CGFloat angle, CGPoint pt) {
    
    // Create a custom transformation matrix for rotating around an origin
    const CGFloat fx = pt.x, fy = pt.y, fcos = cos(angle), fsin = sin(angle);
    
    return CGAffineTransformMake(fcos, fsin, -fsin, fcos, fx - fx * fcos + fy * fsin, fy - fx * fsin - fy * fcos);
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"minimum"] || [keyPath isEqualToString:@"maximum"] || [keyPath isEqualToString:@"value"]) {
        [self setNeedsDisplay:YES];
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
