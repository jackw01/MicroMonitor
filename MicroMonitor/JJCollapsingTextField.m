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

#import "JJCollapsingTextField.h"

@implementation JJCollapsingTextField

- (void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
}

- (CGSize)intrinsicContentSize {
    
    if (self.isHidden) {
        
        return CGSizeMake(NSViewNoInstrinsicMetric, 0.0f);
        
    } else {
        
        return [super intrinsicContentSize];
    }
}

- (void)setHidden:(BOOL)hidden {
    
    [super setHidden:hidden];
    
    [self updateConstraintsForSubtreeIfNeeded];
    [self layoutSubtreeIfNeeded];
}

@end