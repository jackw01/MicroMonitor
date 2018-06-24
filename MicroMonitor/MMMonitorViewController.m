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

#import "MMMonitorViewController.h"

@implementation MMMonitorViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Set up monitoring
    self.device = [JSKDevice device];
    self.smc = [JSKSMC smc];
    self.systemMonitor = [JSKSystemMonitor systemMonitor];
    
    // Check for update
    self.disabled = NO;
    
    // Init display
    
    // CPU Graph
    self.cpuGraph.minimum = 0.0;
    self.cpuGraph.maximum1 = 100.0;
    self.cpuGraph.maximum2 = 100.0;
    self.cpuGraph.maxValues = 300;
    
    self.cpuGraph.automaticMaximum = NO;
    self.cpuGraph.style = JJDualGraphStyleOverlay;
    
    // Memory
    self.memoryUsageIndicator.minimum = 0.0;
    
    // Disk usage
    self.diskLevelIndicator.minimum = 0.0;
    
    // Network Graph
    self.networkGraph.minimum = 0.0;
    self.networkGraph.maximum1 = 1;
    self.networkGraph.maximum2 = 1;
    self.networkGraph.maxValues = 300;
    
    self.networkGraph.automaticMaximum = YES;
    self.networkGraph.style = JJDualGraphStyleCentered;
    
    // CPU Temp Graph
    self.cpuTempGraph.minimum = 21.0;
    self.cpuTempGraph.maximum = 110.0;
    self.cpuTempGraph.maxValues = 300;
    
    if (!self.disabled) {
    
        // Hide the progress bar
        [self.freeMemoryProgressIndicator setHidden:YES];
        
        // Set up network values to avoid confusion
        JSKMNetworkUsageInfo networkUsageInfo = self.systemMonitor.networkUsageInfo;
        
        self.totalInBytes = networkUsageInfo.totalInBytes;
        self.totalOutBytes = networkUsageInfo.totalOutBytes;

        [self updateStats];
        [self updateNetworkStats];
        [self updateLongTermStats];
        
        // Free up memory
        //[self freeUpMemory:self];
        
        // Init indicators
        
        [self.cpuGraph pushValues:@[ [NSNumber numberWithFloat:self.cpuSystemAverage + self.cpuUserAverage], [NSNumber numberWithFloat:self.cpuUserAverage] ]];
        
        // Memory
        self.memoryUsageIndicator.maximum = self.installedMemory / BYTES_IN_GiB;
        
        self.memoryUsageIndicator.value = (self.installedMemory - self.freeMemory) / BYTES_IN_GiB;
        
        // Disk usage
        self.diskLevelIndicator.maximum = self.totalDiskSpace / BYTES_IN_GB;
        self.diskLevelIndicator.value = (self.totalDiskSpace - self.freeDiskSpace) / BYTES_IN_GB;
        
        // Network Graph
        [self.networkGraph pushValues:@[ [NSNumber numberWithDouble:self.inBytesPerSecond / BYTES_IN_MiB], [NSNumber numberWithDouble:self.inBytesPerSecond / BYTES_IN_MiB] ]];
        
        // CPU Temp Graph
        [self.cpuTempGraph pushValue:[NSNumber numberWithFloat:self.cpuTemp]];
        
        // Start updating display
        [self update];
        
    } else {
        
        // Add fake values
        
        // CPU
        [self.cpuGraph pushValues:@[ [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0] ]];
        
        // Memory
        self.memoryUsageIndicator.maximum = 1;
        self.memoryUsageIndicator.value = 0;
        
        // Disk usage
        self.diskLevelIndicator.maximum = 1;
        self.diskLevelIndicator.value = 0;
        
        // Network Graph
        [self.networkGraph pushValues:@[ [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0] ]];

    }
}

#pragma mark Update Display

