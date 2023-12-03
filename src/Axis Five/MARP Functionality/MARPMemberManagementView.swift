//
//  MARPMemberManagementView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/11/21.
//
//  FILE DESCRIPTION: View used to add / remove clients for the MARP drug screen calling

import SwiftUI


//Struct Used to keep track of new marp information
struct newMember {
    
    var name:String
    var email:String
    var cellPhone:String
    var altPhone:String
    var numScreensPerMonth:String
    var specialNotes:String
    
    init(){
        name = ""
        email = ""
        cellPhone = ""
        altPhone = ""
        numScreensPerMonth = ""
        specialNotes = ""
    }
    
}

struct MARPMemberManagementView: View {
    
    
    //NEW ENVIRONMENT OBJECTS
    @EnvironmentObject var MARPFunctions:MARPFunctionality
    
    //Global variable for handling preferences across views
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
    @State private var selectedName: String? = ""
    @State var selectedInfo:String = ""
    @State private var currentMember = newMember()
    @State private var showingAlert = false
  
    //..USING LOCAL VARIABLES TO PROPERLY UPDATE SCROLL VIEW WHEN CLIENTS ARE ADDED OR REMOVED
    @State private var localMemberArray = [MarpMember]()
    @State private var localMemberNameArray = [String]()
   
    
    //function to add member to the [MarpMembers] array and the list of member names using the textfields
    func addMarpMember (memberInfo: newMember) {
        
        //create a temp dictionary
        var tempDictionary = [String:String]()
        
        //add to the new dictionary
        tempDictionary["Name"] = memberInfo.name
        tempDictionary["Email"] = memberInfo.email
        tempDictionary["Cell Phone"] = memberInfo.cellPhone
        tempDictionary["Alt Phone"] = memberInfo.altPhone
        tempDictionary["Tests Per Month"] = memberInfo.numScreensPerMonth
        tempDictionary["Special Notes"] = memberInfo.specialNotes
        
        
        //create a new MarpMember from the dictionary
        let tempMember = try? MarpMember(dictionary: tempDictionary)
     
        //if not nil add to the global variable
        if tempMember != nil {
            
            //get the inner value of the optional variable
            let unwrappedMember = tempMember!
            
            //generate a new client name array and client name list array
            let tempMemberArray = MARPFunctions.MemberManagement.AddMemberToMemberArray(member: unwrappedMember)
            let tempMemberNameArray = MARPFunctions.MemberManagement.AddMemberToNameArray(memberName: unwrappedMember.name)
            
            //update the global variables
            MARPFunctions.MemberManagement.Members = tempMemberArray
            MARPFunctions.MemberManagement.MemberNameList = tempMemberNameArray
            
            //update the local variables
            localMemberArray =  MARPFunctions.MemberManagement.Members
            localMemberNameArray =  MARPFunctions.MemberManagement.MemberNameList
        }
    }
    
    var body: some View {
        
        //Main HStack
        HStack {
            
            //MARP Member List
            VStack {
                //Label above member list
            
                Text("Members")
                    .textStyle(BigLabelTypeStyle())
                
                //List of all members
                ScrollView {
                    
                    ForEach (localMemberNameArray, id:\.self) { member in
                  
                        
                            Text(member)
                                .font(.custom("Avenir-Light", size: 15))
                                .foregroundColor(self.selectedName == member ? Color.white : Color.OffBlack)
                                .background(Color.clear)
                                .onTapGesture {
                                    self.selectedName = member
                                    self.selectedInfo = MARPFunctions.MemberManagement.gatherMemberInfoForTextBox(name: self.selectedName)
                                }
                    }
                }
                .frame(width:175)
            }
            
            //Vertical divider between sections
            Divider()
                .padding(.trailing, 10)
            
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
                
                //group to collect
                VStack (alignment: .leading, spacing: 10) {
                    
                    //Name
                    HStack {
                        Text("Name")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentMember.name)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    //Email
                    HStack {
                        Text("Email")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentMember.email)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    //Cell Phone
                    HStack {
                        Text("Cell-Phone")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentMember.cellPhone)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    //Alt Phone
                    HStack {
                        Text("Alt-Phone")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentMember.altPhone)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    //Num Screens Per Month
                    HStack {
                        Text("Num Screens Per Month")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentMember.numScreensPerMonth)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    //Special Notes
                    HStack {
                        Text("Special Notes")
                            .textStyle(LabelTypeStyle())
                        TextField("", text: $currentMember.specialNotes)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                }
                
                //Add Button
                HStack (spacing: 10){
                    Spacer()
                    Button("Add") {
                        //Add function
                        if (!MARPFunctions.MemberManagement.CheckNameIsInList(list: MARPFunctions.MemberManagement.MemberNameList, name: currentMember.name)) {
                            
                            addMarpMember(memberInfo: currentMember)
                        }
                    }
                    .buttonStyle(RunButtonStyle())
                    
                    Button("Remove") {
                        showingAlert = true
                    }
                    .buttonStyle(RunButtonStyle())
                    .alert(isPresented: $showingAlert){
                        Alert (
                            title: Text("Remove MARP Member?"),
                            message: Text("Are you sure you want to remove this member?"),
                            primaryButton: .destructive(Text("Remove")) {

                                //Create a temp [MarpMember] variable
                                let tempMemberArray = MARPFunctions.MemberManagement.RemoveMemberFromArray(memberName: selectedName!)
                                let tempNameList = MARPFunctions.MemberManagement.RemoveMemberFromNameList(memberName: selectedName!)
                                //Assign newly created variables to the global variables
                                MARPFunctions.MemberManagement.Members = tempMemberArray
                                MARPFunctions.MemberManagement.MemberNameList = tempNameList

                                //Assign newly created variables to local variables
                                localMemberArray = tempMemberArray
                                localMemberNameArray = tempNameList

                                //Clear the Info Text Box
                                selectedInfo = ""
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
        .onAppear() {
        
            localMemberArray = MARPFunctions.MemberManagement.Members
            localMemberNameArray = MARPFunctions.MemberManagement.MemberNameList
            
        }
    }
}

struct MARPMemberManagementView_Previews: PreviewProvider {
    static var previews: some View {
        
        MARPMemberManagementView()
            .environmentObject(GlobalPreferences())
    }
}
