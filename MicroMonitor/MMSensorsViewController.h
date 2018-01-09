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

#import <SystemInfoKit/SystemInfoKit.h>

#import "MMSensor.h"

@interface MMSensorsViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (strong) JSKSMC *smc;

@property (strong) NSArray *workingSMCTempKeys;
@property NSUInteger numberOfFans;
@property (strong) NSArray *workingSMCCurrentKeys;
@property (strong) NSArray *workingSMCVoltageKeys;
@property (strong) NSArray *workingSMCPowerKeys;

@property (strong) IBOutlet NSArrayController *arrayController;
@property (strong) NSMutableArray *sensors;
@property (weak) IBOutlet NSTableView *sensorsTableView;

@property BOOL popoverOpen;

@end
