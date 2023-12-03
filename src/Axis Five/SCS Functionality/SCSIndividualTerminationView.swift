//
//  SCSIndividualTerminationView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/18/21.
//
//  FILE DESCRIPTION: View used to create a new individual termination note

import SwiftUI

struct SCSIndividualTerminationView: View {
    
    //NEW ENVIRONMENT OBJECT
    @EnvironmentObject var SCSFunctions:SCSFunctionality
    
    //Global variable for handling preferences across views
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
    //Used for opening new "note preview window
    @Environment(\.openURL) var openURL
    //Used for keeping track of newly input information
    @State private var currentSession = SCSNoteInfo_IndividualTermination()
    
    var body: some View {
        
        //Main content
        VStack {
            
            ScrollView {
                
                //Group used to get past 10 item limit
                Group {
                    
                    //Pronoun & PPronoun
                    HStack {
                        //Pronoun
                        Text("Pronoun")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.Pronoun, text: $currentSession.Pronoun)
                            .textFieldStyle(GlobalTextFieldStyle())
                        //PPronoun
                        Text("Possessive Pronoun")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.PPronoun, text: $currentSession.PPronoun)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //Intake Date
                    HStack {
                        Text("Intake Date")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermIntakeDate, text: $currentSession.TermIntakeDate)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //LastServiceDate
                    HStack {
                        Text("Last Service Date")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermLastServiceDate, text: $currentSession.TermLastServiceDate)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //NumSessions
                    HStack {
                        Text("Number of Sessions")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermNumSessions, text: $currentSession.TermNumSessions)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //NumTriage
                    HStack {
                        Text("Number of Triages")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermNumTriage, text: $currentSession.TermNumTriage)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //NumIntake
                    HStack {
                        Text("Number of Intakes")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermNumIntake, text: $currentSession.TermNumIntake)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //NumIndividual
                    HStack {
                        Text("Number of Individual Sessions")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermNumIndividual, text: $currentSession.TermNumIndividual)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //NumAdvocacy
                    HStack {
                        Text("Number of Advocacy")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermNumAdvocacy, text: $currentSession.TermNumAdvocacy)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //NumOther
                    HStack {
                        Text("Number of Other Sessions")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermNumOther, text: $currentSession.TermNumOther)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //PresentingProblem
                    HStack {
                        Text("Presenting Problems")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermPresentingProb, text: $currentSession.TermPresentingProb)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                }
                
                //Group used to get past 10 item limit
                Group {
                    //DiagnosisIntake
                    HStack {
                        Text("Diagnosis at Intake")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermDiagnosisIntake, text: $currentSession.TermDiagnosisIntake)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //TopicsCovered
                    HStack {
                        Text("Topics Covered")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermTopicsCovered, text: $currentSession.TermTopicsCovered)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //Improved
                    HStack {
                        Text("Things Improved")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermImproved, text: $currentSession.TermImproved)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                    
                    //NeedsWork
                    HStack {
                        Text("Things that Need Work")
                            .textStyle(LabelTypeStyle())
                        TextField(currentSession.TermNeedsWork, text: $currentSession.TermNeedsWork)
                            .textFieldStyle(GlobalTextFieldStyle())
                    }
                }
                
                //Button at the bottom of the window to create the note
                HStack {

                    //Spacer used to make sure the button appears at the bottom right of the window
                    Spacer()
                    
                    //Create note button
                    Button("Create Note") {
                        
                        //Generate the new note
                        let newNote = SCSFunctions.Notes.GenerateSCSNote_IndividualTermination(templateFile: GlobalPreferences.SCSPrefs.individualterminationFile, inputValues: currentSession)
                        
                        //Assign new note to global variable
                        SCSFunctions.Notes.CurrentNote = newNote ?? ""
                        
                        if let url = URL(string: "dialogs://NotePreview") {
                            openURL(url)
                        }
                    }
                    .buttonStyle(RunButtonStyle())
                    
                }
                .padding(.bottom, 40)
                
            }
            .padding(.leading, 10)
        }
    }
}

struct SCSIndividualTerminationView_Previews: PreviewProvider {
    static var previews: some View {
        SCSIndividualTerminationView()
    }
}
