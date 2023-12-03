//
//  MARP_Functions.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/3/21.
//
//  FILE DESCRIPTION: File used to gather and organize all functions using in the various MARP functions

import Foundation
import PythonKit
import SwiftCSV
import INIParser

//Outisde Definitions / Extensions
//Structure used managing MARP member information (allow to initialize the struct with
struct MarpMember: Hashable {
    var name: String
    var email: String
    var cell_phone: String
    var alt_phone: String
    var num_screens: String
    var special_notes: String
}

extension MarpMember: Codable {
    init(dictionary: [String: String]) throws {
        self = try JSONDecoder().decode(MarpMember.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
    private enum CodingKeys: String, CodingKey {
        case name = "Name", email = "Email", cell_phone = "Cell Phone", alt_phone = "Alt Phone", num_screens = "Tests Per Month", special_notes = "Special Notes"
    }
}

extension MarpMember: CustomStringConvertible {
    var description: String {
        return "Name: " + name + " - email: " + email + " - Cell Phone: " + cell_phone + " - Alt Phone: " + alt_phone + " - Tests Per Month: " + " - Special Notes: " + special_notes
    }
}

//MARP - Class that handles all functionality
class MARPFunctionality: ObservableObject {
    
    //Initialize Inner Classes
    @Published var MemberManagement:MemberManagement = MemberManagement() //Class for handing MARP members
    @Published var DailyLogger:DailyLogger = DailyLogger() //Class for handling daily logger functions
    @Published var CallList:CallList = CallList() //Class for handling call list functions

    //Inner class - Member Management
    class MemberManagement {
        
        //Variables
        @Published var Members = [MarpMember]()
        @Published var MemberNameList = [String]()
        
        //function to read the CSV file that has all the marp members information
        func ReadCSVMemberList (path: String) -> [[String:String]]{
            do {
                            
                return try CSV(url: URL(fileURLWithPath: path)).namedRows
                
            } catch {
                //catch errors from trying to load files
                //returns an empty array of dictionaries if there is an error loading the csv file
                return [[String:String]]()
            }
        }
        
        //function to write the current member list to a csv file
        func MemberListWriteToCSV(path: String, memberList: [MarpMember]) {
            
            var csvString = ""
            
            //create the headers
            let columnHeaders = "Name,Email,Cell Phone,Alt Phone,Tests Per Month,Observed,Special Notes" + "\n"
            csvString += columnHeaders
            
            //cycle through each [MarpMember] array and add a new line to the string
            for member in memberList {
                
                
                
                csvString += member.name.trimmingCharacters(in: .whitespacesAndNewlines) + "," + member.email.trimmingCharacters(in: .whitespacesAndNewlines) + "," + member.cell_phone.trimmingCharacters(in: .whitespacesAndNewlines) + "," + member.alt_phone.trimmingCharacters(in: .whitespacesAndNewlines) + "," + member.num_screens.trimmingCharacters(in: .whitespacesAndNewlines) + "," + "," +
                member.special_notes.trimmingCharacters(in: .whitespacesAndNewlines) + "\n"
            }
            
            //write to the pathd
            let filepath = URL(fileURLWithPath: path)
            
            try? csvString.write(to: filepath, atomically: true, encoding: .utf8)
        }
        
        //convert array of dictionaries to an array of MarpMember structs
        func CreateMarpMemberArray (Members: [[String:String]]) -> [MarpMember] {
            
            var memberArray:[MarpMember] = [MarpMember]()
            
            //cycle through the array of dictionaries
            for memberDic in Members {
                
                //create a temp MarpMember struct and import the dictionary
                let tempMemberStruct = try? MarpMember(dictionary: memberDic)
                
                //if no error then add to the memberarray
                if tempMemberStruct != nil {
                    memberArray.append(tempMemberStruct!)
                }
                
            }
            
            return memberArray
        }
        
        //function to create a list of marpmember names
        func CreateNameList (members: [MarpMember]) -> [String]{
            
            var tempList = [String]()
            
            members.forEach { MarpMember in
                tempList.append(MarpMember.name)
            }
            
            return tempList
        }
        
        func AddMemberToMemberArray (member: MarpMember) -> [MarpMember] {
            
            var tempArray = Members
            
            if !CheckNameIsInList(list: MemberNameList, name: member.name) {
                
                tempArray.append(member)
            }
            
            return tempArray
        }
        
        func AddMemberToNameArray (memberName: String) -> [String] {
            
            var tempArray = MemberNameList
            
            tempArray.append(memberName)
            
            return tempArray
        }
        
        //function to remove MarpMember from a [MarpMember] array
        func RemoveMemberFromArray (memberName: String) -> [MarpMember]{
            
            var tempArray = [MarpMember]()
            
            //Remove from the MarpMember array
            for (index, member) in Members.enumerated() {
                
                //check if the name is the same as input parameter
                if memberName == member.name {
                    //remove at index
                    Members.remove(at: index)
                }
            }
            
            //assign the edite [MarpMember] to the temporary [MarpMember] array
            tempArray = Members
            
            return tempArray
        }
        
        //function to remove member name from global Marp Member name list
        func RemoveMemberFromNameList(memberName: String) -> [String]{
            
            var tempArray = [String]()
            
            //Remove from the Member Name List
            for (index, member) in MemberNameList.enumerated() {
                if memberName == member {
                    MemberNameList.remove(at: index)
                }
            }
            
            //assign the edite [MarpMember] to the temporary [MarpMember] array
            tempArray = MemberNameList
            
            return tempArray
        }
        
        func CheckNameIsInList (list: [String], name: String) -> Bool {
            
            for item in list {
                
                if item == name {
                    return true
                }
                
            }
            
            return false
        }
        
        //function to create String of Marp Information
        func gatherMemberInfoForTextBox (name: String?) -> String {
            
            var tempString = ""
            
            Members.forEach() { item in
                
                if item.name == name {
                    
                    tempString = """
                        Name: \(item.name)
                        Email: \(item.email)
                        Phone Number: \(item.cell_phone)
                        Alt Phone Number: \(item.alt_phone)
                        Num Screens Per Month: \(item.num_screens)
                        Special Notes: \(item.special_notes)
                        """
                }
                
            }
            
            return tempString
        }
        
    }
    
    //Inner class - Daily Logger
    class DailyLogger {
        
        //MARP logger arugments for daily logger functions
        @Published var LoggerArguments = MARPLoggerArgs()
        @Published var ProcessLog = LogData()
        
        
        //Structure used for passing arguments to python code
        struct MARPLoggerArgs {
            var dirWorkingPath: String
            var fileWordTemplate: String
            var fileExcelFile: String
            var dirDataDirectory: String
            var numScreensPerMonth: String
            var dateScreenCalled: String
            var timeInitialContact: String
            var timeResponseTime: String
            var memberName: String
            var dateMonthYear: String
            var dirScreenShot: String
            
            init(){
                dirWorkingPath = ""
                fileWordTemplate = ""
                fileExcelFile = ""
                dirDataDirectory = ""
                numScreensPerMonth = ""
                dateScreenCalled = ""
                timeInitialContact = ""
                timeResponseTime = ""
                memberName = ""
                dateMonthYear = ""
                dirScreenShot = ""
            }
        }
        
        //Struct used to keep up with log data of processes run
        struct LogData {
            var MarpDaily:String
            
            init () {
                MarpDaily = ""
            }
        }
        
        //function to pass to the 'runMARPToolbox' python code
        func GatherMarpLoggerArgs (MARPPrefences: MARP_Preferences, localMarpArgs: MARPLoggerArgs) -> MARPLoggerArgs {
            var tempArgs = MARPLoggerArgs()
            
            tempArgs.dirWorkingPath = editQuotes(boolAdd: true, string: dirScripts!)
            tempArgs.fileWordTemplate = editQuotes(boolAdd: true, string: MARPPrefences.contactLogTemplateFile)
            tempArgs.fileExcelFile = editQuotes(boolAdd: true, string: MARPPrefences.excelFile)
            tempArgs.dirDataDirectory = editQuotes(boolAdd: true, string: MARPPrefences.dataDirectory)
            tempArgs.numScreensPerMonth = editQuotes(boolAdd: true, string: localMarpArgs.numScreensPerMonth)
            tempArgs.dateScreenCalled = editQuotes(boolAdd: true, string: localMarpArgs.dateScreenCalled)
            tempArgs.timeInitialContact = editQuotes(boolAdd: true, string: localMarpArgs.timeInitialContact)
            tempArgs.timeResponseTime = editQuotes(boolAdd: true, string: localMarpArgs.timeResponseTime)
            tempArgs.memberName = editQuotes(boolAdd: true, string: localMarpArgs.memberName)
            tempArgs.dateMonthYear = editQuotes(boolAdd: true, string: MARPPrefences.monthYear)
            tempArgs.dirScreenShot = editQuotes(boolAdd: true, string: MARPPrefences.dirScreenshot)
            
            return tempArgs
        }
        
        //Function to call MARPToolbox python Code
        func RunMARPToolbox(Arguments: MARPLoggerArgs) -> String {
            
            //*********REFERENCE*********************
            //    def runToolbox(_globCWD, _globWordTemplate, _argExcel_Filename, _argWord_FileDIR, _argNumPerMonth, _argDateScreen,
            //        _argInitialContactTime, _argResponseTime, _argPerson, _argTaskType, _argMonthYear, _argScreenshotDIR):
            //****************************************
            
            //path for
            let dirPythonCode = Arguments.dirWorkingPath
            
            //DEFINE Variables
            let globWordTemplate = Arguments.fileWordTemplate //FIX THIS TO BE SPECIFIC
            let argExcel_Filename = Arguments.fileExcelFile
            let argWord_FileDIR = Arguments.dirDataDirectory
            let argNumPerMonth = Arguments.numScreensPerMonth
            let argDateScreen = Arguments.dateScreenCalled
            let argInitialContactTime = Arguments.timeInitialContact
            let argResponseTime = Arguments.timeResponseTime
            let argPerson = Arguments.memberName
            
            //Figure out which task to call
            var argTaskType:String
            
            let argMonthYear = Arguments.dateMonthYear
            let argScreenshotDIR = Arguments.dirScreenShot
            
            //Initialize the PythonKit code
            let sys = Python.import("sys")
            sys.path.append(dirPythonCode)
            
            //Import python code from "PythonKit_MARPToolbox.py code
            //Run Excel Task
            let pythonCode = Python.import("PythonKit_MARPToolbox")
            argTaskType = "EXCEL"
            let result_EXCEL = pythonCode.runToolbox(globWordTemplate, argExcel_Filename, argWord_FileDIR, argNumPerMonth,
                                                     argDateScreen, argInitialContactTime, argResponseTime, argPerson, argTaskType,
                                                     argMonthYear, argScreenshotDIR)
            
            //Run Word Task
            argTaskType = "WORD"
            let result_WORD = pythonCode.runToolbox(globWordTemplate, argExcel_Filename, argWord_FileDIR, argNumPerMonth,
                                                    argDateScreen, argInitialContactTime, argResponseTime, argPerson, argTaskType,
                                                    argMonthYear, argScreenshotDIR)
            
            //Run SCREENSHOT Task
            argTaskType = "SCREENSHOT"
            let result_SCREENSHOT = pythonCode.runToolbox(globWordTemplate, argExcel_Filename, argWord_FileDIR, argNumPerMonth,
                                                          argDateScreen, argInitialContactTime, argResponseTime, argPerson, argTaskType,
                                                          argMonthYear, argScreenshotDIR)
            
            //Run Word Task
            argTaskType = "COPY"
            let result_COPY = pythonCode.runToolbox(globWordTemplate, argExcel_Filename, argWord_FileDIR, argNumPerMonth,
                                                    argDateScreen, argInitialContactTime, argResponseTime, argPerson, argTaskType,
                                                    argMonthYear, argScreenshotDIR)
            
            var runLog = argPerson + ":" + "\n"
            runLog += "==============================================" + "\n"
            runLog += String(result_EXCEL)!
            runLog += "==============================================" + "\n"
            runLog += String(result_WORD)!
            runLog += "==============================================" + "\n"
            runLog += String(result_SCREENSHOT)!
            runLog += "==============================================" + "\n"
            runLog += String(result_COPY)!
            runLog += "==============================================" + "\n"
            
            return runLog
        }
        
    }
    
    //Innder class - Call List
    class CallList {
        
        //MARP vacations for creating call list
        @Published var MemberVacations = MARPVacations()
        
        //Structure used for managing MARP Call List preferences
        struct MARPCallListPrefs {
            var outputDir: String
            var month: String
            var year: String
            
            init () {
                outputDir = ""
                month = ""
                year = ""
            }
        }

        //Structure to manage MARP Member vacations
        struct MARPVacations {
            var vacations: [[String]]
            
            init () {
                vacations = [[String]]()
            }
        }
        
        //function to create a series of directories for the call list
        func CreateMonthDIRs (members: [String], dirPath: String, month: String, year: String) {
            
            //New DIR
            //Determine the new output DIR according to the month and year chosen
            let newDIR = "\(dirPath)/\(month) \(year)/"
            
            //check to see if new DIR exists -> if it doesn't, create it
            var isDIR: ObjCBool = true
            if !FileManager.default.fileExists(atPath: newDIR, isDirectory: &isDIR) {
                do {
                    
                    try FileManager.default.createDirectory(atPath: newDIR, withIntermediateDirectories: true, attributes: nil)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            //cycle through the members
            for member in members {
                
                //find the path of current member
                let memberPath = "\(newDIR)\(member)/"
                
                //make the directory if it doesn't exist
                var isDIR: ObjCBool = true
                if !FileManager.default.fileExists(atPath: memberPath, isDirectory: &isDIR) {
                    do {
                        
                        try FileManager.default.createDirectory(atPath: memberPath, withIntermediateDirectories: true, attributes: nil)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        //function to load the MARP Vacations csv file
        //REFERENCE FOR THE DATA STRUCTURE:
        // NAME: [name, start date, end date]
        func LoadMARPVacationsCSVFile (path: String) -> [[String]]{
            
            var tempArray = [[String]]()
            
            do {
                
                //Load the csv file into a variable of rows
                let csvData = try CSV(url: URL(fileURLWithPath: path)).namedRows
                
                //cycle through each row
                //[[String:String]] -> cycle through
                for row in csvData {
                    let name = row["Name"]!
                    let startDate = row["Start Date"]!
                    let endDate = row["End Date"]!
                    
                    let rowArray = [name, startDate, endDate]
                    tempArray.append(rowArray)
                }
                
                return tempArray
                
            } catch {
                //catch errors from trying to load files
                //returns an empty array of dictionaries if there is an error loading the csv file
                return [[String]]()
            }
        }
        
        //function to write a csv from the global vacation array
        func MARPVacationstWriteToCSV(path: String, globalVacations: [[String]]) {
            
            var csvString = ""
            
            //create the headers
            let columnHeaders = "Name,Start Date,End Date" + "\n"
            csvString += columnHeaders
            
            //cycle through each global vacation array and add a new line to the string
            for vacation in globalVacations {
                
                csvString += vacation[0].trimmingCharacters(in: .whitespacesAndNewlines) + "," + vacation[1].trimmingCharacters(in: .whitespacesAndNewlines) + "," + vacation[2].trimmingCharacters(in: .whitespacesAndNewlines) + "\n"
                
            }
            
            //write to the pathd
            let filepath = URL(fileURLWithPath: path)
            try? csvString.write(to: filepath, atomically: true, encoding: .utf8)
            
        }
        
        //Function used to add a new marp vacation to the global variable
        func AddMARPVacation (newVacation: [String], originalVacations: [[String]]) -> [[String]]{
            var tempArray = originalVacations
            tempArray.append(newVacation)
            
            return tempArray
        }
        
        //function to remove a selected marp vacation from the global variable
        func RemoveMARPVacation(selectedVacation: [String], originalVacations: [[String]]) -> [[String]] {
            
            var tempArray = originalVacations
            
            //loop through the Original Vacations
            for index in 0..<(tempArray.count) {
                
                //see if the current [String] is equal to the selectedVacation to remove
                if(tempArray[index] == selectedVacation){
                    
                    //remove at the index
                    tempArray.remove(at: index)
                    break
                }
                
            }
            
            return tempArray
        }
        
        //function to run the call list python script
        func GatherMonthVacations(vacations: [[String]], selectedMonth: String) -> [String] {
            
            var tempMonthVacations = [String]()
            
            //get current month
            let currentMonth:Int
            
            //convert selected month to int
            switch(selectedMonth) {
            
            case "January":
                currentMonth = 1
            case "February":
                currentMonth = 2
            case "March":
                currentMonth = 3
            case "April":
                currentMonth = 4
            case "May":
                currentMonth = 5
            case "June":
                currentMonth = 6
            case "July":
                currentMonth = 7
            case "August":
                currentMonth = 8
            case "September":
                currentMonth = 9
            case "October":
                currentMonth = 10
            case "November":
                currentMonth = 11
            case "December":
                currentMonth = 12
            default:
                currentMonth = 0
            }
            
            //cycle through each row in the vacations array
            for row in vacations {
                
                //convert the first date to ISO format
                let isoDate = ConvertDateISO(date: row[1])
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from:isoDate)!
                
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
                
                //extract month from the newly formatted date
                let tempMonth = components.month
                
                //check if temp month is same as the current month
                if (currentMonth == tempMonth){
                    //check if row name is already in the temp array -> if it doesn't, then add it
                    if (!tempMonthVacations.contains(row[0])) {
                        
                        tempMonthVacations.append(row[0])
                    }
                    
                }
                
            }
            
            return tempMonthVacations
        }
        
        //function to convert date from MM/DD/YYYY to YYYY-MM-DD for use in gathering month dates
        func ConvertDateISO (date: String) -> String {
            
            let splitString = date.split(separator: "/")
            let month = splitString[0]
            let day = splitString[1]
            let year = splitString[2]
            
            return "\(year)-\(month)-\(day)"
        }
        
        func RunCallListScript(csvFilePath: String, outputPath: String, vacations: [String]) -> String {
            
            let log = ""
            
            //directory where the python script will be
            let dirPythonCode = editQuotes(boolAdd: true, string: dirScripts!)
            
            //Initialize the PythonKit code
            let sys = Python.import("sys")
            
            print("Python Version: \(sys.version)")
            
            sys.path.append(dirPythonCode)
            
            //Import python code from "PythonKit_MARPToolbox.py code
            let pythonCode = Python.import("PythonKit_MARPCallList")
            
            //Run the python method
            _ = pythonCode.createCallList(csvFilePath, vacations, outputPath)
            
            return log
        }
        
        func CreateCallListPath(outputDIR: String, month: String, year: String) -> String {
            
            var outputString = ""
            
            //Determine the new output DIR according to the month and year chosen
            let newDIR = "\(outputDIR)/\(month) \(year)/"
            
            //Determine output path for the XLSX file
            outputString = "\(newDIR)DrugScreen-CallList-(\(month)-\(year)).xlsx"
            
            return outputString
        }
        
        
    }
    
}
