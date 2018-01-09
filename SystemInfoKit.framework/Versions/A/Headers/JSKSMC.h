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

#import "SMCWrapper.h"

@interface JSKSMC : NSObject

+ (instancetype)smc;

@property (strong) NSArray *allTempKeys;
@property (strong) NSArray *allVoltageKeys;
@property (strong) NSArray *allCurrentKeys;
@property (strong) NSArray *allPowerKeys;

@property (assign, atomic, readonly) NSArray *workingTempKeys;
@property (assign, atomic, readonly) NSArray *workingVoltageKeys;
@property (assign, atomic, readonly) NSArray *workingCurrentKeys;
@property (assign, atomic, readonly) NSArray *workingPowerKeys;

@property (assign, atomic, readonly) NSUInteger numberOfFans;

@property (assign, atomic, readonly) double cpuTemperatureInDegreesCelsius;
@property (assign, atomic, readonly) double cpuTemperatureInDegreesFahrenheit;

- (NSString *)humanReadableNameForKey:(NSString *)key;

- (double)temperatureInCelsiusForKey:(NSString *)key;
- (double)temperatureInFahrenheitForKey:(NSString *)key;

- (double)speedOfFan:(NSUInteger)fan;
- (double)safeMinimumSpeedOfFan:(NSUInteger)fan;
- (double)safeMaximumSpeedOfFan:(NSUInteger)fan;

- (double)rawValueForKey:(NSString *)key;

@end
