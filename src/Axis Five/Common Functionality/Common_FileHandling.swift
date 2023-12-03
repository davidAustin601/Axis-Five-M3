//
//  Common_FileHandling.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/8/21.
//
//  FILE DESCRIPTION: File used to manage the functions that revolve around handling files

import Foundation
import SwiftUI

//Dialog for Choosing File
func SelectFile() -> String {
    
    var filename = ""
    
    let panel = NSOpenPanel()
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = false
    if panel.runModal() == .OK {
        filename = panel.url!.path
    }
    
    return filename
}

//Dialog for Choosing Directory
func selectDIR() -> String {
    
    var filename = ""
    
    let panel = NSOpenPanel()
    panel.canChooseFiles = false
    panel.canChooseDirectories = true
    panel.canCreateDirectories = true
    if panel.runModal() == .OK {
        filename = panel.url!.path
    }
    
    return filename
}
