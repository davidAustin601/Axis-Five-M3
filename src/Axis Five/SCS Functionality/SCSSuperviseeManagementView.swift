//
//  SCSClientManagementView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/17/21.
//
//  FILE DESCRIPTION: View used to add / remove all clients along with their data

import SwiftUI

struct SCSSuperviseeManagementView: View {
    
    
    //NEW ENVIRONMENT OBJECT
    @EnvironmentObject var SCSFunctions: SCSFunctionality
    
    //Variables
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
    @State private var selectedName: String? = ""
    @State var selectedInfo:String = ""
    @State private var currentSupervisee = SCSNewSupervisee()
    @State private var showingAlert = false
    
    //Testing to try and fix the scrollview not updating
    //..USING LOCAL VARIABLES TO PROPERLY UPDATE SCROLL VIEW WHEN CLIENTS ARE ADDED OR REMOVED
    @State private var localSuperviseeArray = [SCSSupervisee]()
    @State private var localSuperviseeNameArray = [String]()
    
    //function to Add member to the [SCSClient] array and the list of member names using the textfields
    func addSCSSupervisee (superviseeInfo: SCSNewSupervisee) {
        //create a temp dictionary
        var tempDictionary = [String:String]()
        
        //add to the new dictionary
        tempDictionary["Name"] = superviseeInfo.name
        tempDictionary["Session Count"] = superviseeInfo.sessionCount
        
        //create a new SCSClient from the dictionary
        let tempSupervisee = try? SCSSupervisee(dictionary: tempDictionary)
        
        //if not nil add to the global variable
        if tempSupervisee != nil {
            
            //get the inner value of the optional variable
            let unwrappedSupervisee = tempSupervisee!
            
            //generate a new client name array and client name list array
            
            let tempSuperviseeArray = SCSFunctions.SuperviseeManagement.AddSupeviseeToSuperviseeArray(supervisee: unwrappedSupervisee)
            let tempSuperviseeNameArray = SCSFunctions.SuperviseeManagement.AddSuperviseeToNameArray(superviseeName: unwrappedSupervisee.Name)

            //update the global variables
            SCSFunctions.SuperviseeManagement.Supervisees = tempSuperviseeArray
            SCSFunctions.SuperviseeManagement.SuperviseeNameList = tempSuperviseeNameArray
            
            //update the local variables
            localSuperviseeArray = SCSFunctions.SuperviseeManagement.Supervisees
            localSuperviseeNameArray = SCSFunctions.SuperviseeManagement.SuperviseeNameList
            
        }

    }
    
    var body: some View {
        
        //Main HStack
        HStack {
            //Client Member List
            VStack {
                //Label above member list
                Text("Supervisees")
                    .textStyle(BigLabelTypeStyle())
                
                //List of all members
                ScrollView {
            
                        
                    ForEach (localSuperviseeNameArray, id:\.self) { supervisee in
                            
                            Text(supervisee)
                                .font(.custom("Avenir-Light", size: 15))
                                .foregroundColor(self.selectedName == supervisee ? Color.white : Color.OffBlack)
                                .background(Color.clear)
                                .onTapGesture {
                                    self.selectedName = supervisee
                                    self.selectedInfo = SCSFunctions.SuperviseeManagement.GatherSuperviseeInfoForTextBox(name: self.selectedName)
                                }
                        }
                    
                }
                .frame(width:175)
            }
            
            //Vertical divider between sections
            Divider()
                .frame(width:10)
            
            //Right Action Side, Top Member Info and Bottom Actions
            ScrollView {
                //Label
                Text("Information")
                    .textStyle(BigLabelTypeStyle())
                
                //Editor to show the selected marp members' information
                TextEditor(text: $selectedInfo)
                    .frame(height: 200, alignment: .leading)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.OffBlack, lineWidth: 1)
                    )
                    .font(.custom("Avenir-Light", size: 15))
                    .foregroundColor(Color.OffBlack)
                
                //Textfields to gather member information
                VStack (alignment: .leading, spacing:10) {
                    //Name
                    HStack {
                        Text("Name")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentSupervisee.name)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //Num Supervision meetings
                    HStack {
                        Text("Session Count")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentSupervisee.sessionCount)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //Add Remove Buttons
                    HStack {
                        //Spacer used to make the button appear at the right side of the window
                        Spacer()
                        
                        //Add button
                        Button("Add") {
                            //Add function
                            if (!SCSFunctions.SuperviseeManagement.CheckNameIsInList(list: SCSFunctions.SuperviseeManagement.SuperviseeNameList, name: currentSupervisee.name)) {
                                
                                addSCSSupervisee(superviseeInfo: currentSupervisee)
                                
                            }
                        }
                        .buttonStyle(RunButtonStyle())
                        
                        //Remove button
                        Button("Remove") {
                            showingAlert = true
                        }
                        .alert(isPresented: $showingAlert){
                            Alert (
                                title: Text("Remove Supervisee?"),
                                message: Text("Are you sure you want to remove this supervisee?"),
                                primaryButton: .destructive(Text("Remove")) {
                                    
                                    //Create a temp [MarpMember] variable
                                    let tempSuperviseeArray = SCSFunctions.SuperviseeManagement.RemoveSuperviseeFromSuperviseeArray(superviseeName: selectedName!)
                                    
                                    let tempSuperviseeNameArray = SCSFunctions.SuperviseeManagement.RemoveSuperviseeFromNameArray(superviseeName: selectedName!)
                                    //Assign newly created variables to the global variables
                                    SCSFunctions.SuperviseeManagement.Supervisees = tempSuperviseeArray
                                    SCSFunctions.SuperviseeManagement.SuperviseeNameList = tempSuperviseeNameArray
                                    
                                    //Assign newly created variables to the local
                                    localSuperviseeArray = tempSuperviseeArray
                                    localSuperviseeNameArray = tempSuperviseeNameArray
                                    
                                    //Clear the Info Text Box
                                    selectedInfo = ""
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        .buttonStyle(RunButtonStyle())
                    }
                }
            }
        }
        .onAppear() {
            //initialize the local variables used to manage the clients by assigned them with the global variables
            localSuperviseeArray = SCSFunctions.SuperviseeManagement.Supervisees
            localSuperviseeNameArray = SCSFunctions.SuperviseeManagement.SuperviseeNameList
        }
    }
}

struct SCSSuperviseeManagementView_Previews: PreviewProvider {
    static var previews: some View {
        SCSClientManagementView()
            .environmentObject(GlobalPreferences())
            .environmentObject(SCSFunctionality())
    }
}
