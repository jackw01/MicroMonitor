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

#import "JJBox.h"

@implementation JJBox

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSBezierPath *rect;
    
    if (self.cornerRadius == 0) {
        
        rect = [NSBezierPath bezierPathWithRect:CGRectMake(self.bounds.origin.x + 0.5f, self.bounds.origin.y + 0.5f, self.bounds.size.width - 1.0f, self.bounds.size.height - 1.0f)];
    } else {
        
        rect = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.origin.x + 0.5f, self.bounds.origin.y + 0.5f, self.bounds.size.width - 1.0f, self.bounds.size.height - 1.0f) xRadius:self.cornerRadius yRadius:self.cornerRadius];
    }
    
    [self.fillColor setFill];
    [rect fill];
    
    [self.strokeColor setStroke];
    [rect stroke];
}

@end
