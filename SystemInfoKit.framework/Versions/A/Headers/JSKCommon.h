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

#import <sys/sysctl.h>

#define kSysctlCPUBrand @"machdep.cpu.brand_string"
#define kSysctlCPUVendor @"machdep.cpu.vendor"
#define kSysctlCPUCount @"hw.packages"
#define kSysctlCPUCoreCount @"machdep.cpu.core_count"
#define kSysctlCPUThreadCount @"machdep.cpu.thread_count"
#define kSysctlCPUFrequency @"hw.cpufrequency"
#define kSysctlCPUL2Cache @"hw.l2cachesize"
#define kSysctlCPUL3Cache @"hw.l3cachesize"
#define kSysctlCPUArchitecture @"hw.cputype"
#define kSysctlModelString @"hw.model"
#define kSysctlByteOrder @"hw.byteorder"

#define BYTES_IN_KiB ((long double) 1024.0)
#define BYTES_IN_MiB ((long double) 1048576.0)
#define BYTES_IN_GiB ((long double) 1073741824.0)
#define BYTES_IN_TiB ((long double) 1099511627776.0)

#define BYTES_IN_KB ((long double) 1000.0)
#define BYTES_IN_MB ((long double) 1000000.0)
#define BYTES_IN_GB ((long double) 1000000000.0)
#define BYTES_IN_TB ((long double) 1000000000000.0)

// Sysctl functions

static inline NSString *sysctlNSStringForKey(NSString *key) {
    
    const char *keyCString = [key UTF8String];
    NSString *retVal = @"";
    
    size_t length;
    
    sysctlbyname(keyCString, NULL, &length, NULL, 0);
    
    if (length) {
        
        char *retValCString = malloc(length * sizeof(char));
        
        sysctlbyname(keyCString, retValCString, &length, NULL, 0);
        
        retVal = [NSString stringWithCString:retValCString encoding:NSUTF8StringEncoding];
        
        free(retValCString);
    }
    
    return retVal;
}

static inline float sysctlFloatForKey(NSString *key) {
    
    const char *keyCString = [key UTF8String];
    float retVal = 0;
    
    size_t length = 0;
    
    sysctlbyname(keyCString, NULL, &length, NULL, 0);
    
    if (length) {
        
        char *rawValue = malloc(length * sizeof(char));
        
        sysctlbyname(keyCString, rawValue, &length, NULL, 0);
        
        switch (length) {
                
            case 8: {
                
                retVal = (float)*(int64_t *)rawValue;
            } break;
                
            case 4: {
                
                retVal = (float)*(int32_t *)rawValue;
            } break;
                
            default: {
                
                retVal = 0.;
            } break;
        }
        
        free(rawValue);
    }
    
    return retVal;
}

static inline double sysctlDoubleForKey(NSString *key) {
    
    const char *keyCString = [key UTF8String];
    double retVal = 0;
    
    size_t length = 0;
    
    sysctlbyname(keyCString, NULL, &length, NULL, 0);
    
    if (length) {
        
        char *rawValue = malloc(length * sizeof(char));
        
        sysctlbyname(keyCString, rawValue, &length, NULL, 0);
        
        switch (length) {
                
            case 8: {
                
                retVal = (double)*(int64_t *)rawValue;
            } break;
                
            case 4: {
                
                retVal = (double)*(int32_t *)rawValue;
            } break;
                
            default: {
                
                retVal = 0.;
            } break;
        }
        
        free(rawValue);
    }
    
    return retVal;
}

// Device Family
typedef NS_ENUM(NSInteger, JSKDDeviceFamily) {
    
    JSKDDeviceFamilyUnknown = 0,
    JSKDDeviceFamilyMacBook,
    JSKDDeviceFamilyMacBookPro,
    JSKDDeviceFamilyMacBookAir,
    JSKDDeviceFamilyiMac,
    JSKDDeviceFamilyMacPro,
    JSKDDeviceFamilyMacMini,
    JSKDDeviceFamilyXserve
};

static inline NSString * stringFromJSKDDeviceFamily(JSKDDeviceFamily family) {
    
    NSString *result;
    
    if (family == JSKDDeviceFamilyUnknown) {
        
        result = @"Unknown";
        
    } else if (family == JSKDDeviceFamilyMacBook) {
        
        result = @"MacBook";
        
    } else if (family == JSKDDeviceFamilyMacBookPro) {
        
        result = @"MacBook Pro";
        
    } else if (family == JSKDDeviceFamilyMacBookAir) {
        
        result = @"MacBook Air";
        
    } else if (family == JSKDDeviceFamilyiMac) {
        
        result = @"iMac";
        
    } else if (family == JSKDDeviceFamilyMacPro) {
        
        result = @"Mac Pro";
        
    } else if (family == JSKDDeviceFamilyMacMini) {
        
        result = @"Mac Mini";
        
    } else if (family == JSKDDeviceFamilyXserve) {
        
        result = @"Xserve";
    }
    
    return result;
}

// Endianness
typedef NS_ENUM(NSInteger, JSKDEndianness) {
    JSKDEndiannessLittle = 0,
    JSKDEndiannessBig,
    JSKDEndiannessUnknown
};

static inline NSString * stringFromJSKDEndianness(JSKDEndianness endianness) {
    
    NSString *result;
    
    if (endianness == JSKDEndiannessUnknown) {
        
        result = @"Unknown";
        
    } else if (endianness == JSKDEndiannessLittle) {
        
        result = @"Little Endian";
        
    } else if (endianness == JSKDEndiannessBig) {
        
        result = @"Big Endian";
    }
    
    return result;
}

// CPU Architecture
typedef NS_ENUM(NSInteger, JSKDCPUArchitecture) {
    
    JSKDCPUArchitectureX86 = 0,
    JSKDCPUArchitectureX86_64,
    JSKDCPUArchitectureUnknown
};

static inline NSString * stringFromJSKDCPUArchitecture(JSKDCPUArchitecture architecture) {
    
    NSString *result;
    
    if (architecture == JSKDCPUArchitectureUnknown) {
        
        result = @"Unknown";
        
    } else if (architecture == JSKDCPUArchitectureX86) {
        
        result = @"X86";
        
    } else if (architecture == JSKDCPUArchitectureX86_64) {
        
        result = @"X86-64";
    }
    
    return result;
}

// CPU Usage
typedef struct {
    
    double usage;
    double user;
    double system;
    double idle;
    double nice;
    
} JSKMCPUUsageInfo;

typedef struct {
    
    long long freeMemory;
    long long usedMemory;
    long long activeMemory;
    long long inactiveMemory;
    long long wiredMemory;
    long long compressedMemory;
    
} JSKMMemoryUsageInfo;

typedef struct {
    
    long long totalDiskSpace;
    long long freeDiskSpace;
    long long usedDiskSpace;
    
} JSKMDiskUsageInfo;

typedef struct {
    
    long long totalInBytes;
    long long totalOutBytes;
    
} JSKMNetworkUsageInfo;

typedef struct {
    
    BOOL present;
    BOOL full;
    BOOL acConnected;
    BOOL charging;
    double voltage;
    double amperage;
    double designCapacity;
    double maximumCapacity;
    double currentCapacity;
    NSUInteger designCycleCount;
    NSUInteger cycleCount;
    NSUInteger ageInDays;
    
} JSKMBatteryUsageInfo;

// Convert C to F
static inline double celsiusToFahrenheit(double celsius) {
    
    return (celsius * 9 / 5) + 32;
}
