//
//  SCSIntakeView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/17/21.
//
//  FILE DESCRIPTION: View used to create a new intake note

import SwiftUI

struct SCSIntakeView: View {
    
    //NEW ENVIRONMENT OBJRECT
    @EnvironmentObject var SCSFunctions:SCSFunctionality
    

    //Global variable for handling preferences across views
    @EnvironmentObject var GlobalPreferences: GlobalPreferences
    //Used for opening new "note preview window
    @Environment(\.openURL) var openURL
    //Used for keeping track of newly input information
    @State private var currentSession = SCSNoteInfo_THIntake()
    
    var body: some View {
        
        //Main content
        VStack {
            
            //Group used to get around item limit
            Group {
                
                ScrollView {
                    
                    //just enough padding on top to not cut off some of the textfield
                    Spacer()
                        .frame(height:1)
                    
                    //Group for telehealth information
                    Group {
                        
                        //Address & Phone Number
                        HStack {
                            //Address
                            Text("Client Address")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.Address, text: $currentSession.Address)
                                .textFieldStyle(GlobalTextFieldStyle())
                            
                            //Phone Number
                            Text("Client Phone")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.PhoneNumber, text: $currentSession.PhoneNumber)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //Emergency Contact & Phone Number
                        HStack {
                            //Address
                            Text("Emergency Contact")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.EmergencyContact, text: $currentSession.EmergencyContact)
                                .textFieldStyle(GlobalTextFieldStyle())
                            
                            //Phone Number
                            Text("Emergency Phone")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.EmergencyPhone, text: $currentSession.EmergencyPhone)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                    }
                    
                    //Group created to get back the 10 item limit
                    Group {
                        
                        //Pronoun info
                        HStack {
                            //Pronoun
                            Text("Pronoun")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.Pronoun, text: $currentSession.Pronoun)
                                .textFieldStyle(GlobalTextFieldStyle())
                            //Possessive Pronoun
                            Text("Possessive Pronoun")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.PossessivePronoun, text: $currentSession.PossessivePronoun)
                                .textFieldStyle(GlobalTextFieldStyle())
                            //Reflexive Pronoun
                            Text("Reflexive Pronoun")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.ReflexivePronoun, text: $currentSession.ReflexivePronoun)
                                .textFieldStyle(GlobalTextFieldStyle())
                            //Third Person Pronoun
                            Text("3rd Person Pronoun")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.ThirdPersonPronoun, text: $currentSession.ThirdPersonPronoun)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //Referral
                        HStack {
                            Text("Referral")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.Referral, text: $currentSession.Referral)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //Main Problems
                        HStack {
                            Text("Main Problems")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.MainProblems, text: $currentSession.MainProblems)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //Secondary Problems
                        HStack {
                            Text("Secondary Problems")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.SecondaryProblems, text: $currentSession.SecondaryProblems)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //EatSleepProblems
                        HStack {
                            Text("Eat Sleep Problems")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.EatSleepProblems, text: $currentSession.EatSleepProblems)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //SIHistory
                        HStack {
                            Text("SI History")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.SIHistory, text: $currentSession.SIHistory)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //HIHistory
                        HStack {
                            Text("HI History")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.HIHistory, text: $currentSession.HIHistory)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //SelfInjuryHistory
                        HStack {
                            Text("Self Injury History")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.SelfInjuryHistory, text: $currentSession.SelfInjuryHistory)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //OptAdditionalBehavioral
                        HStack {
                            Text("(Opt) Additional Behvioral Comments")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.OptAdditionalBehavioral, text: $currentSession.OptAdditionalBehavioral)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //Abuse
                        HStack {
                            Text("Abuse")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.Abuse, text: $currentSession.Abuse)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                    }
                    
                    //Group used to get past the 10 item limit
                    Group {
                        
                        //OptAdditionalAbuse
                        HStack {
                            Text("(Opt) Additional Abuse Comments")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.OptAdditionalAbuse, text: $currentSession.OptAdditionalAbuse)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //Trauma
                        HStack {
                            Text("Trauma")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.Trauma, text: $currentSession.Trauma)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //OptAdditionalTrauma
                        HStack {
                            Text("(Opt) Additional Trauma Comments")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.OptAdditionaTrauma, text: $currentSession.OptAdditionaTrauma)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //AlcoholFrequency
                        HStack {
                            Text("Alcohol Frequency")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.AlcoholFrequency, text: $currentSession.AlcoholFrequency)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //SubstanceFrequency
                        HStack {
                            Text("Substance Frequency")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.SubstanceFrequency, text: $currentSession.SubstanceFrequency)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //SubstanceList
                        HStack {
                            Text("Substance List")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.SubstanceList, text: $currentSession.SubstanceList)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //OptAdditionalSubstance
                        HStack {
                            Text("(Opt) Additional Substance Comments")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.OptAdditionalSubstance, text: $currentSession.OptAdditionalSubstance)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //Grade
                        HStack {
                            Text("Grade")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.Grade, text: $currentSession.Grade)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //Major
                        HStack {
                            Text("Major")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.Major, text: $currentSession.Major)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                    }
                    
                    //Group used to get past the 10 item limit
                    Group {
                        
                        //MajorSatisfaction
                        HStack {
                            Text("Major Satisfaction")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.MajorSatisfaction, text: $currentSession.MajorSatisfaction)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //Employment
                        HStack {
                            Text("Employment")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.Employment, text: $currentSession.Employment)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //OtherData
                        HStack {
                            Text("Other Data")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.OtherData, text: $currentSession.OtherData)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //Demographics
                        HStack {
                            Text("Demographics")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.Demographics, text: $currentSession.Demographics)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //OutsideReferral
                        HStack {
                            Text("Outside Referral")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.OutsideReferral, text: $currentSession.OutsideReferral)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                        
                        //Plan
                        HStack {
                            Text("Plan")
                                .textStyle(LabelTypeStyle())
                            TextField(currentSession.Plan, text: $currentSession.Plan)
                                .textFieldStyle(GlobalTextFieldStyle())
                        }
                    }
                }
                .padding(.leading, 10)
            }
            
            //Button at the bottom of the window for creating the note
            HStack {
                
                //Spacer used to make the button appear at the bottom left of the window
                Spacer()
                
                //Create note buttone
                Button("Create Note") {
                    
                    //Generate the new note
                    let newNote = SCSFunctions.Notes.GenerateSCSNote_Intake(templateFile: GlobalPreferences.SCSPrefs.intakeSessionFile, inputValues: currentSession)
                    
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
    }
}

struct SCSIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        SCSIntakeView()
    }
}
