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

#import "MMSensorsViewController.h"

@interface MMSensorsViewController ()

@property BOOL darkModeOn;

- (void)darkModeChanged:(NSNotification *)notification;

@end

@implementation MMSensorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Check for dark mode
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:NSGlobalDomain];
    id style = [dict objectForKey:@"AppleInterfaceStyle"];
    self.darkModeOn = (style && [style isKindOfClass:[NSString class]] && NSOrderedSame == [style caseInsensitiveCompare:@"dark"]);
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(darkModeChanged:) name:@"AppleInterfaceThemeChangedNotification" object:nil];
    
    // Set up monitoring
    self.smc = [JSKSMC smc];
    
    // Set up keys
    self.workingSMCTempKeys = self.smc.workingTempKeys;
    self.workingSMCCurrentKeys = self.smc.workingCurrentKeys;
    self.workingSMCVoltageKeys = self.smc.workingVoltageKeys;
    self.workingSMCPowerKeys = self.smc.workingPowerKeys;
    
    // Get number of fans
    self.numberOfFans = self.smc.numberOfFans;
    
    // Set up table views
    self.sensors = [NSMutableArray array];
    
    // Temps
    for (NSString *key in self.workingSMCTempKeys) {
        
        MMSensor *sensor = [[MMSensor alloc] init];
        
        sensor.smcKey = key;
        sensor.type = MMSensorTypeTemperature;
        
        sensor.humanReadableName = [self.smc humanReadableNameForKey:key];
        sensor.value = 0;
        
        [self.arrayController addObject:sensor];
    }
    
    // Fans
    for (int f = 0; f < self.numberOfFans; f++) {
        
        MMSensor *sensor = [[MMSensor alloc] init];
        
        sensor.smcKey = [NSString stringWithFormat:@"F%dAc", f];
        sensor.type = MMSensorTypeTachometer;
        
        sensor.minimum = [self.smc safeMinimumSpeedOfFan:f];
        sensor.maximum = [self.smc safeMaximumSpeedOfFan:f];
        
        sensor.humanReadableName = [NSString stringWithFormat:@"Fan %d Speed", f + 1];
        sensor.value = 0;
        
        [self.arrayController addObject:sensor];
    }
    
    // Voltages
    for (NSString *key in self.workingSMCVoltageKeys) {
        
        MMSensor *sensor = [[MMSensor alloc] init];
        
        sensor.smcKey = key;
        sensor.type = MMSensorTypeVoltage;
        
        sensor.humanReadableName = [self.smc humanReadableNameForKey:key];
        sensor.value = 0;
        
        [self.arrayController addObject:sensor];
    }
    
    // Current
    for (NSString *key in self.workingSMCCurrentKeys) {
        
        MMSensor *sensor = [[MMSensor alloc] init];
        
        sensor.smcKey = key;
        sensor.type = MMSensorTypeCurrent;
        
        sensor.humanReadableName = [self.smc humanReadableNameForKey:key];
        sensor.value = 0;
        
        [self.arrayController addObject:sensor];
    }
    
    // Power
    for (NSString *key in self.workingSMCPowerKeys) {
        
        MMSensor *sensor = [[MMSensor alloc] init];
        
        sensor.smcKey = key;
        sensor.type = MMSensorTypePower;
        
        sensor.humanReadableName = [self.smc humanReadableNameForKey:key];
        sensor.value = 0;
        
        [self.arrayController addObject:sensor];
    }
    
    // Start updating display
    [self update];
}

