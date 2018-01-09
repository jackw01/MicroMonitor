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

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, JJDualGraphStyle) {
    
    JJDualGraphStyleOverlay = 0,
    JJDualGraphStyleCentered
};

IB_DESIGNABLE
@interface JJDualGraphView : NSView

@property float minimum;
@property float maximum1;
@property float maximum2;

@property int maxValues;

@property BOOL automaticMaximum;
@property NSInteger style;

@property NSMutableArray *data1;
@property NSMutableArray *data2;

@property IBInspectable NSColor *strokeColor1;
@property IBInspectable NSColor *fillColor1;
@property IBInspectable NSColor *strokeColor2;
@property IBInspectable NSColor *fillColor2;
@property IBInspectable NSColor *borderColor;

- (void)pushValues:(NSArray *)values;

@end
