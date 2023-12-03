//
//  Baby_DriverApp.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/3/21.
//
//  FILE DESCRIPTION: This file is what gets run first. It is used to initialize all the data throughout the program (e.g., reading the preference file, creating new variables used throughout the program, etc.). It also creates the separate window groups that will be used throughout (main window, preferences window, and note preview window). It also sets up the menu items such as loading preferences, saving them, etc. 

import SwiftUI
import AppKit
import AlertToast


@main
struct Axis_FiveApp: App {
    

    //Global variables used for managing content between views
    @ObservedObject var MARPFunctions = MARPFunctionality() //used to manage all MARP functions
    @ObservedObject var SCSFunctions = SCSFunctionality() //used to manage all SCS functions
    @StateObject var ActiveWindow_MainContent = ActiveContentWindow() //used to keep track of which main view is on the screen
    @StateObject var ActiveWindow_Preferences = ActivePreferencesWindow() //used to keep track of when preferences view is being used
    @ObservedObject var Preferences = GlobalPreferences() //used for keeping track of all preferences
    
    @Environment(\.openURL) var openURL //used to handle various window groups throughout the program (main, preferences, note preview)
    
    //Bools for all Alerts
    @State private var showAlert_LoadMARPMembers = false
    @State private var showAlert_SaveMARPMembers = false
    @State private var showAlert_SaveMARPVacations = false
    @State private var showAlert_SaveSCSClientList = false
    @State private var showAlert_SaveSCSSuperviseeList = false
    @State private var showAlert_SavePreferences = false
    @State private var showAlert_SaveEverything = false
    
    //Initialize global preferences and variables
    init () {
        
        //read the  preference file
        var filePrefs = decodePrefsFile(filePath: prefFilePath.path)
        //remove the quotes around the preferences
        filePrefs = removePrefsQuotes(preferences: filePrefs)
        //assign the read file to the global preference variable
        Preferences = filePrefs
        
        //read marp members file and assign to the global variable
        let tempMemberArray = MARPFunctions.MemberManagement.ReadCSVMemberList(path: MARPMemberListPath.path)
        MARPFunctions.MemberManagement.Members = MARPFunctions.MemberManagement.CreateMarpMemberArray(Members: tempMemberArray)
        
        //create the list of names for the marp members (used in the "member management" view)
        MARPFunctions.MemberManagement.MemberNameList = MARPFunctions.MemberManagement.CreateNameList(members: MARPFunctions.MemberManagement.Members)
        
        //load the marp vacations csv file
        let marpVacations = MARPFunctions.CallList.LoadMARPVacationsCSVFile(path: MARPVacationsPath.path)
        MARPFunctions.CallList.MemberVacations.vacations = marpVacations
        
        //load the scs clients csv file
        let tempClientArray = SCSFunctions.ClientManagement.ReadCSVClientList(path: SCSClientListPath.path)
        SCSFunctions.ClientManagement.Clients = SCSFunctions.ClientManagement.CreateSCSClientArray(Clients: tempClientArray)
        
        //load the SCS supervisees csv file
        let tempSuperviseeArray = SCSFunctions.SuperviseeManagement.ReadCSVSuperviseeList(path: SCSSuperviseeListPath.path)
        SCSFunctions.SuperviseeManagement.Supervisees = SCSFunctions.SuperviseeManagement.CreateSCSSuperviseeArray(Supervisees: tempSuperviseeArray)
               
        //creat the list of names for the scs clients (used in the "client management" view)
        SCSFunctions.ClientManagement.ClientNameList = SCSFunctions.ClientManagement.CreateClientNameList(clients: SCSFunctions.ClientManagement.Clients)
        
        //creat the list of names for the scs clients (used in the "client management" view)
        SCSFunctions.SuperviseeManagement.SuperviseeNameList = SCSFunctions.SuperviseeManagement.CreateSuperviseeNameList(supervisees: SCSFunctions.SuperviseeManagement.Supervisees)
        
        
        
        //Assign today's date to the Preference class
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy"
        
        MARPFunctions.DailyLogger.LoggerArguments.dateScreenCalled = formatter.string(from: Date())
        

        
    }
    
