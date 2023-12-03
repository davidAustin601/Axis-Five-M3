//
//  SCS_Definitions.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/5/21.
//
//  FILE DESCRIPTION: File to organize all definitions for SCS functions used throughout the program

import Foundation
import SwiftUI

//Struct used when determining which client is selected and assigning to the client note info
struct SCSTHInfo {
    var Address:String
    var PhoneNumber:String
    var EmergencyContact:String
    var EmergencyPhone:String
    var SessionCount:String
    
    init () {
        Address = ""
        PhoneNumber = ""
        EmergencyContact = ""
        EmergencyPhone = ""
        SessionCount = ""
    }
}

//Struct used when determining which client is selected and assigning to the client note info
struct SCSSuperviseeTHInfo {
    var SessionCount:String
    
    init () {
        SessionCount = ""
    }
}

//Struct used to hold the information that will replace the symbols in the SCS inidividual note template file
struct SCSNoteInfo_THIndividual {
    //telehealth info
    var Address:String
    var PhoneNumber:String
    var EmergencyContact:String
    var EmergencyPhone:String
    var SessionCount:String
    
    //general note info
    var NumSession:String
    var TopicsCovered:String
    var OtherThingsWorkedOn:String
    var Affect:String
    var Improved:String
    var NeedsWork:String
    var WorkNext:String
    var NextSession:String
    var Homework:String
    
    init () {
        //telehealth info
        Address = ""
        PhoneNumber = ""
        EmergencyContact = ""
        EmergencyPhone = ""
        SessionCount = ""
        
        //general note info
        NumSession = ""
        TopicsCovered = ""
        OtherThingsWorkedOn = ""
        Affect = ""
        Improved = ""
        NeedsWork = ""
        WorkNext = ""
        NextSession = ""
        Homework = ""
    }
}

//Struct used to hold the information that will replace the symbols in the SCS inidividual note template file
struct SCSNoteInfo_THSupervision {

    //general note info
    var NumSession:String
    var TopicsCovered:String
    var OtherThingsWorkedOn:String
    var Affect:String
    var Improved:String
    var NeedsWork:String
    var WorkNext:String
    var NextSession:String
    var Homework:String
    
    init () {
        //general note info
        NumSession = ""
        TopicsCovered = ""
        OtherThingsWorkedOn = ""
        Affect = ""
        Improved = ""
        NeedsWork = ""
        WorkNext = ""
        NextSession = ""
        Homework = ""
    }
}

//Struct used to hold the information that will replace the symbols in the SCS intake note template file
struct SCSNoteInfo_THIntake {
    
    //telehealth info
    var Address:String
    var PhoneNumber:String
    var EmergencyContact:String
    var EmergencyPhone:String
    var SessionCount:String
    
    //Telehealth Initial Session
    var Pronoun:String
    var PossessivePronoun:String
    var ReflexivePronoun:String
    var ThirdPersonPronoun:String
    var Referral:String
    var MainProblems:String
    var SecondaryProblems:String
    var EatSleepProblems:String
    var SIHistory:String
    var HIHistory:String
    var SelfInjuryHistory:String
    var OptAdditionalBehavioral:String
    var Abuse:String
    var OptAdditionalAbuse:String
    var Trauma:String
    var OptAdditionaTrauma:String
    var AlcoholFrequency:String
    var SubstanceFrequency:String
    var SubstanceList:String
    var OptAdditionalSubstance:String
    var Grade:String
    var Major:String
    var MajorSatisfaction:String
    var Employment:String
    var OtherData:String
    var Demographics:String
    var OutsideReferral:String
    var Plan:String
    
    init () {
        //telehealth info
        Address = ""
        PhoneNumber = ""
        EmergencyContact = ""
        EmergencyPhone = ""
        SessionCount = ""
        
        Pronoun = ""
        PossessivePronoun = ""
        ReflexivePronoun = ""
        ThirdPersonPronoun = ""
        Referral = ""
        MainProblems = ""
        SecondaryProblems = ""
        EatSleepProblems = ""
        SIHistory = ""
        HIHistory = ""
        SelfInjuryHistory = ""
        OptAdditionalBehavioral = ""
        Abuse = ""
        OptAdditionalAbuse = ""
        Trauma = ""
        OptAdditionaTrauma = ""
        AlcoholFrequency = ""
        SubstanceFrequency = ""
        SubstanceList = ""
        OptAdditionalSubstance = ""
        Grade = ""
        Major = ""
        MajorSatisfaction = ""
        Employment = ""
        OtherData = ""
        Demographics = ""
        OutsideReferral = ""
        Plan = ""
    }
}


//Struct used to hold the information that will replace the symbols in the SCS initial contact note template file
struct SCSNoteInfo_InitialContact {
    var Name:String
    var Date:String
    var Time:String
    
    init () {
        Name = ""
        Date = ""
        Time = ""
    }
}

//Struct used to hold the information that will replace the symbols in the scs group session note template file
struct SCSNoteInfo_GroupSession {
    var GroupName:String
    var GroupLeaders:String
    var GroupNumSession:String
    var GroupNumPresent:String
    var GroupSessionSummary:String
    var GroupNextMeeting:String
    
    init () {
        GroupName = "ACT UP"
        GroupLeaders = ""
        GroupNumSession = ""
        GroupNumPresent = ""
        GroupSessionSummary = ""
        GroupNextMeeting = ""
    }
}

//Struct used to hold the information tht will replace the symbols in the scs termination note template file
struct SCSNoteInfo_IndividualTermination {
    
    var Pronoun:String
    var PPronoun:String
    var TermIntakeDate:String
    var TermLastServiceDate:String
    var TermNumSessions:String
    var TermNumTriage:String
    var TermNumIntake:String
    var TermNumIndividual:String
    var TermNumAdvocacy:String
    var TermNumOther:String
    var TermPresentingProb:String
    var TermDiagnosisIntake:String
    var TermTopicsCovered:String
    var TermImproved:String
    var TermNeedsWork:String
    
    init () {
        
         Pronoun = ""
         PPronoun = ""
         TermIntakeDate = ""
         TermLastServiceDate = ""
         TermNumSessions = ""
         TermNumTriage = ""
         TermNumIntake = ""
         TermNumIndividual = ""
         TermNumAdvocacy = ""
         TermNumOther = ""
         TermPresentingProb = ""
         TermDiagnosisIntake = ""
         TermTopicsCovered = ""
         TermImproved = ""
         TermNeedsWork = ""
    }
}

//Struct Used to keep track of new SCS client information
struct SCSNewClient {
    
    var name:String
    var address:String
    var phoneNumber:String
    var emergencyContact:String
    var emergencyPhone:String
    var sessionCount:String
    
    init(){
        name = ""
        address = ""
        phoneNumber = ""
        emergencyContact = ""
        emergencyPhone = ""
        sessionCount = ""
    }
}

//Struct Used to keep track of new SCS client information
struct SCSNewSupervisee {
    
    var name:String
    var sessionCount:String
    
    init(){
        name = ""
        sessionCount = ""
    }
    
}

