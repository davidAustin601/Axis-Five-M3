//
//  SCSOptionsView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/7/21.
//
//  FILE DESCRIPTION: View to edit all SCS preferences

import SwiftUI

struct SCSOptionsView: View {
    
    //Global variable for handling preferences across views
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
    
    var body: some View {
        
        //Main content
        VStack {
            HStack {
                Text("Template Files & Misc")
                    .textStyle(BigLabelTypeStyle())
                //Spacer used to align Template files label to the left of the window
                Spacer()
            }
            
            //Files Section
            VStack {
                //Individual Session
                HStack{
                    Text("Individual Session")
                        .textStyle(LabelTypeStyle())
                    
                    TextField(GlobalPreferences.SCSPrefs.individualSessionFile, text: $GlobalPreferences.SCSPrefs.individualSessionFile)
                        .textFieldStyle(GlobalTextFieldStyle())
                    
                    Button("Select") {
                        GlobalPreferences.SCSPrefs.individualSessionFile = SelectFile()
                    }
                    .buttonStyle(SelectButtonStyle())
                }
                
                //Supervision Session
                HStack{
                    Text("Supervision Session")
                        .textStyle(LabelTypeStyle())
                    
                    TextField(GlobalPreferences.SCSPrefs.supervisionSessionFile, text: $GlobalPreferences.SCSPrefs.supervisionSessionFile)
                        .textFieldStyle(GlobalTextFieldStyle())
                    
                    Button("Select") {
                        GlobalPreferences.SCSPrefs.supervisionSessionFile = SelectFile()
                    }
                    .buttonStyle(SelectButtonStyle())
                }
                
                
                //Intake Session
                HStack{
                    Text("Intake Session")
                        .textStyle(LabelTypeStyle())
                    
                    TextField(GlobalPreferences.SCSPrefs.intakeSessionFile, text: $GlobalPreferences.SCSPrefs.intakeSessionFile)
                        .textFieldStyle(GlobalTextFieldStyle())
                    
                    Button("Select"){
                        GlobalPreferences.SCSPrefs.intakeSessionFile = SelectFile()
                    }
                    .buttonStyle(SelectButtonStyle())
                }
                
                //Initial Contact Session
                HStack{
                    Text("Initial Contact Session")
                        .textStyle(LabelTypeStyle())
                    
                    TextField(GlobalPreferences.SCSPrefs.initialContactFile, text: $GlobalPreferences.SCSPrefs.initialContactFile)
                        .textFieldStyle(GlobalTextFieldStyle())
                    
                    Button("Select"){
                        GlobalPreferences.SCSPrefs.initialContactFile = SelectFile()
                    }
                    .buttonStyle(SelectButtonStyle())
                }
                
                //Group Session
                HStack{
                    Text("Group Session")
                        .textStyle(LabelTypeStyle())
                    
                    TextField(GlobalPreferences.SCSPrefs.groupSessionFile, text: $GlobalPreferences.SCSPrefs.groupSessionFile)
                        .textFieldStyle(GlobalTextFieldStyle())
                    
                    Button("Select"){
                        GlobalPreferences.SCSPrefs.groupSessionFile = SelectFile()
                    }
                    .buttonStyle(SelectButtonStyle())
                }
                
                //Group Screen Session
                HStack{
                    Text("Group Screen Session")
                        .textStyle(LabelTypeStyle())
                    
                    TextField(GlobalPreferences.SCSPrefs.groupScreenSessionFile, text: $GlobalPreferences.SCSPrefs.groupScreenSessionFile)
                        .textFieldStyle(GlobalTextFieldStyle())
                    
                    Button("Select"){
                        GlobalPreferences.SCSPrefs.groupScreenSessionFile = SelectFile()
                    }
                    .buttonStyle(SelectButtonStyle())
                }
                
                //Other Session
                HStack{
                    Text("Other Session")
                        .textStyle(LabelTypeStyle())
                    
                    TextField(GlobalPreferences.SCSPrefs.otherSessionFile, text: $GlobalPreferences.SCSPrefs.otherSessionFile)
                        .textFieldStyle(GlobalTextFieldStyle())
                    
                    Button("Select"){
                        GlobalPreferences.SCSPrefs.otherSessionFile = SelectFile()
                    }
                    .buttonStyle(SelectButtonStyle())
                }
                
                //Individual Termination Session
                HStack{
                    Text("Individual Termination Session")
                        .textStyle(LabelTypeStyle())
                    
                    TextField(GlobalPreferences.SCSPrefs.individualterminationFile, text: $GlobalPreferences.SCSPrefs.individualterminationFile)
                        .textFieldStyle(GlobalTextFieldStyle())
                    
                    Button("Select"){
                        GlobalPreferences.SCSPrefs.individualterminationFile = SelectFile()
                    }
                    .buttonStyle(SelectButtonStyle())
                }
                
                //Other Session
                HStack{
                    Text("SCS Clients")
                        .textStyle(LabelTypeStyle())
                    
                    TextField(GlobalPreferences.SCSPrefs.clientListFile, text: $GlobalPreferences.SCSPrefs.clientListFile)
                        .textFieldStyle(GlobalTextFieldStyle())
                    
                    Button("Select"){
                        GlobalPreferences.SCSPrefs.clientListFile = SelectFile()
                    }
                    .buttonStyle(SelectButtonStyle())
                }
                
                //Group Leaders
                HStack{
                    Text("Group Leaders")
                        .textStyle(LabelTypeStyle())
                    
                    TextField(GlobalPreferences.SCSPrefs.groupLeaders, text: $GlobalPreferences.SCSPrefs.groupLeaders)
                        .textFieldStyle(GlobalTextFieldStyle())
                }
            }
        }
        .padding(.bottom, 20)
        
    }
}

struct SCSOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SCSOptionsView().environmentObject(GlobalPreferences())
    }
}