// Update the UI
- (void)update {
    
    if (!self.disabled) {
    
        // Update CPU display
        
        // Labels
        self.cpuUsageLabel.stringValue = [NSString stringWithFormat:@"CPU Usage: %1.0f%%", self.cpuAverage];
        
        self.cpuUserLabel.stringValue = [NSString stringWithFormat:@"User: %1.0f%%", self.cpuUserAverage];
        
        self.cpuSystemLabel.stringValue = [NSString stringWithFormat:@"System: %1.0f%%", self.cpuSystemAverage];
        
        self.cpuIdleLabel.stringValue = [NSString stringWithFormat:@"Idle: %1.0f%%", 100.0 - self.cpuAverage];
        
        // System Uptime
        NSDateComponentsFormatter *timeFormatter = [[NSDateComponentsFormatter alloc] init];
        timeFormatter.unitsStyle = NSDateFormatterMediumStyle;
        timeFormatter.allowedUnits = NSCalendarUnitDay | NSCalendarUnitHour;
        timeFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorDropLeading;
        
        self.uptimeLabel.stringValue = [NSString stringWithFormat:@"Uptime: %@", [timeFormatter stringFromTimeInterval:self.systemMonitor.systemUptime]];
        
        // Graph
        [self.cpuGraph pushValues:@[ [NSNumber numberWithFloat:self.cpuSystemAverage + self.cpuUserAverage], [NSNumber numberWithFloat:self.cpuUserAverage] ]];
        
        // Update memory display
        
        NSByteCountFormatter *memoryDisplayFormatter = [[NSByteCountFormatter alloc] init];
        
        // Change to binary (gibibyte) style to make info correct
        memoryDisplayFormatter.countStyle = NSByteCountFormatterCountStyleMemory;
        
        // Labels
        self.memoryUsageLabel.stringValue = [NSString stringWithFormat:@"%@ Installed (%@ Free)", [memoryDisplayFormatter stringFromByteCount:self.installedMemory], [memoryDisplayFormatter stringFromByteCount:self.freeMemory]];
        
        self.activeMemoryLabel.stringValue = [memoryDisplayFormatter stringFromByteCount:self.activeMemory];
        
        self.inactiveMemoryLabel.stringValue = [memoryDisplayFormatter stringFromByteCount:self.inactiveMemory];
        
        self.wiredMemoryLabel.stringValue = [memoryDisplayFormatter stringFromByteCount:self.wiredMemory];
        
        self.compressedMemoryLabel.stringValue = [memoryDisplayFormatter stringFromByteCount:self.compressedMemory];
        
        // Indicator
        self.memoryUsageIndicator.value = (self.installedMemory - self.freeMemory) / BYTES_IN_GiB;
        self.memoryUsageIndicator.valueActive = self.activeMemory / BYTES_IN_GiB;
        self.memoryUsageIndicator.valueInactive = self.inactiveMemory / BYTES_IN_GiB;
        self.memoryUsageIndicator.valueWired = self.wiredMemory / BYTES_IN_GiB;
        self.memoryUsageIndicator.valueCompressed = self.compressedMemory / BYTES_IN_GiB;
        
        [self.memoryUsageIndicator setNeedsDisplay:YES];
        
        // Update disk display
        
        NSByteCountFormatter *diskDisplayFormatter = [[NSByteCountFormatter alloc] init];
        
        // Change to decimal style to make info correct
        diskDisplayFormatter.countStyle = NSByteCountFormatterCountStyleFile;
        
        // Label
        self.diskUsageLabel.stringValue = [NSString stringWithFormat:@"%@ Total (%@ Free)", [diskDisplayFormatter stringFromByteCount:self.totalDiskSpace], [diskDisplayFormatter stringFromByteCount:self.freeDiskSpace]];
        
        // Indicator
        self.diskLevelIndicator.value = (self.totalDiskSpace - self.freeDiskSpace) / BYTES_IN_GB;
        
        // Update network display
        
        NSByteCountFormatter *networkDisplayFormatter = [[NSByteCountFormatter alloc] init];
        
        // Change to binary (gibibyte) style to make info correct
        networkDisplayFormatter.countStyle = NSByteCountFormatterCountStyleMemory;
        
        // Labels
        self.uploadSpeedLabel.stringValue = [NSString stringWithFormat:@"Upload: %@/s", [networkDisplayFormatter stringFromByteCount:self.outBytesPerSecond]];
        
        self.downloadSpeedLabel.stringValue = [NSString stringWithFormat:@"Download: %@/s", [networkDisplayFormatter stringFromByteCount:self.inBytesPerSecond]];
        
        self.dataSentLabel.stringValue = [NSString stringWithFormat:@"Data Sent: %@", [networkDisplayFormatter stringFromByteCount:self.totalOutBytes]];
        
        self.dataReceivedLabel.stringValue = [NSString stringWithFormat:@"Data Received: %@", [networkDisplayFormatter stringFromByteCount:self.totalInBytes]];
        
        self.ipAddressLabel.stringValue = [NSString stringWithFormat:@"IP Address: %@", self.ipAddress];
        
        self.publicIPLabel.stringValue = [NSString stringWithFormat:@"Public IP: %@", self.publicIPAddress];
        
        // Graph
        [self.networkGraph pushValues:@[[NSNumber numberWithDouble:self.inBytesPerSecond / BYTES_IN_MiB], [NSNumber numberWithDouble:self.outBytesPerSecond / BYTES_IN_MiB]]];
        
        // Graph labels
        self.downloadMaxLabel.stringValue = [NSString stringWithFormat:@"%@/s", [networkDisplayFormatter stringFromByteCount:self.networkGraph.maximum1 * BYTES_IN_MiB]];
        
        self.uploadMaxLabel.stringValue = [NSString stringWithFormat:@"%@/s", [networkDisplayFormatter stringFromByteCount:self.networkGraph.maximum2 * BYTES_IN_MiB]];
        
        // Update temp display
        
        NSString *degreesSuffix = [[NSUserDefaults standardUserDefaults] objectForKey:@"temperatureUnits"];
        
        // Label
        double formattedValue = self.cpuTemp;
        double formattedMax = 110;
        double formattedMin = 21;
        
        if ([degreesSuffix isEqualToString:@"℉"]) {
            
            formattedValue = (self.cpuTemp * 9 / 5) + 32;
            formattedMax = 230;
            formattedMin = 70;
        }
        
        self.cpuTempLabel.stringValue = [NSString stringWithFormat:@"CPU Temperature: %.01f%@", formattedValue, degreesSuffix];
        
        self.tempGraphMaxLabel.stringValue = [NSString stringWithFormat:@"%.00f%@", formattedMax, degreesSuffix];
        self.tempGraphMinLabel.stringValue = [NSString stringWithFormat:@"%.00f%@", formattedMin, degreesSuffix];
        
        // Graph
        [self.cpuTempGraph pushValue:[NSNumber numberWithFloat:self.cpuTemp]];
        
        // Update fans display
        
        /*NSUInteger fans = self.smc.numberOfFans;
        
        if (fans == 0) {
            
            self.fanSpeedLabel.stringValue = @"";
            self.fanSpeedLabel.hidden = YES;
            
        } else {
        
            self.fanSpeedLabel.stringValue = self.fanInfo;
        }*/
        
        // Schedule next info update in 1 second
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            
            [self update];
        });
    }
}

