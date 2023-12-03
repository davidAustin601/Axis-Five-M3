//
//  MARPOptionsView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/6/21.
//
//  FILE DESCRIPTION: View to edit all MARP preferences

import SwiftUI
import DynamicColor

struct MARPOptionsView: View {
    
    //Global variable for handling preferences across views
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
   
    var body: some View {
        
        //Main content
        VStack {
            
            //Directories Section
            HStack {
                Text("Directories").textStyle(BigLabelTypeStyle())
                    .frame(alignment: .leading)
                //Spacer used to align Directories Label to the left of the window
                Spacer()
            }
            
            //Data Directory Path
            HStack{
                Text("Data Directory")
                    .textStyle(LabelTypeStyle())
                
                TextField(GlobalPreferences.MARPPrefs.dataDirectory, text: $GlobalPreferences.MARPPrefs.dataDirectory)
                    .textFieldStyle(GlobalTextFieldStyle())
                
                Button("Select") {
                    GlobalPreferences.MARPPrefs.dataDirectory = selectDIR()
                }
                .buttonStyle(SelectButtonStyle())
            }
            //Screenshot Directory Path
            HStack{
                Text("Screenshot DIR")
                    .textStyle(LabelTypeStyle())
                
                TextField(GlobalPreferences.MARPPrefs.dirScreenshot, text: $GlobalPreferences.MARPPrefs.dirScreenshot)
                    .textFieldStyle(GlobalTextFieldStyle())
                
                Button("Select"){
                    GlobalPreferences.MARPPrefs.dirScreenshot = selectDIR()
                }
                .buttonStyle(SelectButtonStyle())
            }
            
            HStack {
                Text("Files")
                    .textStyle(BigLabelTypeStyle())
                //Spacer used to align Files label to the left of the window
                Spacer()
            }
            
            
            //Data Directory Path
            HStack{
                Text("Excel Call List")
                    .textStyle(LabelTypeStyle())
                
                TextField(GlobalPreferences.MARPPrefs.excelFile, text: $GlobalPreferences.MARPPrefs.excelFile)
                    .textFieldStyle(GlobalTextFieldStyle())
                
                Button("Select") {
                    GlobalPreferences.MARPPrefs.excelFile = SelectFile()
                }
                .buttonStyle(SelectButtonStyle())
            }
            
            //Screenshot Directory Path
            HStack{
                
                Text("Contact Log Template")
                    .textStyle(LabelTypeStyle())
                
                TextField(GlobalPreferences.MARPPrefs.contactLogTemplateFile, text: $GlobalPreferences.MARPPrefs.contactLogTemplateFile)
                    .textFieldStyle(GlobalTextFieldStyle())
                
                Button("Select"){
                    GlobalPreferences.MARPPrefs.contactLogTemplateFile = SelectFile()
                }
                .buttonStyle(SelectButtonStyle())
            }
            
            HStack {
                Text("Misc")
                    .textStyle(BigLabelTypeStyle())
                //Spacer used to align Misc label to the left of the window
                Spacer()
            }
            
            //Data Directory Path
            HStack{
                Text("Month Year")
                    .textStyle(LabelTypeStyle())
                
                TextField(GlobalPreferences.MARPPrefs.monthYear, text: $GlobalPreferences.MARPPrefs.monthYear)
                    .textFieldStyle(GlobalTextFieldStyle())
            }
        }
        .padding(.bottom, 50)
        .frame(width: 800)
        .background(Color.clear)
    }
}


struct MARPOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        MARPOptionsView().environmentObject(GlobalPreferences())
    }
}
