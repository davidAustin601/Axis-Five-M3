//
//  Common_FileFunctions.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/7/21.
//
//  FILE DESCRIPTION: File used to manage the preferenes throughout the entire program

import Foundation
import INIParser

//Structure of MARP preferences to be used throughout the program
struct MARP_Preferences {
    var dataDirectory: String
    var excelFile: String
    var dirScreenshot: String
    var contactLogTemplateFile: String
    var monthYear: String
    
    init () {
        dataDirectory = "/Users/davidaustin/Documents/Axis Five/Data/MARP/"
        excelFile = ""
        dirScreenshot = "/Users/davidaustin/Downloads/"
        contactLogTemplateFile = "/Users/davidaustin/Documents/Axis Five/Data/MARP/MARP Contact Template.docx"
        monthYear = ""
    }
}

//Structure of SCS prefernces to be used throughout the program
struct SCS_Preferences {
    var individualSessionFile:String
    var supervisionSessionFile:String
    var intakeSessionFile:String
    var initialContactFile:String
    var groupLeaders:String
    var groupSessionFile:String
    var groupScreenSessionFile:String
    var otherSessionFile:String
    var individualterminationFile:String
    var clientListFile:String
    
    init () {
        individualSessionFile = "/Users/davidaustin/Documents/Axis Five/Data/SCS/th_follow-up 2.txt"
        supervisionSessionFile = "/Users/davidaustin/Documents/Axis Five/Data/SCS/TH_Supervision_Ver1.txt"
        intakeSessionFile = "/Users/davidaustin/Documents/Axis Five/Data/SCS/th_initial.txt"
        initialContactFile = "/Users/davidaustin/Documents/Axis Five/Data/SCS/initial-contact.txt"
        groupLeaders = ""
        groupSessionFile = "/Users/davidaustin/Documents/Axis Five/Data/SCS/lgbtq_group-session.txt"
        groupScreenSessionFile = "/Users/davidaustin/Documents/Axis Five/Data/SCS/lgbtq_group-screen"
        otherSessionFile = "/Users/davidaustin/Documents/Axis Five/Data/SCS/Other.txt"
        individualterminationFile = "/Users/davidaustin/Documents/Axis Five/Data/SCS/termination"
        clientListFile = "/Users/davidaustin/Documents/Axis Five/Data/SCS/SCSClients.csv"
    }
}

//Structure of the OTHER preferences to be used throughout the program
struct OTHER_Preferences {
    var taskListFile:String
    
    init () {
        taskListFile = "/Users/davidaustin/Documents/Axis Five/Data/Other/TaskList.csv"
    }
}

//FUNCTIONS
//Decoding TMOL formatted external file for preferences
func decodePrefsFile(filePath: String) -> GlobalPreferences {
    
    let tempPreferences = GlobalPreferences()
    
    //make sure the preferences file exists
    if FileManager.default.fileExists(atPath: prefFilePath.path) {
        
        var parsedData:INIParser?
        
        //First parse the data from the file
        print(prefFilePath.absoluteString)
        
        parsedData = try? INIParser(prefFilePath.path)
        
        //Make sure parsed data is not equal to nil
        if (parsedData != nil)
        {
            //Assign data to tempPreferences. If doesn't exist assign default value
            //MARP
            tempPreferences.MARPPrefs.dataDirectory = parsedData?.sections["marp"]?["dataDIR"] ?? "/Users/davidaustin/Documents/Axis Five/Data/MARP"
            tempPreferences.MARPPrefs.excelFile = parsedData?.sections["marp"]?["excelFile"] ?? ""
            tempPreferences.MARPPrefs.dirScreenshot = parsedData?.sections["marp"]?["dirScreenshot"] ?? "/Users/davidaustin/Downloads/"
            tempPreferences.MARPPrefs.contactLogTemplateFile = parsedData?.sections["marp"]?["contactLogTemplateFile"] ?? "/Users/davidaustin/Documents/Axis Five/Data/MARP/MARP Contact Template.docx"
            tempPreferences.MARPPrefs.monthYear = parsedData?.sections["marp"]?["monthYear"] ?? ""
            
            //scs
            tempPreferences.SCSPrefs.individualSessionFile = parsedData?.sections["scs"]?["individualSessionFile"] ?? "/Users/davidaustin/Documents/Axis Five/Data/SCS/th_follow-up 2.txt"
            tempPreferences.SCSPrefs.intakeSessionFile = parsedData?.sections["scs"]?["intakeSessionFile"] ?? "/Users/davidaustin/Documents/Axis Five/Data/SCS/th_initial.txt"
            tempPreferences.SCSPrefs.initialContactFile = parsedData?.sections["scs"]?["initialContactFile"] ?? "/Users/davidaustin/Documents/Axis Five/Data/SCS/initial-contact.txt"
            tempPreferences.SCSPrefs.groupLeaders = parsedData?.sections["scs"]?["groupLeaders"] ?? ""
            tempPreferences.SCSPrefs.groupSessionFile = parsedData?.sections["scs"]?["groupSessionFile"] ?? "/Users/davidaustin/Documents/Axis Five/Data/SCS/lgbtq_group-session.txt"
            tempPreferences.SCSPrefs.groupScreenSessionFile = parsedData?.sections["scs"]?["groupScreenSessionFile"] ?? "/Users/davidaustin/Documents/Axis Five/Data/SCS/lgbtq_group-screen"
            tempPreferences.SCSPrefs.otherSessionFile = parsedData?.sections["scs"]?["otherSessionFile"] ?? "/Users/davidaustin/Documents/Axis Five/Data/SCS/Other.txt"
            tempPreferences.SCSPrefs.individualterminationFile = parsedData?.sections["scs"]?["individualTerminationFile"] ?? "/Users/davidaustin/Documents/Axis Five/Data/SCS/termination.txt"
            tempPreferences.SCSPrefs.clientListFile = parsedData?.sections["scs"]?["clientListFile"] ?? "/Users/davidaustin/Documents/Axis Five/Data/SCS/SCSClients.csv"
        }
    }
    else {
        //Save the preferences file
        createPrefsFile(preferences: tempPreferences, dataPath: dataPath, prefFilePath: prefFilePath)
    }
    
    return tempPreferences
}