#pragma mark Update Displayed Info

// Update the system data
- (void)updateStats {
    
    // Get previous stats
    self.totalInBytesPrev = self.totalInBytes;
    self.totalOutBytesPrev = self.totalOutBytes;
    
    // Update system stats
    
    // CPU
    JSKMCPUUsageInfo cpuUsageInfo = self.systemMonitor.cpuUsageInfo;
    
    self.cpuAverage = cpuUsageInfo.usage;
    self.cpuUserAverage = cpuUsageInfo.user;
    self.cpuSystemAverage = cpuUsageInfo.system;
    
    self.installedMemory = self.device.systemInfo.physicalMemory;
    
    // Memory
    JSKMMemoryUsageInfo memoryUsageInfo = self.systemMonitor.memoryUsageInfo;
    
    self.freeMemory = memoryUsageInfo.freeMemory;
    self.wiredMemory = memoryUsageInfo.wiredMemory;
    self.activeMemory = memoryUsageInfo.activeMemory;
    self.inactiveMemory = memoryUsageInfo.inactiveMemory;
    self.compressedMemory = memoryUsageInfo.compressedMemory;
    
    // Disk
    JSKMDiskUsageInfo diskUsageInfo = self.systemMonitor.diskUsageInfo;
    
    self.totalDiskSpace = diskUsageInfo.totalDiskSpace;
    self.freeDiskSpace = diskUsageInfo.freeDiskSpace;
    
    // Temp
    self.cpuTemp = self.smc.cpuTemperatureInDegreesCelsius;
    
    // Get fan info
    
    // Number of fans
    NSUInteger fans = self.smc.numberOfFans;
    
    if (fans == 1) {
        
        self.fanInfo = [NSString stringWithFormat:@"Fan speed: %.00f RPM", [self.smc speedOfFan:0]];
        
    } else if (fans > 1) {
        
        NSMutableString *text = [[NSMutableString alloc] init];
        
        // Add a line of text for each fan
        for (int i = 0; i < fans; i++) {
            
            [text appendFormat:@"Fan %d speed: %.00f RPM \n", i, [self.smc speedOfFan:i]];
        }
        
        self.fanInfo = text;
    }
    
    // Update based on user-selected frequency
    double updateFrequency = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updateFrequency"] doubleValue];
    
    if (self.popoverOpen == NO && updateFrequency < 2.5) {
        
        updateFrequency = 2.5;
    }
    
    // Schedule next info update
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(updateFrequency * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        
        [self updateStats];
    });
}

