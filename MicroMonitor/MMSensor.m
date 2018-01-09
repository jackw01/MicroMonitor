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

#import "MMSensor.h"

@implementation MMSensor

// Return the formatted value
- (NSString *)valueString {
    
    NSString *value;
    
    NSString *degreesSuffix = [[NSUserDefaults standardUserDefaults] objectForKey:@"temperatureUnits"];
    
    if ([self.type isEqualToString:MMSensorTypeTemperature]) {
        
        double formattedValue = self.value;
        
        if ([degreesSuffix isEqualToString:@"℉"]) {
            
            formattedValue = (self.value * 9 / 5) + 32;
        }
     
        value = [NSString stringWithFormat:@"%.01f%@", formattedValue, degreesSuffix];
        
    } else if ([self.type isEqualToString:MMSensorTypeTachometer]) {
        
        value = [NSString stringWithFormat:@"%.00f RPM", self.value];
        
    } else if ([self.type isEqualToString:MMSensorTypeVoltage]) {
        
        value = [NSString stringWithFormat:@"%.02f V", self.value];
        
    } else if ([self.type isEqualToString:MMSensorTypeCurrent]) {
        
        value = [NSString stringWithFormat:@"%.02f A", self.value];
        
    } else if ([self.type isEqualToString:MMSensorTypePower]) {
        
        value = [NSString stringWithFormat:@"%.02f W", self.value];
        
    } else {
        
        value = @"--";
    }
    
    return value;
}

@end
