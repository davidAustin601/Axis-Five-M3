//
//  Common_Definitions.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/4/21.
//
//  FILE DESCRIPTION: File used to manage definitions that are used throughout the program regardless of if it's SCS or MARP functionality

import Foundation
import SwiftUI

//Directory for preference files
let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
let documentsDirectory = paths[0]
let docURL = URL(string: documentsDirectory)!
let dataPath = docURL.appendingPathComponent("Axis Five").appendingPathComponent("Data")

let prefFilePath = dataPath.appendingPathComponent("AxisFivePrefs.ini") //global preferences file
let dirScripts = Bundle.main.resourcePath //Directory where scripts and bundled resources are
let MARPMemberListPath = dataPath.appendingPathComponent("MARP").appendingPathComponent("MARPMemberList.csv") //Path to the default MARP members list csv file
let MARPVacationsPath = dataPath.appendingPathComponent("MARP").appendingPathComponent("MARPVacations.csv") //Path to the MARP Vacations list csv file
let SCSClientListPath = dataPath.appendingPathComponent("SCS").appendingPathComponent("SCSClients.csv") //Path to the default SCS clients list csv file
let SCSSuperviseeListPath = dataPath.appendingPathComponent("SCS").appendingPathComponent("SCSupervisees.csv") //Path to the default SCS clients list csv file



//Class for handling navigation through the side bar
class ActiveContentWindow: ObservableObject {
    @Published var activeWindow = Windows.MARP
}

//Class for handling navigation in the preferences view
class ActivePreferencesWindow: ObservableObject {
    @Published var activePrefsWindows = PrefsWindows.MARP
}

//Class for handling global preferences
class GlobalPreferences: ObservableObject {
    
    @Published var MARPPrefs = MARP_Preferences() //MARP Preferences
    @Published var SCSPrefs = SCS_Preferences() //SCS Preferences
    @Published var GlobalAnimation:Int = 1 //Keep Track of Whitch Animation is Running on Sidebar View
    
}


//Enumeration for determining what view should be open in the main view
enum Windows {
    case MARP, MARP_DailyLogger, MARP_MemberManagement, MARP_CallList, SCS_ClientManagement, SCS_SuperviseeManagement, SCS_Individual, SCS_Intake, SCS_InitialContact, SCS_GroupSession, SCS_IndividualTermination, SCS_Supervision
}

//Enumeration for determining what prefernces view should be open in the preferences view
enum PrefsWindows {
    case MARP, SCS
}