// Update the network stats
- (void)updateNetworkStats {
    
    // Network
    JSKMNetworkUsageInfo networkUsageInfo = self.systemMonitor.networkUsageInfo;
    
    self.totalInBytes = networkUsageInfo.totalInBytes;
    self.totalOutBytes = networkUsageInfo.totalOutBytes;
    
    self.inBytesPerSecond = self.totalInBytes - self.totalInBytesPrev;
    self.outBytesPerSecond = self.totalOutBytes - self.totalOutBytesPrev;
    
    // Schedule next info update in 1 second
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        
        [self updateNetworkStats];
    });
}

// Update info that changes infrequently
- (void)updateLongTermStats {
    
    JSKMNetworkReport *networkReport = self.systemMonitor.networkInfo;
    
    self.ipAddress = networkReport.ipAddress;
    self.publicIPAddress = networkReport.publicIpAddress;
    
    // For screenshots
    //self.publicIPAddress = @"123.459.789.000";
    
    // Schedule next info update in 10 minutes
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(600 * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        
        [self updateLongTermStats];
    });
}

#pragma mark Utility

// Free up memory
- (IBAction)freeUpMemory:(id)sender {
    
    // Log as an analytics event
    if (sender != self) {
    
        //[PFAnalytics trackEvent:@"FreeMemory"];
    }
    
    // Record previous free memory
    self.previousFreeMemory = self.freeMemory;
    
    // Show progress bar and hide button
    self.freeMemoryProgressIndicator.hidden = NO;
    self.freeMemoryButton.hidden = YES;
    
    [self.freeMemoryProgressIndicator startAnimation:self];
    
    // Run task in another thread to allow progress bar to animate
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    dispatch_async(queue, ^{
        
        // Fill up available memory to trick OS into purging
        float ints = (self.freeMemory + self.inactiveMemory) / sizeof(unsigned int);
        
        unsigned int* mem;
        mem = (unsigned int*) malloc(self.freeMemory + self.inactiveMemory);
        
        for (int i = 0; i < ints; i++) {
            
            mem[i] = 1;
        }
        
        free(mem);
        
        // Do it again
        ints = (self.freeMemory + self.inactiveMemory) / sizeof(unsigned int);
        
        mem = (unsigned int*) malloc(self.freeMemory + self.inactiveMemory);
        
        for (int i = 0; i < ints; i++) {
            
            mem[i] = 1;
        }
        
        free(mem);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            // Hide progress indicator and show button when done
            self.freeMemoryProgressIndicator.hidden = YES;
            self.freeMemoryButton.hidden = NO;
            
            // Get new free memory
            JSKMMemoryUsageInfo memoryUsageInfo = self.systemMonitor.memoryUsageInfo;
            
            self.freeMemory = memoryUsageInfo.freeMemory;
            
            // Calculate the amount of memory freed
            long long memoryDifference = self.freeMemory - self.previousFreeMemory;
            
            // Create a byte count formatter
            NSByteCountFormatter *memoryDisplayFormatter = [[NSByteCountFormatter alloc] init];
            
            // Change to binary (gibibyte) style to make info correct
            memoryDisplayFormatter.countStyle = NSByteCountFormatterCountStyleMemory;
            
            // Display in button
            self.freeMemoryButton.font = [NSFont boldSystemFontOfSize:11.0f];
            self.freeMemoryButton.bordered = NO;
            self.freeMemoryButton.title = [NSString stringWithFormat:@"Memory freed: %@", [memoryDisplayFormatter stringFromByteCount:memoryDifference]];
            
            // Schedule to change back button
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
                
                self.freeMemoryButton.font = [NSFont systemFontOfSize:11.0f];
                self.freeMemoryButton.bordered = YES;
                self.freeMemoryButton.title = @"Free Up Memory";
            });
        });
    });
}

@end
