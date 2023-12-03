//
//  MainView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/3/21.
//
//  FILE DESCRIPTION: This is the main windows of the entire program. It includes the sidebar menu to the left to navigation between different sections of the program along with the currently active program to the right. It also include a color changing background behind everything.

import SwiftUI
import DynamicColor

struct MainView: View {
    
    //Global variable for handling 
    @EnvironmentObject var GlobalContentWindow: ActiveContentWindow
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
    @EnvironmentObject var SCSFunctions: SCSFunctionality
    
    //************************** DESIGN CODE *************************
    //Color changing background
    //Initialize the Color variable to the first color on the DesignMatters transition
    @State private var bgColor = Color(hex: 0x67C7C7)
    @State private var bgColorIndex = 0
    //Timer used in the animation between colors
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    //****************************************************************
    
    var body: some View {
        
        
        //Main ZStack - on bottom: color changing background rectangle, on top: the content
        ZStack {
            
            //Color changing background
            Rectangle()
                .ignoresSafeArea(.all)
                .foregroundColor(Color(hex: UInt64(mainColorArray[bgColorIndex])))
                .onReceive(timer) { _ in
                    
                    if bgColorIndex == mainColorArray.count - 1 {
                        timer.upstream.connect().cancel()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.easeIn(duration: 10)) { self.bgColorIndex = 0 }
                            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        }
                        
                    } else {
                        withAnimation(.easeIn(duration: 10)) { self.bgColorIndex += 1 }
                    }
                }
            
            //Main content
            VStack {
                
                HStack(spacing: 0) {
                    
                    //Side navigation bar
                    SideBarView()
                        .frame(minWidth: 220, maxWidth: 220)
                        .background(Color.clear)
                    
                    
                    Divider()
                    
                    //Read 'GlobalContentWindow' to determine which view shiould be active
                    switch(GlobalContentWindow.activeWindow){
                    
                    //MARP Views
                    case Windows.MARP:
                        MARPDailyLoggerView()
                    case Windows.MARP_DailyLogger:
                        MARPDailyLoggerView()
                    case Windows.MARP_MemberManagement:
                        MARPMemberManagementView(selectedInfo: "")
                    case Windows.MARP_CallList:
                        MARPCallListView()
                        
                    //SCS Views
                    case Windows.SCS_ClientManagement:
                        SCSClientManagementView()
                        
                    case Windows.SCS_Individual:
                        SCSIndividualView()
                    case Windows.SCS_SuperviseeManagement:
                        SCSSuperviseeManagementView()
                    case Windows.SCS_Intake:
                        SCSIntakeView()
                    case Windows.SCS_InitialContact:
                        SCSInitialContactView()
                    case Windows.SCS_GroupSession:
                        SCSGroupSessionView()
                    case Windows.SCS_IndividualTermination:
                        SCSIndividualTerminationView()
                    case Windows.SCS_Supervision:
                        SCSSupervisionView()
                        
                    }
                    
                }
                
            }
            .padding(.trailing, 15)
            
        }
        .frame(width: 1200, height: 700)
        
        
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ActiveContentWindow())
            .environmentObject(GlobalPreferences())
    }
}
