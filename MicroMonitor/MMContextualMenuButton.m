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

#import "MMContextualMenuButton.h"

@implementation MMContextualMenuButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

// Show menu when button clicked
- (void)mouseDown:(NSEvent *)theEvent {
    
    // Create NSMenu
    self.menu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    
    // Insert menu items
    [self.menu addItemWithTitle:@"About" action:@selector(showAboutWindow:) keyEquivalent:@""];
    [self.menu addItem:[NSMenuItem separatorItem]];
    [self.menu addItemWithTitle:@"Preferences..." action:@selector(showPrefs:) keyEquivalent:@","];
    [self.menu addItem:[NSMenuItem separatorItem]];
    [self.menu addItemWithTitle:@"Quit MicroMonitor" action:@selector(quitApp:) keyEquivalent:@"q"];
    
    // Show menu
    [NSMenu popUpContextMenu:self.menu withEvent:theEvent forView:self];
}

#pragma mark Button Actions

// Show about window
- (void)showAboutWindow:(id)sender {
    
    // Create window controller and show
    self.aboutWindowController = [[MMAboutWindowController alloc] initWithWindowNibName:@"MMAboutWindowController"];
    [self.aboutWindowController showWindow:nil];
}

// Show preferences
- (void)showPrefs:(id)sender {
    
    // Show window
    self.prefsWindowController = [[MMPreferencesWindowController alloc] initWithWindowNibName:@"MMPreferencesWindowController"];
    [self.prefsWindowController showWindow:nil];
}

// Quit the app
- (void)quitApp:(id)sender {
    
    [NSApp terminate:self];
}

@end
