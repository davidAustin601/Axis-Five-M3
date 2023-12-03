//
//  SideBarView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/3/21.
//
//  FILE DESCRIPTION: View used to navigate between the various sections of the program, also includes an animated gif for style

import SwiftUI
import AppKit
import SDWebImageSwiftUI

struct SideBarView: View {
    
    @EnvironmentObject var GlobalContentWindow: ActiveContentWindow
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
    @State private var SelectedMenuItem = ""
    
    func HighlightSelecteItem (ItemName: String) -> Bool {
        
        if (ItemName == SelectedMenuItem) {
            return true
        }
        else {
            return false
        }
        
    }
    
    
    var body: some View {
        
        //MAIN LIST
        VStack (alignment: .leading){
            
            //******************** MARP SECTION ****************************
            //Group used to get past 10 item limit
            Group {
                
                HStack {
                    
                    Spacer()
                        .frame(width: 15)
                    
                    //Determine Which Animation To Run
                    if (GlobalPreferences.GlobalAnimation == 1) {
                        
                        AnimatedImage(name: "GeometryGIF1.gif")
                            .resizable()
                            .frame(width:150, height:150)
                    }
                    else if (GlobalPreferences.GlobalAnimation == 2) {
                        
                        AnimatedImage(name: "GeometryGIF2.gif")
                            .resizable()
                            .frame(width:150, height:150)
                    }
                    else if (GlobalPreferences.GlobalAnimation == 3) {
                        
                        AnimatedImage(name: "GeometryGIF3.gif")
                            .resizable()
                            .frame(width:150, height:150)
                    
                    }
                    
                    
                }
                
                //Using VStack to align buttons
                VStack (alignment: .leading, spacing: 3){
                    
                    
                    
                    Text("MARP")
                        .kerning(3)
                        .textStyle(SideBarMenuHeaderTypeStyle())
                    
                    //Daily Logger
                    Text("Daily Logger")
                        .textStyle(SideBarMenuItemTypeStyle())
                        .foregroundColor(HighlightSelecteItem(ItemName: "Daily Logger") ? Color.white : Color.OffBlack)
                        .onTapGesture {
                            SelectedMenuItem = "Daily Logger"
                            GlobalContentWindow.activeWindow = Windows.MARP_DailyLogger
                        }
                    
                    //MARP - CREATE CALL LIST
                    Text ("Create Call List")
                        .textStyle(SideBarMenuItemTypeStyle())
                        .foregroundColor(HighlightSelecteItem(ItemName: "Create Call List") ? Color.white : Color.OffBlack)
                        .onTapGesture {
                            SelectedMenuItem = "Create Call List"
                            GlobalContentWindow.activeWindow = Windows.MARP_CallList
                        }
                    
                    
                    //MARP - MEMBER MANAGEMENT
                    Text("Member Management")
                        .textStyle(SideBarMenuItemTypeStyle())
                        .foregroundColor(HighlightSelecteItem(ItemName: "Member Management") ? Color.white : Color.OffBlack)
                        .onTapGesture {
                            SelectedMenuItem = "Member Management"
                            GlobalContentWindow.activeWindow = Windows.MARP_MemberManagement
                        }
                }
                
                
            }
            
            //Spacer between sections
            Spacer()
                .frame(height:15)
            
            //******************** SCS SECTION ****************************
            //Group used to get past 10 item limit
            Group {
                VStack(alignment: .leading, spacing: 3){
                    
                    
                    Text("SCS")
                        .kerning(3)
                        .textStyle(SideBarMenuHeaderTypeStyle())
                        .frame(alignment: .center)
                    
                    
                    
                    
                    
                    
                    //SCS - INDIVIDUAL SESSION
                    Text("Client Management")
                        .textStyle(SideBarMenuItemTypeStyle())
                        .foregroundColor(HighlightSelecteItem(ItemName: "Client Management") ? Color.white : Color.OffBlack)
                        .onTapGesture {
                            SelectedMenuItem = "Client Management"
                            GlobalContentWindow.activeWindow = Windows.SCS_ClientManagement
                        }
                    
                    //SCS - SUPERVISION SESSION
                    Text("Supervisee Management")
                        .textStyle(SideBarMenuItemTypeStyle())
                        .foregroundColor(HighlightSelecteItem(ItemName: "Supervisee Management") ? Color.white : Color.OffBlack)
                        .onTapGesture {
                            SelectedMenuItem = "Supervisee Management"
                            GlobalContentWindow.activeWindow = Windows.SCS_SuperviseeManagement
                        }
                    
                    //SCS - INDIVIDUAL SESSION
                    Text("Individual Session")
                        .textStyle(SideBarMenuItemTypeStyle())
                        .foregroundColor(HighlightSelecteItem(ItemName: "Individual Session") ? Color.white : Color.OffBlack)
                        .onTapGesture {
                            SelectedMenuItem = "Individual Session"
                            GlobalContentWindow.activeWindow = Windows.SCS_Individual
                        }
                    
                    //SCS - INTAKE SESSION
                    Text("Intake Session")
                        .textStyle(SideBarMenuItemTypeStyle())
                        .foregroundColor(HighlightSelecteItem(ItemName: "Intake Session") ? Color.white : Color.OffBlack)
                        .onTapGesture {
                            SelectedMenuItem = "Intake Session"
                            GlobalContentWindow.activeWindow = Windows.SCS_Intake
                        }
                    
                    //SCS - INITIAL CONTACT
                    Text("Initial Contact")
                        .textStyle(SideBarMenuItemTypeStyle())
                        .foregroundColor(HighlightSelecteItem(ItemName: "Initial Contact") ? Color.white : Color.OffBlack)
                        .onTapGesture {
                            SelectedMenuItem = "Initial Contact"
                            GlobalContentWindow.activeWindow = Windows.SCS_InitialContact
                        }
                    
                    //SCS - GROUP SESSION
                    Text("Group Session")
                        .textStyle(SideBarMenuItemTypeStyle())
                        .foregroundColor(HighlightSelecteItem(ItemName: "Group Session") ? Color.white : Color.OffBlack)
                        .onTapGesture {
                            SelectedMenuItem = "Group Session"
                            GlobalContentWindow.activeWindow = Windows.SCS_GroupSession
                        }
                    
                    //SCS - INDIVIDUAL TERMINATION
                    Text("Individual Termination")
                        .textStyle(SideBarMenuItemTypeStyle())
                        .foregroundColor(HighlightSelecteItem(ItemName: "Individual Termination") ? Color.white : Color.OffBlack)
                        .onTapGesture {
                            SelectedMenuItem = "Individual Termination"
                            GlobalContentWindow.activeWindow = Windows.SCS_IndividualTermination
                        }
                    
                    //SCS - SUPERVISION MEETING
                    Text("Supervision Session")
                        .textStyle(SideBarMenuItemTypeStyle())
                        .foregroundColor(HighlightSelecteItem(ItemName: "Supervision Session") ? Color.white : Color.OffBlack)
                        .onTapGesture {
                            SelectedMenuItem = "Supervision Session"
                            GlobalContentWindow.activeWindow = Windows.SCS_Supervision
                        }
                }
            }
            
            //Spacer at the bottom
            Spacer()
   
            
            
            
        }
        .padding(.leading, 15)
        .padding(.trailing, 15)
        
        
    }
    
    
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView()
            .environmentObject(ActiveContentWindow())
            .environmentObject(GlobalPreferences())
    
    }
}
