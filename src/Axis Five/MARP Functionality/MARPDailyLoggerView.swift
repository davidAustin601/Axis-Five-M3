//
//  MARPDailyLogger.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/5/21.
//
//  FILE DESCRIPTION: View used to complete the daily drug screen call 

import SwiftUI
import AlertToast


struct MARPDailyLoggerView: View {
    
    
    //NEW ENVIRONMENT OBJECTS
    @EnvironmentObject var MARPFunctions: MARPFunctionality
    
    //Global variable for handling preferences across views
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
    //Used to create alert in the view
    @State private var showAlert = false
    
    //Used to dynamically update the text editor
    @State private var localLog = ""

    var body: some View {
        
        //Main VStack
        VStack (alignment: .leading){
            
            //Input Data VStack
            VStack {
                HStack {
                    TextField(MARPFunctions.DailyLogger.LoggerArguments.memberName, text: $MARPFunctions.DailyLogger.LoggerArguments.memberName)
                        .frame(width:200)
                        .textFieldStyle(GlobalTextFieldStyle())
                    Text("Member Name")
                        .textStyle(LabelTypeStyle())
                        .frame(width: 200,alignment: .leading)
                }
                
                HStack {
                    TextField(MARPFunctions.DailyLogger.LoggerArguments.dateScreenCalled, text: $MARPFunctions.DailyLogger.LoggerArguments.dateScreenCalled)
                        .frame(width:200)
                        .textFieldStyle(GlobalTextFieldStyle())
                    Text("Date Called")
                        .textStyle(LabelTypeStyle())
                        .frame(width: 200,alignment: .leading)
                }
                
                HStack {
                    TextField(MARPFunctions.DailyLogger.LoggerArguments.timeInitialContact, text: $MARPFunctions.DailyLogger.LoggerArguments.timeInitialContact)
                        .frame(width:200)
                        .textFieldStyle(GlobalTextFieldStyle())
                    Text("Initial Contact Time")
                        .textStyle(LabelTypeStyle())
                        .frame(width: 200,alignment: .leading)
                }
                
                HStack {
                    
                    TextField(MARPFunctions.DailyLogger.LoggerArguments.timeResponseTime, text: $MARPFunctions.DailyLogger.LoggerArguments.timeResponseTime)
                        .frame(width:200)
                        .textFieldStyle(GlobalTextFieldStyle())
                    Text("Response Time")
                        .textStyle(LabelTypeStyle())
                        .frame(width: 200,alignment: .leading)
                }
                
                HStack {
                    TextField(MARPFunctions.DailyLogger.LoggerArguments.numScreensPerMonth, text: $MARPFunctions.DailyLogger.LoggerArguments.numScreensPerMonth)
                        .frame(width:200)
                        .textFieldStyle(GlobalTextFieldStyle())
                    Text("Number Screen of Month")
                        .textStyle(LabelTypeStyle())
                        .frame(width: 200,alignment: .leading)
                }
            }
            .padding(10)
            
            //Log of output Vstack
            VStack {
                
                TextEditor(text: $localLog)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.OffBlack, lineWidth: 1)
                    )
                    .font(.custom("Avenir-Light", size: 15))
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .foregroundColor(Color.OffBlack)
            }
            
            //Button at the bottom of the window to run the daily logger
            HStack {
                
                //Spacer used to make sure the button appears at the bottom right of the window
                Spacer()
                
                //Run button
                Button("Run"){
                    //run the python code function along with a closure that gathers all the arguments
                    let arguments = MARPFunctions.DailyLogger.GatherMarpLoggerArgs(MARPPrefences: GlobalPreferences.MARPPrefs, localMarpArgs: MARPFunctions.DailyLogger.LoggerArguments)
                    
                    //assign te the output to the global log variable
                    MARPFunctions.DailyLogger.ProcessLog.MarpDaily = MARPFunctions.DailyLogger.RunMARPToolbox(Arguments: arguments)
                    
                    //assign the output to the local log variable
                    localLog = MARPFunctions.DailyLogger.ProcessLog.MarpDaily
                    
                    
                    //Show the alert
                    showAlert.toggle()
                }
                .padding(.bottom, 40)
                .padding(.trailing, 10)
            }
            .buttonStyle(RunButtonStyle())
        }
        .toast(isPresenting: $showAlert){
            AlertToast(displayMode: .alert, type: .complete(Color.OffBlack), title: "Member Logged")
        }
    }
}


struct MARPDailyLoggerView_Previews: PreviewProvider {
    static var previews: some View {
        MARPDailyLoggerView()
            .environmentObject(GlobalPreferences())
    }
}