    var body: some Scene {
        
        //Main window group
        WindowGroup ("MainView"){
            
            //Create a new instance of "MainView"
            //...add environment objects
            //...set the frame dimensions
            //...remove the default toolbar buttons
            //...create a new toolbar with a custom close and minimize button
            //...creating an alert for loading MARP members
            MainView()
                .environmentObject(MARPFunctions) //NEW
                .environmentObject(SCSFunctions) //NEW
                .environmentObject(ActiveWindow_MainContent)
                .environmentObject(Preferences)
                //.frame(width: 1200, height: 700)
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                    hideDefaultToolBarButtons()
                })
                .toast(isPresenting: $showAlert_LoadMARPMembers){
                    AlertToast(displayMode: .alert, type: .complete(Color.OffBlack), title: "MARP Members Loaded")
                }
                .toast(isPresenting: $showAlert_SaveMARPMembers){
                    AlertToast(displayMode: .alert, type: .complete(Color.OffBlack), title: "MARP Members Saved")
                }
                .toast(isPresenting: $showAlert_SaveMARPVacations){
                    AlertToast(displayMode: .alert, type: .complete(Color.OffBlack), title: "MARP Vacations Saved")
                }
                .toast(isPresenting: $showAlert_SaveSCSClientList){
                    AlertToast(displayMode: .alert, type: .complete(Color.OffBlack), title: "SCS Clients Saved")
                }
                .toast(isPresenting: $showAlert_SavePreferences){
                    AlertToast(displayMode: .alert, type: .complete(Color.OffBlack), title: "Preferences Saved")
                }
                .toast(isPresenting: $showAlert_SaveEverything){
                    AlertToast(displayMode: .alert, type: .complete(Color.OffBlack), title: "Everything Saved")
                }
               
            
        }
        //Add buttons to the top menu bar
        .commands {
            //add preconfigured toolbar menus
            SidebarCommands()
            ToolbarCommands()
            
            //Preferences menu item
            CommandGroup(after: CommandGroupPlacement.textEditing) {
                
                Divider()
                
                Button("Preferences") {
                    if let url = URL(string: "dialogs://PreferencesView") {
                        openURL(url)
                    }
                }.keyboardShortcut("p", modifiers: .command)
                
                //Button to change the gif on the main screen
                Button("Change Animation") {
                    
                    if (Preferences.GlobalAnimation < 3) {
                        Preferences.GlobalAnimation = Preferences.GlobalAnimation + 1
                    }
                    else {
                        Preferences.GlobalAnimation = 1
                    }
                    
                }.keyboardShortcut("o", modifiers: .command)
             
            }
            
            //File menu item
            CommandGroup(after: CommandGroupPlacement.newItem) {
       
                
                Divider()
                
                //Save Everything
                Button("Save Everything") {
                    
                    //save the marp member list
                    MARPFunctions.MemberManagement.MemberListWriteToCSV(path: MARPMemberListPath.path, memberList: MARPFunctions.MemberManagement.Members)
                    
                    //save the MARP Vacations
                    MARPFunctions.CallList.MARPVacationstWriteToCSV(path: MARPVacationsPath.path, globalVacations: MARPFunctions.CallList.MemberVacations.vacations)
                    
                    //save the scs client list
                    SCSFunctions.ClientManagement.SCSClientListWriteToCSV(path: SCSClientListPath.path, clientList: SCSFunctions.ClientManagement.Clients)
                    
                    SCSFunctions.SuperviseeManagement.SCSSuperviseeListWriteToCSV(path: SCSSuperviseeListPath.path, superviseeList: SCSFunctions.SuperviseeManagement.Supervisees)
                    
                    //save preferences
                    createPrefsFile(preferences: Preferences, dataPath: dataPath, prefFilePath: prefFilePath)

                    //toggle the alert
                    showAlert_SaveEverything.toggle()
                    
                }
                
            }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .handlesExternalEvents(matching: Set(arrayLiteral: "MainView"))
        
        
        //Manages the preferences view as a second window, separate window
        WindowGroup("PreferencesView") {
            PreferencesView()
                .environmentObject(Preferences)
                .environmentObject(ActiveWindow_Preferences)
                .frame(minWidth:900, maxWidth:900)
                .frame(minHeight:500, maxHeight:500)
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                    hideDefaultToolBarButtons()
                })
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .handlesExternalEvents(matching: Set(arrayLiteral: "PreferencesView"))
        
        //Window group that shows the newly created session notes throughout the program
        WindowGroup("NotePreview") {
            SCSNotePreview()
                .environmentObject(SCSFunctions)
                .frame(minWidth:900, maxWidth:900)
                .frame(minHeight:700, maxHeight:700)
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                    hideDefaultToolBarButtons()
                })
                
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .handlesExternalEvents(matching: Set(arrayLiteral: "NotePreview"))
        
    }
}
