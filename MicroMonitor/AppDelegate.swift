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

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // This file and nothing else is written in Swift because at
    // the time of writing there is a bug in Xcode that prevents
    // it from working in Objective-C.

    @IBOutlet weak var window: NSWindow!
    
    let monitorStatusItem = NSStatusBar.system().statusItem(withLength: -2)
    
    let monitorPopover = NSPopover()
    
    let monitorPopoverContentViewController = MMMonitorViewController(nibName: "MMMonitorViewController", bundle: nil)
    
    let sensorsStatusItem = NSStatusBar.system().statusItem(withLength: 0)
    
    let sensorsPopover = NSPopover()
    
    let sensorsPopoverContentViewController = MMSensorsViewController(nibName: "MMSensorsViewController", bundle: nil)
    
    var eventMonitor: MMGlobalEventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Set up defaults
        let defaults = UserDefaults.standard
        let registrationDictionary = ["temperatureUnits": "℃" as NSString, "updateFrequency": 1 as NSNumber, "showSensors": true as Bool, "firstRun": true as Bool, "enableDataLogging": false as Bool, "logFrequency": 60 as NSNumber, "logExpiration": 30 as NSNumber, "detailedLogExpiration": 24 as NSNumber] as [String : Any]
        
        defaults.register(defaults: registrationDictionary)
        
        if defaults.bool(forKey: "showSensors") == true {
            
            sensorsStatusItem.length = 26
            
        } else {
            
            sensorsStatusItem.length = 0
        }
        
        // Set first launch
        UserDefaults.standard.set(false, forKey: "firstRun")
        
        // Create monitor status item and popover
        if let monitorStatusBarButton = monitorStatusItem.button {
            
            monitorStatusBarButton.image = NSImage(named: "StatusBarImage")
            monitorStatusBarButton.action = #selector(switchMonitorPopover(_:))
        }
        
        // Create sensors status item and popover
        if let sensorsStatusBarButton = sensorsStatusItem.button {
            
            sensorsStatusBarButton.image = NSImage(named: "SensorsStatusBarImage")
            sensorsStatusBarButton.action = #selector(switchSensorsPopover(_:))
        }
        
        monitorPopover.contentViewController = monitorPopoverContentViewController
        sensorsPopover.contentViewController = sensorsPopoverContentViewController
        
        // Create event monitor for closing popover
        eventMonitor = MMGlobalEventMonitor(mask: NSEventMask.leftMouseDown) { [unowned self] event in
            
            if self.monitorPopover.isShown {
                
                self.closeMonitorPopover(event)
            }
            
            if self.sensorsPopover.isShown {
                
                self.closeSensorsPopover(event)
            }
        }
        eventMonitor?.start()
        
        // Show popover
        self.switchMonitorPopover(self);
        self.switchSensorsPopover(self);
        self.switchSensorsPopover(self);
        
        // Start timing sensors update
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateSensorsMenu), userInfo: nil, repeats: true)
    }
    
    // Show or hide the sensors menu
    func updateSensorsMenu() {
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "showSensors") == true {
            
            sensorsStatusItem.length = 26
            
        } else {
            
            sensorsStatusItem.length = 0
        }
    }
    
    // Open the monitor popover
    func openMonitorPopover(_ sender: AnyObject?) {
        
        if self.sensorsPopover.isShown {
            
            self.closeSensorsPopover(sender)
        }
        
        if let monitorStatusBarButton = monitorStatusItem.button {
            
            monitorPopover.show(relativeTo: monitorStatusBarButton.bounds, of: monitorStatusBarButton, preferredEdge: NSRectEdge.minY)
        }
        
        eventMonitor?.start()
        
        self.monitorPopoverContentViewController!.popoverOpen = true
    }
    
    // Close the monitor popover
    func closeMonitorPopover(_ sender: AnyObject?) {
        
        monitorPopover.performClose(sender)
        
        eventMonitor?.stop()
        
        self.monitorPopoverContentViewController!.popoverOpen = false
    }
    
    // Open or close the monitor popover depending on current state
    func switchMonitorPopover(_ sender: AnyObject?) {
        
        if monitorPopover.isShown {
            
            closeMonitorPopover(sender)
        } else {
            
            openMonitorPopover(sender)
        }
    }
    
    // Open the sensors popover
    func openSensorsPopover(_ sender: AnyObject?) {
        
        if self.monitorPopover.isShown {
            
            self.closeMonitorPopover(sender)
        }
        
        if let sensorsStatusBarButton = sensorsStatusItem.button {
            
            sensorsPopover.show(relativeTo: sensorsStatusBarButton.bounds, of: sensorsStatusBarButton, preferredEdge: NSRectEdge.minY)
        }
        
        eventMonitor?.start()
        
        self.sensorsPopoverContentViewController!.popoverOpen = true
    }
    
    // Close the sensors popover
    func closeSensorsPopover(_ sender: AnyObject?) {
        
        sensorsPopover.performClose(sender)
        
        eventMonitor?.stop()
        
        self.sensorsPopoverContentViewController!.popoverOpen = false
    }
    
    // Open or close the sensors popover depending on current state
    func switchSensorsPopover(_ sender: AnyObject?) {
        
        if sensorsPopover.isShown {
            
            closeSensorsPopover(sender)
        } else {
            
            openSensorsPopover(sender)
        }
    }
}

