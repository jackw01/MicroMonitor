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

@interface JSKDSystemReport : NSObject

@property (strong) NSString *uuid;
@property (strong) NSString *serial;
@property (strong) NSString *rawModelString;
@property (strong) NSString *boardId;
@property long long physicalMemory;
@property JSKDDeviceFamily family;
@property JSKDEndianness endianness;
@property CGSize displayResolution;

- (instancetype)initWithUUID:(NSString *)uuid serial:(NSString *)serial rawModelString:(NSString *)rawModelString boardId:(NSString *)boardId physicalMemory:(long long)physicalMemory family:(JSKDDeviceFamily)family endianness:(JSKDEndianness)endianness displayResolution:(CGSize)displayResolution;

@end
