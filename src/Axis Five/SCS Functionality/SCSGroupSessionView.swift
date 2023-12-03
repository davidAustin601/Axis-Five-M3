//
//  SCSGroupSessionView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/18/21.
//
//  FILE DESCRIPTION: View used to create a new group session note

import SwiftUI

struct SCSGroupSessionView: View {
    
    //NEW ENVIRONMENT OBJECT
    @EnvironmentObject var SCSFunctions:SCSFunctionality
    
    //Global variable for handling preferences across views
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
    //Used for opening new "note preview window
    @Environment(\.openURL) var openURL
    //Used for keeping track of newly input information
    @State private var currentSession = SCSNoteInfo_GroupSession()
    
    var body: some View {
        
        //Main content
        ScrollView {
            
            //just enough padding on top to not cut off some of the textfield
            Spacer()
                .frame(height:1)

            //group used to get around item limit
            Group {
                
                //Group Name
                HStack {
                    Text("Group Name")
                        .textStyle(LabelTypeStyle())
                    TextField(currentSession.GroupName, text: $currentSession.GroupName)
                        .textFieldStyle(GlobalTextFieldStyle())
                }
                
                //Group Leaders
                HStack {
                    Text("Group Leaders")
                        .textStyle(LabelTypeStyle())
                    TextField(GlobalPreferences.SCSPrefs.groupLeaders, text: $currentSession.GroupLeaders)
                        .textFieldStyle(GlobalTextFieldStyle())
                }
                
                //Group Number Session
                HStack {
                    Text("Group Number Session")
                        .textStyle(LabelTypeStyle())
                    TextField(currentSession.GroupNumSession, text: $currentSession.GroupNumSession)
                        .textFieldStyle(GlobalTextFieldStyle())
                }
                
                //Group Number Present
                HStack {
                    Text("Number Present")
                        .textStyle(LabelTypeStyle())
                    TextField(currentSession.GroupNumPresent, text: $currentSession.GroupNumPresent)
                        .textFieldStyle(GlobalTextFieldStyle())
                }
                
                //Group Session Summary
                HStack {
                    Text("Group Session Summary")
                        .textStyle(LabelTypeStyle())
                    TextField(currentSession.GroupSessionSummary, text: $currentSession.GroupSessionSummary)
                        .textFieldStyle(GlobalTextFieldStyle())
                }
                
                //Group Next Meeting
                HStack {
                    Text("Nest Meeting Date")
                        .textStyle(LabelTypeStyle())
                    TextField(currentSession.GroupNextMeeting, text: $currentSession.GroupNextMeeting)
                        .textFieldStyle(GlobalTextFieldStyle())
                }
                
            }
            .padding(.leading,10)
            
            //Button at the bottom of the screen to create the note
            HStack {
                
                //Spacer used to make the button appear at the bottom right of the window
                Spacer()
                
                //Create note button
                Button("Create Note") {
                    
                    //Generate the new note
                    let newNote = SCSFunctions.Notes.GenerateSCSNote_GroupSession(templateFile: GlobalPreferences.SCSPrefs.groupSessionFile, inputValues: currentSession, groupLeaders: GlobalPreferences.SCSPrefs.groupLeaders)
                    
                    //Assign new note to global variable
                    SCSFunctions.Notes.CurrentNote = newNote ?? ""
                    
                    if let url = URL(string: "dialogs://NotePreview") {
                        openURL(url)
                    }
                }
                .buttonStyle(RunButtonStyle())
            }
        }
    }
}

struct SCSGroupSessionView_Previews: PreviewProvider {
    static var previews: some View {
        SCSGroupSessionView()
    }
}
