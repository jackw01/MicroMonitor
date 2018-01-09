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

#import <Foundation/Foundation.h>

#import "JSKCommon.h"

@interface JSKDCPUReport : NSObject

@property (strong) NSString *brand;
@property (strong) NSString *vendor;

@property NSUInteger cpuCount;
@property NSUInteger coreCount;
@property NSUInteger threadCount;

@property double frequency;

@property double l2Cache;
@property double l3Cache;

@property JSKDCPUArchitecture architecture;

- (instancetype)initWithBrand:(NSString *)brand vendor:(NSString *)vendor cpuCount:(NSUInteger)cpuCount coreCount:(NSUInteger)coreCount threadCount:(NSUInteger)threadCount frequency:(double)frequency l2Cache:(double)l2Cache l3Cache:(double)l3Cache architecture:(JSKDCPUArchitecture)architecture;

@end
