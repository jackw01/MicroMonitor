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

#import "MMContextualMenuButton.h"
#import "JJGraphView.h"
#import "JJDualGraphView.h"
#import "JJLevelIndicator.h"
#import "MMMemoryLevelIndicator.h"
#import "MMSensor.h"

@interface MMMonitorViewController : NSViewController

@property (strong) JSKDevice *device;
@property (strong) JSKSMC *smc;
@property (strong) JSKSystemMonitor *systemMonitor;

@property (strong) NSMutableArray *logSensors;

@property (weak) IBOutlet NSTextField *cpuUsageLabel;
@property (weak) IBOutlet NSTextField *cpuUserLabel;
@property (weak) IBOutlet NSTextField *cpuSystemLabel;
@property (weak) IBOutlet NSTextField *cpuIdleLabel;
@property (weak) IBOutlet NSTextField *uptimeLabel;
@property (weak) IBOutlet NSTextField *memoryUsageLabel;
@property (weak) IBOutlet NSTextField *activeMemoryLabel;
@property (weak) IBOutlet NSTextField *inactiveMemoryLabel;
@property (weak) IBOutlet NSTextField *wiredMemoryLabel;
@property (weak) IBOutlet NSTextField *compressedMemoryLabel;
@property (weak) IBOutlet NSTextField *diskUsageLabel;
@property (weak) IBOutlet NSTextField *dataSentLabel;
@property (weak) IBOutlet NSTextField *dataReceivedLabel;
@property (weak) IBOutlet NSTextField *uploadSpeedLabel;
@property (weak) IBOutlet NSTextField *downloadSpeedLabel;
@property (weak) IBOutlet NSTextField *ipAddressLabel;
@property (weak) IBOutlet NSTextField *publicIPLabel;
@property (weak) IBOutlet NSTextField *downloadMaxLabel;
@property (weak) IBOutlet NSTextField *uploadMaxLabel;
@property (weak) IBOutlet NSTextField *cpuTempLabel;
@property (weak) IBOutlet NSTextField *fanSpeedLabel;
@property (weak) IBOutlet NSTextField *tempGraphMaxLabel;
@property (weak) IBOutlet NSTextField *tempGraphMinLabel;

@property double cpuAverage;
@property double cpuUserAverage;
@property double cpuSystemAverage;
@property long long installedMemory;
@property long long freeMemory;
@property long long wiredMemory;
@property long long activeMemory;
@property long long inactiveMemory;
@property long long compressedMemory;
@property long long totalDiskSpace;
@property long long freeDiskSpace;
@property long long totalInBytes;
@property long long totalOutBytes;
@property long long totalInBytesPrev;
@property long long totalOutBytesPrev;
@property long long inBytesPerSecond;
@property long long outBytesPerSecond;
@property NSString *ipAddress;
@property NSString *publicIPAddress;
@property double cpuTemp;
@property NSString *fanInfo;

@property long long previousFreeMemory;

@property (weak) IBOutlet JJDualGraphView *cpuGraph;
@property (strong) IBOutlet MMMemoryLevelIndicator *memoryUsageIndicator;
@property (weak) IBOutlet JJLevelIndicator *diskLevelIndicator;
@property (weak) IBOutlet JJDualGraphView *networkGraph;
@property (weak) IBOutlet JJGraphView *cpuTempGraph;

@property (weak) IBOutlet NSProgressIndicator *freeMemoryProgressIndicator;
@property (weak) IBOutlet NSButton *freeMemoryButton;

@property (weak) IBOutlet MMContextualMenuButton *menuButton;

@property (strong) IBOutlet NSView *monitorView;

@property BOOL disabled;

@property BOOL popoverOpen;

@end