//Create external TMOL formatted file for saving preferences
func createPrefsFile(preferences: GlobalPreferences, dataPath: URL, prefFilePath: URL) {
    
    //make the directory if it doesn't exist
    var isDIR: ObjCBool = true
    if !FileManager.default.fileExists(atPath: dataPath.path, isDirectory: &isDIR) {
        do {
            
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    do {
        
        let prefsTemplate = """
        [marp]
        dataDIR = "\(preferences.MARPPrefs.dataDirectory)"
        excelFile = "\(preferences.MARPPrefs.excelFile)"
        dirScreenshot = "\(preferences.MARPPrefs.dirScreenshot)"
        contactLogTemplateFile = "\(preferences.MARPPrefs.contactLogTemplateFile)"
        monthYear = "\(preferences.MARPPrefs.monthYear)"
        
        [scs]
        individualSessionFile = "\(preferences.SCSPrefs.individualSessionFile)"
        supervisionSessionFile = "\(preferences.SCSPrefs.supervisionSessionFile)"
        intakeSessionFile = "\(preferences.SCSPrefs.intakeSessionFile)"
        initialContactFile = "\(preferences.SCSPrefs.initialContactFile)"
        groupLeaders = "\(preferences.SCSPrefs.groupLeaders)"
        groupSessionFile = "\(preferences.SCSPrefs.groupSessionFile)"
        groupScreenSessionFile = "\(preferences.SCSPrefs.groupScreenSessionFile)"
        otherSessionFile = "\(preferences.SCSPrefs.otherSessionFile)"
        individualTerminationFile = "\(preferences.SCSPrefs.individualterminationFile)"
        clientListFile = "\(preferences.SCSPrefs.clientListFile)"
        """
        
        let filepath = URL(fileURLWithPath: prefFilePath.path)
        
        try prefsTemplate.write(to: filepath, atomically: true, encoding: .utf8)
        
    } catch {
        print(error.localizedDescription)
    }
}

//Function to add and remove quotes from strings
func editQuotes (boolAdd: Bool, string: String) -> String {
    if boolAdd {
        return string.replacingOccurrences(of: "\"", with: "")
        }
    else{
        return "\"" + string + "\""
    }
}

//Function to remove quotes after loading the preferences file
func removePrefsQuotes(preferences: GlobalPreferences) -> GlobalPreferences{
    
    preferences.MARPPrefs.contactLogTemplateFile = editQuotes(boolAdd: true, string: preferences.MARPPrefs.contactLogTemplateFile)
    preferences.MARPPrefs.dataDirectory = editQuotes(boolAdd: true, string: preferences.MARPPrefs.dataDirectory)
    preferences.MARPPrefs.dirScreenshot = editQuotes(boolAdd: true, string: preferences.MARPPrefs.dirScreenshot)
    preferences.MARPPrefs.excelFile = editQuotes(boolAdd: true, string: preferences.MARPPrefs.excelFile)
    preferences.MARPPrefs.monthYear = editQuotes(boolAdd: true, string: preferences.MARPPrefs.monthYear)
    
    
    preferences.SCSPrefs.individualSessionFile = editQuotes(boolAdd: true, string: preferences.SCSPrefs.individualSessionFile)
    preferences.SCSPrefs.supervisionSessionFile = editQuotes(boolAdd: true, string: preferences.SCSPrefs.supervisionSessionFile)
    preferences.SCSPrefs.intakeSessionFile = editQuotes(boolAdd: true, string: preferences.SCSPrefs.intakeSessionFile)
    preferences.SCSPrefs.initialContactFile = editQuotes(boolAdd: true, string: preferences.SCSPrefs.initialContactFile)
    preferences.SCSPrefs.groupLeaders = editQuotes(boolAdd: true, string: preferences.SCSPrefs.groupLeaders)
    preferences.SCSPrefs.groupSessionFile = editQuotes(boolAdd: true, string: preferences.SCSPrefs.groupSessionFile)
    preferences.SCSPrefs.groupScreenSessionFile = editQuotes(boolAdd: true, string: preferences.SCSPrefs.groupScreenSessionFile)
    preferences.SCSPrefs.otherSessionFile = editQuotes(boolAdd: true, string: preferences.SCSPrefs.otherSessionFile)
    preferences.SCSPrefs.individualterminationFile = editQuotes(boolAdd: true, string: preferences.SCSPrefs.individualterminationFile)
    preferences.SCSPrefs.clientListFile = editQuotes(boolAdd: true, string: preferences.SCSPrefs.clientListFile)

    
    return preferences
}

//REFERENCE:
//var newPrefs = decodePrefsFile(filePath: prefFilePath.path)
//createPrefsFile(preferences: newPrefs, dataPath: dataPath, prefFilePath: prefFilePath)
