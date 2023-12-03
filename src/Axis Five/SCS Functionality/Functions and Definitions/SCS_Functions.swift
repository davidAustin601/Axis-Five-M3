//
//  SCS_Functions.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/16/21.
//
//  FILE DESCRIPTION: File used to manage all functions that are used throughout the various SCS functions

import Foundation
import SwiftUI
import SwiftCSV

//Outisde Definitions / Extensions
//Structure to manage scs clients
struct SCSClient:Hashable {
    var Name:String
    var Address:String
    var PhoneNumber:String
    var EmergencyContact:String
    var EmergencyPhone:String
    var SessionCount:String
}

extension SCSClient: Codable {
    init(dictionary: [String: String]) throws {
        self = try JSONDecoder().decode(SCSClient.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
    private enum CodingKeys: String, CodingKey {
        case Name = "Name", Address = "Address", PhoneNumber = "Phone Number", EmergencyContact = "Emergency Contact", EmergencyPhone = "Emergency Phone", SessionCount = "Session Count"
    }
}

extension SCSClient: CustomStringConvertible {
    var description: String {
        return "Name: " + Name + " - Address: " + Address + " - Phone Number: " + PhoneNumber + " - Emergency Contact: " + EmergencyContact + " - Emergency Phone: " + EmergencyPhone + " - Session Count: " + SessionCount
    }
}

//Outisde Definitions / Extensions
//Structure to manage scs supervisees
struct SCSSupervisee:Hashable {
    var Name:String
    var SessionCount:String
}

extension SCSSupervisee: Codable {
    init(dictionary: [String: String]) throws {
        self = try JSONDecoder().decode(SCSSupervisee.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
    private enum CodingKeys: String, CodingKey {
        case Name = "Name", SessionCount = "Session Count"
    }
}

extension SCSSupervisee: CustomStringConvertible {
    var description: String {
        return "Name: " + Name + " - Session Count: " + SessionCount
    }
}

//SCS - Class that handles all functionality
class SCSFunctionality: ObservableObject {
    
    //Initialize all inner classes
    @Published var ClientManagement:ClientManagement = ClientManagement() // class for handling SCS clients
    @Published var SuperviseeManagement:SuperviseeManagement = SuperviseeManagement() // class for handling SCS sueprvisees
    @Published var Notes:Notes = Notes()
    
    //Inner class - Client Management
    class ClientManagement: ObservableObject{
        
        //Variables
        @Published var Clients = [SCSClient]()
        @Published var ClientNameList = [String]()
        

        //function to read the CSV file that has all the SCS Client information
        func ReadCSVClientList (path: String) -> [[String:String]]{
            do {
                
                return try CSV(url: URL(fileURLWithPath: path), delimiter: "/").namedRows
                
            } catch {
                //catch errors from trying to load files
                //returns an empty array of dictionaries if there is an error loading the csv file
                return [[String:String]]()
            }
        }

        //function to read the CSV file that has all the SCS Client information
        func ReadCSVSuperviseeList (path: String) -> [[String:String]]{
            do {
                
                return try CSV(url: URL(fileURLWithPath: path), delimiter: "/").namedRows
                
            } catch {
                //catch errors from trying to load files
                //returns an empty array of dictionaries if there is an error loading the csv file
                return [[String:String]]()
            }
        }
        
        //function to create a list of marpmember names
        func CreateClientNameList (clients: [SCSClient]) -> [String]{
            
            var tempList = [String]()
            
            clients.forEach { SCSClient in
                tempList.append(SCSClient.Name)
            }
            
            return tempList
        }

        func SCSClientListWriteToCSV(path: String, clientList: [SCSClient]) {
            
            var csvString = ""
            
            //create the headers
            let columnHeaders = "Name/Address/Phone Number/Emergency Contact/Emergency Phone/Session Count" + "\n"
            csvString += columnHeaders
            
            //cycle through each [MarpMember] array and add a new line to the string
            for client in clientList {
                
                csvString += client.Name.trimmingCharacters(in: .whitespacesAndNewlines) + "/" + client.Address.trimmingCharacters(in: .whitespacesAndNewlines) + "/" + client.PhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines) + "/" + client.EmergencyContact.trimmingCharacters(in: .whitespacesAndNewlines) + "/" + client.EmergencyPhone.trimmingCharacters(in: .whitespacesAndNewlines) + "/" + client.SessionCount.trimmingCharacters(in: .whitespacesAndNewlines) + "\n"
            }
            
            //write to the pathd
            let filepath = URL(fileURLWithPath: path)
            
            try? csvString.write(to: filepath, atomically: true, encoding: .utf8)
        }

        //convert array of dictionaries to an array of SCSClient structs
        func CreateSCSClientArray (Clients: [[String:String]]) -> [SCSClient] {
            
            var clientArray:[SCSClient] = [SCSClient]()
            
            //cycle through the array of dictionaries
            for clientDic in Clients {
                
                //create a temp SCSClient struct and import the dictionary
                let tempClientStruct = try? SCSClient(dictionary: clientDic)
                
                //if no error then add to the clientarray
                if tempClientStruct != nil {
                    clientArray.append(tempClientStruct!)
                }
                
            }
            
            return clientArray
        }
        
        func AddClientToClientArray (client: SCSClient) -> [SCSClient] {
            
            var tempArray = Clients
            
            if !CheckNameIsInList(list: ClientNameList, name: client.Name) {
                
                tempArray.append(client)
                
            }
            
            return tempArray
        }
        
        func AddClientToNameArray (clientName: String) -> [String] {
            
            var tempArray = ClientNameList
            
            tempArray.append(clientName)
            
            return tempArray
        }

        //function to remove SCSClient from a [SCSClient] array
        func RemoveClientFromClientArray (clientName: String) -> [SCSClient]{
            
            var tempArray = [SCSClient]()
            
            //Remove from the MarpMember array
            for (index, client) in Clients.enumerated() {
                
                //check if the name is the same as input parameter
                if clientName == client.Name {
                    //remove at index
                    Clients.remove(at: index)
                }
            }
            
            //assign the edite [MarpMember] to the temporary [MarpMember] array
            tempArray = Clients
            
            return tempArray
        }

        //function to remove member name from global Marp Member name list
        func RemoveClientFromNameArray(clientName: String) -> [String]{
            
            var tempArray = [String]()
            
            //Remove from the Member Name List
            for (index, client) in ClientNameList.enumerated() {
                if clientName == client {
                    ClientNameList.remove(at: index)
                }
            }
            
            //assign the edite [MarpMember] to the temporary [MarpMember] array
            tempArray = ClientNameList
            
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
        
        //Function to create string of client information
        func GatherClientInfoForTextBox (name: String?) -> String {
            var tempString = ""
            
            Clients.forEach() { item in
                
                if item.Name == name {
                    
                    tempString = """
                        Name: \(item.Name)
                        Address: \(item.Address)
                        Phone Number: \(item.PhoneNumber)
                        Emergency Contact: \(item.EmergencyContact)
                        Emergency Phone: \(item.EmergencyPhone)
                        Session Count: \(item.SessionCount)
                        """
                }
                
            }
            
            return tempString
        }
    }
    
    //Inner class - Supervisee Management
    class SuperviseeManagement: ObservableObject{
        
        //Variables
        @Published var Supervisees = [SCSSupervisee]()
        @Published var SuperviseeNameList = [String]()


        //function to read the CSV file that has all the SCS Client information
        func ReadCSVSuperviseeList (path: String) -> [[String:String]]{
            do {
                
                return try CSV(url: URL(fileURLWithPath: path), delimiter: "/").namedRows
                
            } catch {
                //catch errors from trying to load files
                //returns an empty array of dictionaries if there is an error loading the csv file
                return [[String:String]]()
            }
        }
        
        //function to create a list of marpmember names
        func CreateSuperviseeNameList (supervisees: [SCSSupervisee]) -> [String]{
            
            var tempList = [String]()
            
            supervisees.forEach { SCSSupervisee in
                tempList.append(SCSSupervisee.Name)
            }
            
            return tempList
        }

        func SCSSuperviseeListWriteToCSV(path: String, superviseeList: [SCSSupervisee]) {
            
            var csvString = ""
            
            //create the headers
            let columnHeaders = "Name/Session Count" + "\n"
            csvString += columnHeaders
            
            //cycle through each [SCSSupervisee] array and add a new line to the string
            for supervisee in superviseeList {
                
                csvString += supervisee.Name.trimmingCharacters(in: .whitespacesAndNewlines) + "/" + supervisee.SessionCount.trimmingCharacters(in: .whitespacesAndNewlines) + "\n"
            }
            
            //write to the pathd
            let filepath = URL(fileURLWithPath: path)
            
            try? csvString.write(to: filepath, atomically: true, encoding: .utf8)
        }

        //convert array of dictionaries to an array of SCSClient structs
        func CreateSCSSuperviseeArray (Supervisees: [[String:String]]) -> [SCSSupervisee] {
            
            var superviseeArray:[SCSSupervisee] = [SCSSupervisee]()
            
            //cycle through the array of dictionaries
            for superviseeDic in Supervisees {
                
                //create a temp SCSClient struct and import the dictionary
                let tempSuperviseeStruct = try? SCSSupervisee(dictionary: superviseeDic)
                
                //if no error then add to the clientarray
                if tempSuperviseeStruct != nil {
                    superviseeArray.append(tempSuperviseeStruct!)
                }
                
            }
            
            return superviseeArray
        }
        
        func AddSupeviseeToSuperviseeArray (supervisee: SCSSupervisee) -> [SCSSupervisee] {
            
            var tempArray = Supervisees
            
            if !CheckNameIsInList(list: SuperviseeNameList, name: supervisee.Name) {
                
                tempArray.append(supervisee)
                
            }
            
            return tempArray
        }
        
        func AddSuperviseeToNameArray (superviseeName: String) -> [String] {
            
            var tempArray = SuperviseeNameList
            
            tempArray.append(superviseeName)
            
            return tempArray
        }

        //function to remove SCSClient from a [SCSClient] array
        func RemoveSuperviseeFromSuperviseeArray (superviseeName: String) -> [SCSSupervisee]{
            
            var tempArray = [SCSSupervisee]()
            
            //Remove from the MarpMember array
            for (index, supervisee) in Supervisees.enumerated() {
                
                //check if the name is the same as input parameter
                if superviseeName == supervisee.Name {
                    //remove at index
                    Supervisees.remove(at: index)
                }
            }
            
            //assign the edite [MarpMember] to the temporary [MarpMember] array
            tempArray = Supervisees
            
            return tempArray
        }

        //function to remove member name from global Marp Member name list
        func RemoveSuperviseeFromNameArray(superviseeName: String) -> [String]{
            
            var tempArray = [String]()
            
            //Remove from the Member Name List
            for (index, supervisee) in SuperviseeNameList.enumerated() {
                if superviseeName == supervisee {
                    SuperviseeNameList.remove(at: index)
                }
            }
            
            //assign the edite [MarpMember] to the temporary [MarpMember] array
            tempArray = SuperviseeNameList
            
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
        
        //Function to create string of client information
        func GatherSuperviseeInfoForTextBox (name: String?) -> String {
            var tempString = ""
            
            Supervisees.forEach() { item in
                
                if item.Name == name {
                    
                    tempString = """
                        Name: \(item.Name)
                        Session Count: \(item.SessionCount)
                        """
                }
                
            }
            
            return tempString
        }
    }
    
    //Inner class - Notes (used for all types of notes)
    class Notes: ObservableObject{
        
        //Initalize Variables / Structures
        @Published var symbols:SCSNoteSymbols = SCSNoteSymbols() //Used to manage all symbols for creation of notes
        @Published var CurrentNote:String = "TEST" //Used to generate note and show note in new window
        
        //Structure to hold all the symbols for creating SCS notes
        struct SCSNoteSymbols {
            
            //Telehealth General Information
            var TH_Address:[String]
            var TH_PhoneNumber:[String]
            var TH_EmergencyContact:[String]
            var TH_EmergencyPhone:[String]
            
            //Telehealth Individual Session
            var NumSession:[String]
            var TopicsCovered:[String]
            var OtherThingsWorkedOn:[String]
            var Affect:[String]
            var Improved:[String]
            var NeedsWork:[String]
            var WorkNext:[String]
            var NextSession:[String]
            var Homework:[String]
            
            //Telehealth Initial Session
            var Pronoun:[String]
            var PossessivePronoun:[String]
            var ReflexivePronoun:[String]
            var ThirdPersonPronoun:[String]
            var Referral:[String]
            var MainProblems:[String]
            var SecondaryProblems:[String]
            var EatSleepProblems:[String]
            var SIHistory:[String]
            var HIHistory:[String]
            var SelfInjuryHistory:[String]
            var OptAdditionalBehavioral:[String]
            var Abuse:[String]
            var OptAdditionalAbuse:[String]
            var Trauma:[String]
            var OptAdditionaTrauma:[String]
            var AlcoholFrequency:[String]
            var SubstanceFrequency:[String]
            var SubstanceList:[String]
            var OptAdditionalSubstance:[String]
            var Grade:[String]
            var Major:[String]
            var MajorSatisfaction:[String]
            var Employment:[String]
            var OtherData:[String]
            var Demographics:[String]
            var OutsideReferral:[String]
            var Plan:[String]
            
            //Initial Contact Note
            var Name:[String]
            var Date:[String]
            var Time:[String]
            
            //Group Session Note
            var GroupName:[String]
            var GroupLeaders:[String]
            var GroupNumSession:[String]
            var GroupNumPresent:[String]
            var GroupSessionSummary:[String]
            var GroupNextMeeting:[String]
            
            //Individual Termination Note
            var TermIntakeDate:[String]
            var TermLastServiceDate:[String]
            var TermNumSession:[String]
            var TermNumTriage:[String]
            var TermNumIntake:[String]
            var TermNumIndividual:[String]
            var TermNumAdvocacy:[String]
            var TermNumOther:[String]
            var TermPresentingProb:[String]
            var TermDiagnosisIntake:[String]
            var TermTopcisCovered:[String]
            var TermImproved:[String]
            var TermNeedsWork:[String]

            init () {
                //Telehealth General Information
                TH_Address = ["{CurrentAddress}", "Address of where the client is during the time of the session."]
                TH_PhoneNumber = ["{BackupPhone}", "Phone number the client can be reached at in case of technology issues."]
                TH_EmergencyContact = ["{EmergencyName}", "Name of emergency contact the client has provide."]
                TH_EmergencyPhone = ["{EmergencyPhone}", "Phone number of the client's emergency contact."]
                
                //Telehealth Individual Session
                NumSession = ["{NumSession}", "The number of session that has been completed since the beginning of the semester"]
                TopicsCovered = ["{Topics}", "The major things that were covered during this session"]
                OtherThingsWorkedOn = ["{OtherWorked}", "Other areas that were addressed during this session"]
                Affect = ["{Affect}", "The clients affect throughout the session"]
                Improved = ["{Improved}", "Areas of growth or other improvement the client is exhibiting"]
                NeedsWork = ["{NeedsWork}", "Areas that it may be helpful for the client to continue working on"]
                WorkNext = ["{WorkNext}", "Topics that will be convered during the next session"]
                NextSession = ["{NextSession}", "The date for when the next session will be completed"]
                Homework = ["{Homework}", "Homework that was given to the client"]
                
                //Telehealth Initial Session
                Pronoun = ["{Pronoun}", "Pronoun used by the client. (e.g., she, he)"]
                PossessivePronoun = ["{PPossessive}", "Possesive pronoun of the client (e.g., her)"]
                ReflexivePronoun = ["{PReflexive}", "Reflexive pronoun of the client (e.g., herself, himself)"]
                ThirdPersonPronoun = ["{ThirdPersonPronoun}", "Third person pronoun of the client (e.g., her, him)"]
                Referral = ["{Referral}", "Who recommended / referred the client to treatment (e.g., self)"]
                MainProblems = ["{MainProblems}", "The top presenting concerns the client has (e.g., depression and anxiety symptoms, struggles with relationships"]
                SecondaryProblems = ["{SecondaryProblems - minimum 3}", "Secondary presenting concerns the client has - minimum 3"]
                EatSleepProblems = ["{EatSleepProblems}", "Any presenting concerns that revolve around eating and / or sleeping (e.g., difficulties getting and staying asleep"]
                SIHistory = ["{SIandHistory}", "Any current suicidal ideation as well as their history with suicidal ideation (e.g., passive suicidal ideation with no plan as well as a history of passive ideation"]
                HIHistory = ["{HI}", "Any current homicidal ideation"]
                SelfInjuryHistory = ["{SelfInjuryandHistory}", "Any current self-injurious behaviors and history of self-harm (e.g., no current self-injury nor history of self-harm"]
                OptAdditionalBehavioral = ["{(Opt)AdditionalBehavioralComment}", "Any additional relavent SI/HI/Self Injury information"]
                Abuse = ["{AbuseAndType}", "Any experiences of abuse during or after childhood as well as type of abuse experienced (e.g., emotional abuse by parents)"]
                OptAdditionalAbuse = ["{(Opt)AdditionalAbuseComment}", "Any additional comments regarding abuse"]
                Trauma = ["{Trauma}", "Trauma experienced by the client (e.g., experiencing sexual assault, experiencing loss of a parent"]
                OptAdditionaTrauma = ["{(Opt)AdditionalTraumaComment}", "Any additional comments regarding trauma experienced by the client"]
                AlcoholFrequency = ["{AlcoholFrequency}", "The frequency of the client's use of alcohol (e.g., drinking approximately 2-3 per week with 1-2 drinks per sitting"]
                SubstanceFrequency = ["{SubstanceFrequency}", "Rate at which the client uses substance beside alcohol (e.g., weekly, daily, monthly)"]
                SubstanceList = ["{SubstanceList}", "List of substances the client uses beside alcohol (e.g., marijuana, cocaine)"]
                OptAdditionalSubstance = ["{(Opt)AdditionalSubComment}", "Any additional comments regarding use of substances"]
                Grade = ["{Grade}", "Grade the client is currently in (e.g., freshman, senior)"]
                Major = ["{Major}", "Client's current major (e.g., engeineering)"]
                MajorSatisfaction = ["{MajorSatisfaction}", "How much the client likes their current major (e.g., moderately, significantly)"]
                Employment = ["{EmploymentStatusAndSatisfaction}", "Whether or not the client is current employed and how much they like or don't like the job"]
                OtherData = ["{OtherRelevantData}", "Any other additional comments regarding any other relavent information"]
                Demographics = ["{Demo}", "Client's age, race, sexual orientation, and gender identity"]
                OutsideReferral = ["{OutsideReferral}", "Any referral to a department or outside organization"]
                Plan = ["{Plan}", "The next step with regard to the therapeutic relationship (e.g., The Client and clinician will meet up again on ...)"]
                
                //Initial Contact Note
                Name = ["{Name}", "First name of client when sending an email for initial contact"]
                Date = ["{Date}", "Date of initial appointment when sending email for initial contact"]
                Time = ["{Time}", "Time of the day of initial appointment when sending email for initial contact"]
                
                //Group Session Note
                GroupName = ["{GroupName}", "Name of the group run"]
                GroupLeaders = ["{GroupLeaders}", "Name of individuals who ran the group"]
                GroupNumSession = ["{GroupNumSession}", "Session number of the group meeting"]
                 GroupNumPresent = ["{GroupNumPresent}", "Number of members that attended the group meeting"]
                 GroupSessionSummary = ["{GroupSessionSummary}", "Summary of the group meeting and topics covered"]
                 GroupNextMeeting = ["{GroupNextMeeting}", "Date and time of when the group will meet next"]
                
                //Individual Termination Note
                 TermIntakeDate = ["{IntakeDate}", "The date when the client first had their intake"]
                 TermLastServiceDate = ["{LastServiceDate}", "Last date the client and clinician met"]
                 TermNumSession = ["{NumSessions}", "Number of sessions the client had throughout the semester"]
                 TermNumTriage = ["{NumTriage}", "Number of traiges the client had throughout the semester"]
                 TermNumIntake = ["{NumIntake}", "Number of intakes the client had throughout the semseter"]
                 TermNumIndividual = ["{NumIndividual}", "Number of individual sessions the client had throughout the semester"]
                 TermNumAdvocacy = ["{NumAdvocacy}", "Number of advocacy sessions the client had throughout the semester"]
                 TermNumOther = ["{NumOther}", "Number of other type sessions the client had throughout the semester"]
                 TermPresentingProb = ["{PresentingProb}", "The presenting concerns the client reported during the intake"]
                 TermDiagnosisIntake = ["{DiagnosisIntake}", "Intake given to the client during the intake process"]
                 TermTopcisCovered = ["{TopicsCovered}", "Things worked on with the clinician throughout the semester"]
                 TermImproved = ["{Improved}", "Ways client has grown throughout the semester"]
                 TermNeedsWork = ["{NeedsWork}", "Things the client may need to continue working on outside of therapy"]
            }
        }
        
        //Function for gathering selected client's telehealth information to be placed in session info
        func GatherClientTHInfo (clientName: String, clients: [SCSClient]) -> SCSTHInfo {
            
            var tempTHInfo = SCSTHInfo()
            
            //cycle through the global clients
            for client in clients {
                
                //check if name is equal to the name parameter
                if (client.Name == clientName) {
                    
                    //add the client's TH info
                    tempTHInfo.Address = client.Address
                    tempTHInfo.PhoneNumber = client.PhoneNumber
                    tempTHInfo.EmergencyContact = client.EmergencyContact
                    tempTHInfo.EmergencyPhone = client.EmergencyPhone
                    tempTHInfo.SessionCount = client.SessionCount
                    
                    //breat out of loop
                    break
                }
                
            }
            
            return tempTHInfo
        }
        
        //Function for gathering selected supervisee's information to be placed in session info
        func GatherSuperviseeTHInfo (superviseeName: String, supervisees: [SCSSupervisee]) -> SCSTHInfo {
            
            var tempTHInfo = SCSTHInfo()
            
            //cycle through the global clients
            for supervisee in supervisees {
                
                //check if name is equal to the name parameter
                if (supervisee.Name == superviseeName) {
                    
                    tempTHInfo.SessionCount = supervisee.SessionCount
                    
                    //breat out of loop
                    break
                }
                
            }
            
            return tempTHInfo
        }
        
        //function to convert a digit / number (in string format) into the ordinal version (e.g., "1" -> "1st", "2" -> "2nd")
        func GenerateOrdinalNumber (numberString: String) -> String {
            
            switch (numberString) {
            case "1":
                return "1st"
            case "2":
                return "2nd"
            case "3":
                return "3rd"
            default:
                return "\(numberString)th"
            }
        }

        //function used to generate note - input template file, import symbols that are used, import newly create note structure
        func GenerateSCSNote_Individual(templateFile: String, inputValues: SCSNoteInfo_THIndividual, telehealthInfo: SCSTHInfo) -> String?{
            
            do {
                
                //read the template file and assign the contents into a new string variable
                var newNote = try String(contentsOfFile: templateFile)

                //go through each symbol and find / replace within the new Note String
                
                //telehealth information
                //address
                newNote = newNote.replacingOccurrences(of: symbols.TH_Address[0], with: telehealthInfo.Address)
                //phone number
                newNote = newNote.replacingOccurrences(of: symbols.TH_PhoneNumber[0], with: telehealthInfo.PhoneNumber)
                //emergency contact
                newNote = newNote.replacingOccurrences(of: symbols.TH_EmergencyContact[0], with: telehealthInfo.EmergencyContact)
                //emergency phone
                newNote = newNote.replacingOccurrences(of: symbols.TH_EmergencyPhone[0], with: telehealthInfo.EmergencyPhone)
                
                //Num Session
                newNote = newNote.replacingOccurrences(of: symbols.NumSession[0], with: GenerateOrdinalNumber(numberString: inputValues.NumSession))
                //Topics Covered
                newNote = newNote.replacingOccurrences(of: symbols.TopicsCovered[0], with: inputValues.TopicsCovered)
                //Other Things Worked On
                newNote = newNote.replacingOccurrences(of: symbols.OtherThingsWorkedOn[0], with: inputValues.OtherThingsWorkedOn)
                //Affect
                newNote = newNote.replacingOccurrences(of: symbols.Affect[0], with: inputValues.Affect)
                //Improved
                newNote = newNote.replacingOccurrences(of: symbols.Improved[0], with: inputValues.Improved)
                //Needs Work
                newNote = newNote.replacingOccurrences(of: symbols.NeedsWork[0], with: inputValues.NeedsWork)
                //Work Next
                newNote = newNote.replacingOccurrences(of: symbols.WorkNext[0], with: inputValues.WorkNext)
                //Next Session
                newNote = newNote.replacingOccurrences(of: symbols.NextSession[0], with: inputValues.NextSession)
                //Homework
                newNote = newNote.replacingOccurrences(of: symbols.Homework[0], with: inputValues.Homework)
                
                print(newNote)
                
                return newNote
                
            } catch {
                // contents could not be loaded
                return nil
            }
        }

        //function used to generate supervision session note - input template file, import symbols that are used, import newly create note structure
        func GenerateSCSNote_Supervision(templateFile: String, inputValues: SCSNoteInfo_THSupervision) -> String?{
            
            do {
                
                //read the template file and assign the contents into a new string variable
                var newNote = try String(contentsOfFile: templateFile)

                //go through each symbol and find / replace within the new Note String
                
                //Using the "individual note" template for adding info to the supervision note
            
                //Num Session
                newNote = newNote.replacingOccurrences(of: symbols.NumSession[0], with: GenerateOrdinalNumber(numberString: inputValues.NumSession))
                //Topics Covered
                newNote = newNote.replacingOccurrences(of: symbols.TopicsCovered[0], with: inputValues.TopicsCovered)
                //Other Things Worked On
                newNote = newNote.replacingOccurrences(of: symbols.OtherThingsWorkedOn[0], with: inputValues.OtherThingsWorkedOn)
                //Affect
                newNote = newNote.replacingOccurrences(of: symbols.Affect[0], with: inputValues.Affect)
                //Improved
                newNote = newNote.replacingOccurrences(of: symbols.Improved[0], with: inputValues.Improved)
                //Needs Work
                newNote = newNote.replacingOccurrences(of: symbols.NeedsWork[0], with: inputValues.NeedsWork)
                //Work Next
                newNote = newNote.replacingOccurrences(of: symbols.WorkNext[0], with: inputValues.WorkNext)
                //Next Session
                newNote = newNote.replacingOccurrences(of: symbols.NextSession[0], with: inputValues.NextSession)
                //Homework
                newNote = newNote.replacingOccurrences(of: symbols.Homework[0], with: inputValues.Homework)
                
                print(newNote)
                
                return newNote
                
            } catch {
                // contents could not be loaded
                return nil
            }
        }
        
        //function used to generate note - input template file, import symbols that are used, import newly create note structure
        func GenerateSCSNote_Intake(templateFile: String, inputValues: SCSNoteInfo_THIntake) -> String?{
            
            do {
                
                //read the template file and assign the contents into a new string variable
                var newNote = try String(contentsOfFile: templateFile)
                
                //go through each symbol and find / replace within the new Note String
                
                //telehealth information
                //address
                newNote = newNote.replacingOccurrences(of: symbols.TH_Address[0], with: inputValues.Address)
                //phone number
                newNote = newNote.replacingOccurrences(of: symbols.TH_PhoneNumber[0], with: inputValues.PhoneNumber)
                //emergency contact
                newNote = newNote.replacingOccurrences(of: symbols.TH_EmergencyContact[0], with: inputValues.EmergencyContact)
                //emergency phone
                newNote = newNote.replacingOccurrences(of: symbols.TH_EmergencyPhone[0], with: inputValues.EmergencyPhone)
                
                //general intake information
                
                //Pronoun
                newNote = newNote.replacingOccurrences(of: symbols.Pronoun[0], with: inputValues.Pronoun)
                //Possessive Pronoun
                newNote = newNote.replacingOccurrences(of: symbols.PossessivePronoun[0], with: inputValues.PossessivePronoun)
                //Reflexive Pronount
                newNote = newNote.replacingOccurrences(of: symbols.ReflexivePronoun[0], with: inputValues.ReflexivePronoun)
                //Third Person Pronoun
                newNote = newNote.replacingOccurrences(of: symbols.ThirdPersonPronoun[0], with: inputValues.ThirdPersonPronoun)

                //Referral
                newNote = newNote.replacingOccurrences(of: symbols.Referral[0], with: inputValues.Referral)
                //Main Problems
                newNote = newNote.replacingOccurrences(of: symbols.MainProblems[0], with: inputValues.MainProblems)
                //Secondary Problems
                newNote = newNote.replacingOccurrences(of: symbols.SecondaryProblems[0], with: inputValues.SecondaryProblems)
                //EatSleepProblems
                newNote = newNote.replacingOccurrences(of: symbols.EatSleepProblems[0], with: inputValues.EatSleepProblems)
                //SIHistory
                newNote = newNote.replacingOccurrences(of: symbols.SIHistory[0], with: inputValues.SIHistory)
                //HIHistory
                newNote = newNote.replacingOccurrences(of: symbols.HIHistory[0], with: inputValues.HIHistory)
                //SelfInjuryHistory
                newNote = newNote.replacingOccurrences(of: symbols.SelfInjuryHistory[0], with: inputValues.SelfInjuryHistory)
                //OptAdditionalBehavioral
                newNote = newNote.replacingOccurrences(of: symbols.OptAdditionalBehavioral[0], with: inputValues.OptAdditionalBehavioral)
                //Abuse
                newNote = newNote.replacingOccurrences(of: symbols.Abuse[0], with: inputValues.Abuse)
                //OptAdditionalAbuse
                newNote = newNote.replacingOccurrences(of: symbols.OptAdditionalAbuse[0], with: inputValues.OptAdditionalAbuse)
                //Trauma
                newNote = newNote.replacingOccurrences(of: symbols.Trauma[0], with: inputValues.Trauma)
                //OptAdditionalTrauma
                newNote = newNote.replacingOccurrences(of: symbols.OptAdditionaTrauma[0], with: inputValues.OptAdditionaTrauma)
                //AlcoholFrequency
                newNote = newNote.replacingOccurrences(of: symbols.AlcoholFrequency[0], with: inputValues.AlcoholFrequency)
                //SubstanceFrequency
                newNote = newNote.replacingOccurrences(of: symbols.SubstanceFrequency[0], with: inputValues.SubstanceFrequency)
                //SubstanceList
                newNote = newNote.replacingOccurrences(of: symbols.SubstanceList[0], with: inputValues.SubstanceList)
                //OptAdditionalSubstance
                newNote = newNote.replacingOccurrences(of: symbols.OptAdditionalSubstance[0], with: inputValues.OptAdditionalSubstance)
                //Grade
                newNote = newNote.replacingOccurrences(of: symbols.Grade[0], with: inputValues.Grade)
                //Major
                newNote = newNote.replacingOccurrences(of: symbols.Major[0], with: inputValues.Major)
                //MajorSatisfaction
                newNote = newNote.replacingOccurrences(of: symbols.MajorSatisfaction[0], with: inputValues.MajorSatisfaction)
                //Employment
                newNote = newNote.replacingOccurrences(of: symbols.Employment[0], with: inputValues.Employment)
                //OtherData
                newNote = newNote.replacingOccurrences(of: symbols.OtherData[0], with: inputValues.OtherData)
                //Demographics
                newNote = newNote.replacingOccurrences(of: symbols.Demographics[0], with: inputValues.Demographics)
                //OutsideReferral
                newNote = newNote.replacingOccurrences(of: symbols.OutsideReferral[0], with: inputValues.OutsideReferral)
                //Plan
                newNote = newNote.replacingOccurrences(of: symbols.Plan[0], with: inputValues.Plan)
                
                return newNote
                
            } catch {
                // contents could not be loaded
                return nil
            }
        }

        //function used to generate note - input template file, import symbols that are used, import newly create note structure
        func GenerateSCSNote_InitialContact(templateFile: String, inputValues: SCSNoteInfo_InitialContact) -> String?{
            
            do {
                
                //read the template file and assign the contents into a new string variable
                var newNote = try String(contentsOfFile: templateFile)
                
                
                //go through each symbol and find / replace within the new Note String
                
                //Name
                newNote = newNote.replacingOccurrences(of: symbols.Name[0], with: inputValues.Name)
                //Date
                newNote = newNote.replacingOccurrences(of: symbols.Date[0], with: inputValues.Date)
                //Time
                newNote = newNote.replacingOccurrences(of: symbols.Time[0], with: inputValues.Time)
            
                return newNote
                
            } catch {
                // contents could not be loaded
                return nil
            }
        }

        //function used to generate note - input template file, import symbols that are used, import newly create note structure
        func GenerateSCSNote_GroupSession(templateFile: String, inputValues: SCSNoteInfo_GroupSession, groupLeaders: String) -> String?{
            
            do {
                
                //read the template file and assign the contents into a new string variable
                var newNote = try String(contentsOfFile: templateFile)
                
                //go through each symbol and find / replace within the new Note String
                
                //Group Name
                newNote = newNote.replacingOccurrences(of: symbols.GroupName[0], with: inputValues.GroupName)
                //Group Leaders
                newNote = newNote.replacingOccurrences(of: symbols.GroupLeaders[0], with: groupLeaders)
                //Num Session
                newNote = newNote.replacingOccurrences(of: symbols.GroupNumSession[0], with: inputValues.GroupNumSession)
                //Num Present
                newNote = newNote.replacingOccurrences(of: symbols.GroupNumPresent[0], with: inputValues.GroupNumPresent)
                //Session Summary
                newNote = newNote.replacingOccurrences(of: symbols.GroupSessionSummary[0], with: inputValues.GroupSessionSummary)
                //Next Session
                newNote = newNote.replacingOccurrences(of: symbols.GroupNextMeeting[0], with: inputValues.GroupNextMeeting)
            
                return newNote
                
            } catch {
                // contents could not be loaded
                return nil
            }
        }

        //function used to generate note - input template file, import symbols that are used, import newly create note structure
        func GenerateSCSNote_IndividualTermination(templateFile: String, inputValues: SCSNoteInfo_IndividualTermination) -> String?{
            
            do {
                
                //read the template file and assign the contents into a new string variable
                var newNote = try String(contentsOfFile: templateFile)
                
                //go through each symbol and find / replace within the new Note String
                //Pronoun
                newNote = newNote.replacingOccurrences(of: symbols.Pronoun[0], with: inputValues.Pronoun)
                //Possessive Pronoun
                newNote = newNote.replacingOccurrences(of: symbols.PossessivePronoun[0], with: inputValues.PPronoun)
                //Intake Date
                newNote = newNote.replacingOccurrences(of: symbols.TermIntakeDate[0], with: inputValues.TermIntakeDate)
                //Last Service Date
                newNote = newNote.replacingOccurrences(of: symbols.TermLastServiceDate[0], with: inputValues.TermLastServiceDate)
                //Num Sessions
                newNote = newNote.replacingOccurrences(of: symbols.TermNumSession[0], with: inputValues.TermNumSessions)
                //Num Triages
                newNote = newNote.replacingOccurrences(of: symbols.TermNumTriage[0], with: inputValues.TermNumTriage)
                //Num Intakes
                newNote = newNote.replacingOccurrences(of: symbols.TermNumIntake[0], with: inputValues.TermNumIntake)
                //Num Individual
                newNote = newNote.replacingOccurrences(of: symbols.TermNumIndividual[0], with: inputValues.TermNumIndividual)
                //Num Advocacy
                newNote = newNote.replacingOccurrences(of: symbols.TermNumAdvocacy[0], with: inputValues.TermNumAdvocacy)
                //Num Other
                newNote = newNote.replacingOccurrences(of: symbols.TermNumOther[0], with: inputValues.TermNumOther)
                //Presenting Problem
                newNote = newNote.replacingOccurrences(of: symbols.TermPresentingProb[0], with: inputValues.TermPresentingProb)
                //Diagnosis Intake
                newNote = newNote.replacingOccurrences(of: symbols.TermDiagnosisIntake[0], with: inputValues.TermDiagnosisIntake)
                //Topics Covered
                newNote = newNote.replacingOccurrences(of: symbols.TermTopcisCovered[0], with: inputValues.TermTopicsCovered)
                //Improved
                newNote = newNote.replacingOccurrences(of: symbols.TermImproved[0], with: inputValues.TermImproved)
                //Needs Work
                newNote = newNote.replacingOccurrences(of: symbols.TermNeedsWork[0], with: inputValues.TermNeedsWork)

                return newNote
                
            } catch {
                // contents could not be loaded
                return nil
            }
        }

        //function to save the incremented session count to the global clients array
        func SaveIncrementedSessionCount(sessionCount: String, clientName: String, clients: [SCSClient]) -> [SCSClient] {
            
            //create temp client array to be returned at the end
            var tempClientArray = [SCSClient]()
            
            //loop through each client in the inputed client array
            for var client in clients {
                
                //if name of client is the same as the inputed name
                if (client.Name == clientName) {
                    
                    //assign the inputed session count to the current client in loop
                    client.SessionCount = sessionCount
                }
                
                //add the SCSClient to the temp array
                tempClientArray.append(client)
            }

            
            return tempClientArray
        }
        
        //function to save the incremented supervision session count to the global clients array
        func SaveSupervisionIncrementedSessionCount(sessionCount: String, superviseeName: String, supervisees: [SCSSupervisee]) -> [SCSSupervisee] {
            
            //create temp client array to be returned at the end
            var tempSuperviseeArray = [SCSSupervisee]()
            
            //loop through each client in the inputed client array
            for var supervisee in supervisees {
                
                //if name of client is the same as the inputed name
                if (supervisee.Name == superviseeName) {
                    
                    //assign the inputed session count to the current client in loop
                    supervisee.SessionCount = sessionCount
                }
                
                //add the SCSClient to the temp array
                tempSuperviseeArray.append(supervisee)
            }

            
            return tempSuperviseeArray
        }
        
    }
    
    
}












