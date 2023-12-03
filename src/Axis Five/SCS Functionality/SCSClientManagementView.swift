//
//  SCSClientManagementView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/17/21.
//
//  FILE DESCRIPTION: View used to add / remove all clients along with their data

import SwiftUI

struct SCSClientManagementView: View {
    
    
    //NEW ENVIRONMENT OBJECT
    @EnvironmentObject var SCSFunctions: SCSFunctionality
    
    //Variables
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
    @State private var selectedName: String? = ""
    @State var selectedInfo:String = ""
    @State private var currentClient = SCSNewClient()
    @State private var showingAlert = false
    
    //Testing to try and fix the scrollview not updating
    //..USING LOCAL VARIABLES TO PROPERLY UPDATE SCROLL VIEW WHEN CLIENTS ARE ADDED OR REMOVED
    @State private var localClientArray = [SCSClient]()
    @State private var localClientNameArray = [String]()
    
    //function to Add member to the [SCSClient] array and the list of member names using the textfields
    func addSCSClient (clientInfo: SCSNewClient) {
        //create a temp dictionary
        var tempDictionary = [String:String]()
        
        //add to the new dictionary
        tempDictionary["Name"] = clientInfo.name
        tempDictionary["Address"] = clientInfo.address
        tempDictionary["Phone Number"] = clientInfo.phoneNumber
        tempDictionary["Emergency Contact"] = clientInfo.emergencyContact
        tempDictionary["Emergency Phone"] = clientInfo.emergencyPhone
        tempDictionary["Session Count"] = clientInfo.sessionCount
        
        //create a new SCSClient from the dictionary
        let tempClient = try? SCSClient(dictionary: tempDictionary)
        
        //if not nil add to the global variable
        if tempClient != nil {
            
            //get the inner value of the optional variable
            let unwrappedClient = tempClient!
            
            //generate a new client name array and client name list array
            let tempClientArray = SCSFunctions.ClientManagement.AddClientToClientArray(client: unwrappedClient)
            let tempClientNameArray = SCSFunctions.ClientManagement.AddClientToNameArray(clientName: unwrappedClient.Name)
            
            //update the global variables
            SCSFunctions.ClientManagement.Clients = tempClientArray
            SCSFunctions.ClientManagement.ClientNameList = tempClientNameArray
            
            //update the local variables
            localClientArray = SCSFunctions.ClientManagement.Clients
            localClientNameArray = SCSFunctions.ClientManagement.ClientNameList
            
        }

    }
    
    var body: some View {
        
        //Main HStack
        HStack {
            //Client Member List
            VStack {
                //Label above member list
                Text("Clients")
                    .textStyle(BigLabelTypeStyle())
                
                //List of all members
                ScrollView {
            
                        
                    ForEach (localClientNameArray, id:\.self) { client in
                            
                            Text(client)
                                .font(.custom("Avenir-Light", size: 15))
                                .foregroundColor(self.selectedName == client ? Color.white : Color.OffBlack)
                                .background(Color.clear)
                                .onTapGesture {
                                    self.selectedName = client
                                    self.selectedInfo = SCSFunctions.ClientManagement.GatherClientInfoForTextBox(name: self.selectedName)
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
                        TextField("", text: $currentClient.name)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //Email
                    HStack {
                        Text("Address")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentClient.address)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //Cell Phone
                    HStack {
                        Text("Phone Number")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentClient.phoneNumber)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //Alt Phone
                    HStack {
                        Text("Emergency Contact")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentClient.emergencyContact)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //Num Screens Per Month
                    HStack {
                        Text("Emergency Phone")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentClient.emergencyPhone)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //Num Screens Per Month
                    HStack {
                        Text("Session Count")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentClient.sessionCount)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //Add Remove Buttons
                    HStack {
                        //Spacer used to make the button appear at the right side of the window
                        Spacer()
                        
                        //Add button
                        Button("Add") {
                            //Add function
                            if (!SCSFunctions.ClientManagement.CheckNameIsInList(list: SCSFunctions.ClientManagement.ClientNameList, name: currentClient.name)) {
                                
                                addSCSClient(clientInfo: currentClient)
                                
                            }
                        }
                        .buttonStyle(RunButtonStyle())
                        
                        //Remove button
                        Button("Remove") {
                            showingAlert = true
                        }
                        .alert(isPresented: $showingAlert){
                            Alert (
                                title: Text("Remove Client Member?"),
                                message: Text("Are you sure you want to remove this member?"),
                                primaryButton: .destructive(Text("Remove")) {
                                    
                                    //Create a temp [MarpMember] variable
                                    let tempClientArray = SCSFunctions.ClientManagement.RemoveClientFromClientArray(clientName: selectedName!)
                                    
                                    let tempNameArray = SCSFunctions.ClientManagement.RemoveClientFromNameArray(clientName: selectedName!)
                                    //Assign newly created variables to the global variables
                                    SCSFunctions.ClientManagement.Clients = tempClientArray
                                    SCSFunctions.ClientManagement.ClientNameList = tempNameArray
                                    
                                    //Assign newly created variables to the local
                                    localClientArray = tempClientArray
                                    localClientNameArray = tempNameArray
                                    
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
            localClientArray = SCSFunctions.ClientManagement.Clients
            localClientNameArray = SCSFunctions.ClientManagement.ClientNameList
        }
    }
}

struct SCSClientManagementView_Previews: PreviewProvider {
    static var previews: some View {
        SCSClientManagementView()
            .environmentObject(GlobalPreferences())
            .environmentObject(SCSFunctionality())
    }
}
