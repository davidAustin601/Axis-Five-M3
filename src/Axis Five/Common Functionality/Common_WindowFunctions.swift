//
//  Common_WindowFunctions.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/21/21.
//
//  FILE DESCRIPTION: File used to manage designs and other factors around the design of the windows of the program (e.g., hiding the toolbar on top of the window)

import Foundation
import SwiftUI

//Function Used For Hiding the Maximize, Close, and Minimize Button on the TitleBar
func hideDefaultToolBarButtons() {
    for window in NSApplication.shared.windows {
        
        //make sure the variables are not nill
        if ((window.standardWindowButton(NSWindow.ButtonType.zoomButton) != nil) && (window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton) != nil) && (window.standardWindowButton(NSWindow.ButtonType.closeButton) != nil)) {
            
            window.standardWindowButton(NSWindow.ButtonType.zoomButton)!.isHidden = true
            window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.isHidden = true
            window.standardWindowButton(NSWindow.ButtonType.closeButton)!.isHidden = true
            
            //REFERENCES!!!!!!!!!!!!!!!!!!!!
            //window.alphaValue = CGFloat(0.2)
            //window.center()

        }
    }
}

