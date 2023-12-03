//
//  SCSInitialContactView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/18/21.
//
//  FILE DESCRIPTION: View used to create a new initial contant note used for emailing the client 

import SwiftUI

struct SCSInitialContactView: View {
    
    //NEW ENVIRONMENT OBJECT
    @EnvironmentObject var SCSFunctions:SCSFunctionality
    
    //Global variable for handling preferences across views
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
    //Used for opening new "note preview window
    @Environment(\.openURL) var openURL
    //Used for keeping track of newly input information
    @State private var currentSession = SCSNoteInfo_InitialContact()
    
    var body: some View {
        
        //Main content
        ScrollView {
            
            //just enough padding on top to not cut off some of the textfield
            Spacer()
                .frame(height:1)
            
            //Group usedto get around item limit
            Group {
                
                //CLIENT FIRST NAME
                HStack {
                    Text("Client First Name")
                        .textStyle(LabelTypeStyle())
                    TextField(currentSession.Name, text: $currentSession.Name)
                        .textFieldStyle(GlobalTextFieldStyle())
                }
                
                //DATE
                HStack {
                    Text("Date of Appointment")
                        .textStyle(LabelTypeStyle())
                    TextField(currentSession.Date, text: $currentSession.Date)
                        .textFieldStyle(GlobalTextFieldStyle())
                }
                
                //TIME
                HStack {
                    Text("Time of Appointment")
                        .textStyle(LabelTypeStyle())
                    TextField(currentSession.Time, text: $currentSession.Time)
                        .textFieldStyle(GlobalTextFieldStyle())
                }
            }
            .padding(.leading, 10)
            
            //Button at the bottom of the window to create the note
            HStack {
                
                //Spacer usedd to make sure the button is presented at the bottom right of the
                Spacer()
                
                //Create note button
                Button("Create Note") {
                    
                    //Generate the new note
                    let newNote = SCSFunctions.Notes.GenerateSCSNote_InitialContact(templateFile: GlobalPreferences.SCSPrefs.initialContactFile, inputValues: currentSession)
                    
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

struct SCSInitialContactView_Previews: PreviewProvider {
    static var previews: some View {
        SCSInitialContactView()
    }
}
