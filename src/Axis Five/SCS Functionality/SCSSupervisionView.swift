//
//  SCSIndividualView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/5/21.
//
//  FILE DESCRIPTION: View used to create a new individual session note

import SwiftUI

struct SCSSupervisionView: View {
    
    //NEW ENVIRONMENT OBJECT
    @EnvironmentObject var SCSFunctions: SCSFunctionality
    
    //Global variable for handling preferences across views
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
    
    //Used for opening new "note preview window
    @Environment(\.openURL) var openURL
    //Used for keeping track of newly input information
    @State private var currentSession = SCSNoteInfo_THSupervision()
    //Used for keeping trak of which client has been selected
    @State private var selectedSupervisee = ""
    
    //function to populate the Num Session variable after choosing a client
    func getNumSession_IncrementOne(superviseeName: String, supervisees: [SCSSupervisee]) {
        
        let tempTHInfo = SCSFunctions.Notes.GatherSuperviseeTHInfo(superviseeName: superviseeName, supervisees: supervisees)

        //assign num session variable as newly loaded THInfo Session Count
        currentSession.NumSession = String(Int(tempTHInfo.SessionCount)! + 1)
    }
    
    var body: some View {
        
        //Main content
        HStack{
            
            //Section to the left of the window with the list of clients to choose from
            VStack {
                
                //Section header
                Text("Supervisee")
                    .textStyle(BigLabelTypeStyle())
                
                //Scrollable list of clients to choose from
                ScrollView {
                    
                    ForEach(SCSFunctions.SuperviseeManagement.SuperviseeNameList, id:\.self) { name in
                        Text(name)
                            .foregroundColor(self.selectedSupervisee == name ? Color.white: Color.OffBlack)
                            .textStyle(LabelTypeStyle())
                            .onTapGesture {
                                self.selectedSupervisee = name
                            }
                            .onChange(of: selectedSupervisee, perform: { (value) in
                                getNumSession_IncrementOne(superviseeName: selectedSupervisee, supervisees: SCSFunctions.SuperviseeManagement.Supervisees)
                            })
                    }
                }
                .frame(width:175)
            }
            
            //Vertical divider betwween sections
            Divider()
                .frame(width:10)
            
            //Scrollable section to the right of the screen for inputing session data
            ScrollView {
               
                //just enough padding on top to not cut off some of the textfield
                Spacer()
                    .frame(height:1)
                
                //Group used to get around item limit in view
                Group {
                    //SESSION NUMBER & AFFECT
                    
                    HStack {
                    
                        Text("Session Number")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.NumSession, text: $currentSession.NumSession)
                            .textFieldStyle(GlobalTextFieldStyle())
                        
                        Text("Affect")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.Affect, text: $currentSession.Affect)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                   
                    //TOPICS COVERED
                    HStack {
                        Text("Topics Covered")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TopicsCovered, text: $currentSession.TopicsCovered)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //OTHER TOPICS COVERED
                    HStack {
                        Text("Other Topics Covered")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.OtherThingsWorkedOn, text: $currentSession.OtherThingsWorkedOn)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //IMPROVED
                    HStack {
                        Text("Improved")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.Improved, text: $currentSession.Improved)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //NEEDS WORK
                    HStack {
                        Text("Needs Work")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.NeedsWork, text: $currentSession.NeedsWork)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //WORK ON NEXT
                    HStack {
                        Text("Work On Next")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.WorkNext, text: $currentSession.WorkNext)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //NEXT SESSION
                    HStack {
                        Text("Next Session")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.NextSession, text: $currentSession.NextSession)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //HOMEWORK
                    HStack {
                        Text("Homework")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.Homework, text: $currentSession.Homework)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                }
                
                //Button at the bottom of the window to create the note
                HStack {
                    //Spacer used to make the button appear at the bottom right of the window
                    Spacer()
                    //Create note button
                    Button("Create Note") {
                        //Gather the selected client's telehealth information
                        //let clientTHInfo = SCSFunctions.Notes.GatherClientTHInfo(clientName: selectedClient, clients: SCSFunctions.ClientManagement.Clients)
                        
                        //Generate the new note
                        let newNote = SCSFunctions.Notes.GenerateSCSNote_Supervision(templateFile: GlobalPreferences.SCSPrefs.supervisionSessionFile, inputValues: currentSession)
                        
                        //Assign new note to global variable
                        SCSFunctions.Notes.CurrentNote = newNote ?? ""
                        
                        //assign incremented session count to the global array
                        SCSFunctions.SuperviseeManagement.Supervisees = SCSFunctions.Notes.SaveSupervisionIncrementedSessionCount(sessionCount: currentSession.NumSession, superviseeName: selectedSupervisee, supervisees: SCSFunctions.SuperviseeManagement.Supervisees)
                        
                        //SCSFunctions.ClientManagement.Clients = SCSFunctions.Notes.SaveIncrementedSessionCount(sessionCount: currentSession.NumSession, clientName: selectedClient, clients: SCSFunctions.ClientManagement.Clients)
                        
                        if let url = URL(string: "dialogs://NotePreview") {
                            openURL(url)
                        }
                    }
                    .buttonStyle(RunButtonStyle())
                }
            }
        }
        .padding(.leading, 5)
    }
}

struct SCSSupervisionView_Previews: PreviewProvider {
    static var previews: some View {
        SCSSupervisionView()
            .environmentObject(SCSFunctionality())
            .environmentObject(GlobalPreferences())
    }
}