- (void)update {
    
    // Only update if the popover is open
    if (self.popoverOpen == YES) {
    
        for (MMSensor *sensor in self.sensors) {
            
            // Update temperature display
            if ([sensor.smcKey hasPrefix:@"T"]) {
                
                sensor.value = [self.smc temperatureInCelsiusForKey:sensor.smcKey];
            }
            
            // Update fans display
            if ([sensor.smcKey hasPrefix:@"F"]) {
                
                sensor.value = [self.smc rawValueForKey:sensor.smcKey];
            }
            
            // Update voltage display
            if ([sensor.smcKey hasPrefix:@"V"]) {
                
                sensor.value = [self.smc rawValueForKey:sensor.smcKey];
            }
            
            // Update current display
            if ([sensor.smcKey hasPrefix:@"I"]) {
                
                sensor.value = [self.smc rawValueForKey:sensor.smcKey];
            }
            
            // Update power display
            if ([sensor.smcKey hasPrefix:@"P"]) {
                
                sensor.value = [self.smc rawValueForKey:sensor.smcKey];
            }
        }

        [self.sensorsTableView reloadData];
    }
    
    // Schedule next info update
    double updateFrequency = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updateFrequency"] doubleValue];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(updateFrequency * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        
        [self update];
    });
}

#pragma mark Table View Delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    // Add the number of working keys plus the number of header rows
    NSInteger rowCount = 1 + [self.workingSMCTempKeys count] + 1 + [self.workingSMCVoltageKeys count] + 1 + [self.workingSMCCurrentKeys count] + 1 + [self.workingSMCPowerKeys count];
    
    // Make sure not to add an extra row for computers with no fans
    if (self.numberOfFans > 0) {
        
        rowCount += 1 + self.numberOfFans;
    }
    
    return rowCount;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // Get an NSInteger based on whether the computer has fan(s)
    NSInteger fansPresent = 0;
    
    if (self.numberOfFans > 0) {
        
        fansPresent = 1;
    }
    
    // Create the text field
    NSTextField *textField = [tableView makeViewWithIdentifier:@"TextField" owner:self];
    
    if (textField == nil) {
        
        textField = [[NSTextField alloc] initWithFrame:NSZeroRect];
        textField.font = [NSFont systemFontOfSize:12];
        textField.bordered = NO;
        textField.editable = NO;
        textField.drawsBackground = NO;
    }
    
    // Probably could be less repetitive
    if (row == 0 && [tableColumn.identifier isEqualToString:@"Name"]) {
        
        textField.font = [NSFont boldSystemFontOfSize:12];
        textField.stringValue = @"Temperatures";
        
    } else if (row > 0 && row <= [self.workingSMCTempKeys count]){
    
        MMSensor *sensor = [self.sensors objectAtIndex:row - 1];
        
        if ([tableColumn.identifier isEqualToString:@"Name"]) {
            
            textField.stringValue = sensor.humanReadableName;
            
        } else if ([tableColumn.identifier isEqualToString:@"Value"]) {
            
            
            if (sensor.value > 80) {
                
                if (self.darkModeOn) {
                
                    textField.textColor = [NSColor colorWithCalibratedRed:1.0 green:1.0 - ((sensor.value - 70) / (106 - sensor.value) / 2) blue:1.0 - ((sensor.value - 70) / (106 - sensor.value) / 2) alpha:1.0];
                    
                } else {
                    
                    textField.textColor = [NSColor colorWithCalibratedRed:(sensor.value - 70) / (106 - sensor.value) / 2 green:0.0 blue:0.0 alpha:1.0];
                }
            }
            
            textField.font = [NSFont boldSystemFontOfSize:12];
            textField.stringValue = sensor.valueString;
            textField.alignment = NSRightTextAlignment;
        }
        
    } else if (row == [self.workingSMCTempKeys count] + 1 && self.numberOfFans > 0 && [tableColumn.identifier isEqualToString:@"Name"]) {
        
        textField.font = [NSFont boldSystemFontOfSize:12];
        textField.stringValue = @"Fans";
        
    } else if (row > [self.workingSMCTempKeys count] + 1 && row <= [self.workingSMCTempKeys count] + 1 + self.numberOfFans) {
        
        MMSensor *sensor = [self.sensors objectAtIndex:row - 2];
        
        if ([tableColumn.identifier isEqualToString:@"Name"]) {
            
            textField.stringValue = sensor.humanReadableName;
            
        } else if ([tableColumn.identifier isEqualToString:@"Value"]) {
            
            if (sensor.value < (sensor.minimum - 50) || sensor.value > (sensor.maximum + 50)) {
                
                textField.textColor = [NSColor colorWithCalibratedRed:0.7 green:0.0 blue:0.0 alpha:1.0];
            }
            
            textField.font = [NSFont boldSystemFontOfSize:12];
            textField.stringValue = sensor.valueString;
            textField.alignment = NSRightTextAlignment;
        }
        
    } else if (row == [self.workingSMCTempKeys count] + 1 + self.numberOfFans + fansPresent && [tableColumn.identifier isEqualToString:@"Name"]) {
        
        textField.font = [NSFont boldSystemFontOfSize:12];
        textField.stringValue = @"Voltages";
        
    } else if (row > [self.workingSMCTempKeys count] + 1 + self.numberOfFans + fansPresent && row <= [self.workingSMCTempKeys count] + 1 + self.numberOfFans + fansPresent + [self.workingSMCVoltageKeys count]) {
        
        MMSensor *sensor = [self.sensors objectAtIndex:row - 2 - fansPresent];
        
        if ([tableColumn.identifier isEqualToString:@"Name"]) {
            
            textField.stringValue = sensor.humanReadableName;
            
        } else if ([tableColumn.identifier isEqualToString:@"Value"]) {
            
            textField.font = [NSFont boldSystemFontOfSize:12];
            textField.stringValue = sensor.valueString;
            textField.alignment = NSRightTextAlignment;
        }
        
    } else if (row == [self.workingSMCTempKeys count] + 1 + self.numberOfFans + fansPresent + [self.workingSMCVoltageKeys count] + 1 && [tableColumn.identifier isEqualToString:@"Name"]) {
        
        textField.font = [NSFont boldSystemFontOfSize:12];
        textField.stringValue = @"Currents";
        
    } else if (row > [self.workingSMCTempKeys count] + 1 + self.numberOfFans + fansPresent + [self.workingSMCVoltageKeys count] + 1 && row <= [self.workingSMCTempKeys count] + 1 + self.numberOfFans + fansPresent + [self.workingSMCVoltageKeys count] + 1 + [self.workingSMCCurrentKeys count]) {
        
        MMSensor *sensor = [self.sensors objectAtIndex:row - 3 - fansPresent];
        
        if ([tableColumn.identifier isEqualToString:@"Name"]) {
            
            textField.stringValue = sensor.humanReadableName;
            
        } else if ([tableColumn.identifier isEqualToString:@"Value"]) {
            
            textField.font = [NSFont boldSystemFontOfSize:12];
            textField.stringValue = sensor.valueString;
            textField.alignment = NSRightTextAlignment;
        }
        
    } else if (row == [self.workingSMCTempKeys count] + 1 + self.numberOfFans + fansPresent + [self.workingSMCVoltageKeys count] + 1 + [self.workingSMCCurrentKeys count] + 1 && [tableColumn.identifier isEqualToString:@"Name"]) {
        
        textField.font = [NSFont boldSystemFontOfSize:12];
        textField.stringValue = @"Power Usage";
        
    } else if (row > [self.workingSMCTempKeys count] + 1 + self.numberOfFans + fansPresent + [self.workingSMCVoltageKeys count] + 1 + [self.workingSMCCurrentKeys count] + 1 && row <= [self.workingSMCTempKeys count] + 1 + self.numberOfFans + fansPresent + [self.workingSMCVoltageKeys count] + 1 + [self.workingSMCCurrentKeys count] + 1 + [self.workingSMCPowerKeys count]) {
        
        MMSensor *sensor = [self.sensors objectAtIndex:row - 4 - fansPresent];
        
        if ([tableColumn.identifier isEqualToString:@"Name"]) {
            
            textField.stringValue = sensor.humanReadableName;
            
        } else if ([tableColumn.identifier isEqualToString:@"Value"]) {
            
            textField.font = [NSFont boldSystemFontOfSize:12];
            textField.stringValue = sensor.valueString;
            textField.alignment = NSRightTextAlignment;
        }
    }
    
    return textField;
}

- (void)darkModeChanged:(NSNotification *)notification {
    
    self.darkModeOn = !self.darkModeOn;
}

@end
