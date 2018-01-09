//
// Copyright (C) 2015-2016 jackw01.
//
// This file is part of SystemInfoKit.
//
// SystemInfoKit is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// SystemInfoKit is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with SystemInfoKit. If not, see <http://www.gnu.org/licenses/>.
//

#import <Cocoa/Cocoa.h>

#import "JSKCommon.h"
#import "JSKMNetworkReport.h"

#import <sys/sysctl.h>

#import <netinet/in.h>
#import <net/if.h>
#import <net/route.h>

static processor_info_array_t cpuInfo, prevCpuInfo;
static mach_msg_type_number_t numCpuInfo, numPrevCpuInfo;

static unsigned numCPUs;

static NSLock *CPUUsageLock;

@interface JSKSystemMonitor : NSObject

+ (instancetype)systemMonitor;

@property (assign, atomic, readonly) JSKMCPUUsageInfo cpuUsageInfo;
@property (assign, atomic, readonly) NSTimeInterval systemUptime;
@property (assign, atomic, readonly) JSKMMemoryUsageInfo memoryUsageInfo;
@property (assign, atomic, readonly) JSKMDiskUsageInfo diskUsageInfo;
@property (assign, atomic, readonly) JSKMNetworkUsageInfo networkUsageInfo;
@property (assign, atomic, readonly) JSKMNetworkReport *networkInfo;
@property (assign, atomic, readonly) JSKMBatteryUsageInfo batteryUsageInfo;

@end
