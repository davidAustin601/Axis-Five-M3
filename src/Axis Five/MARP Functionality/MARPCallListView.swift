//
//  MARPCallListView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/14/21.
//
//  FILE DESCRIPTION: View used to generate a new monthly call list for the MARP drug screens

import SwiftUI
import AlertToast

struct MARPCallListView: View {


    @EnvironmentObject var GlobalPreferences: GlobalPreferences //Global variables for handling preferences across views
    @EnvironmentObject var MARPFunctions:MARPFunctionality //Global variable for handling all MARP functions
    //Variables used for call list preferences
    @State var outputDIR:String = "/Users/davidaustin/Library/CloudStorage/Dropbox/MARP/DRUG SCREENS/Logs/Monthly Reports"
    @State var selectedMonth:String = "August"
    @State var selectedYear:String = "2021"
    private let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    @State var selectedRow:[String] = [String]()
    @State private var newVacation_name:String = ""
    @State private var newVacation_startDate:String = ""
    @State private var newVacation_endDate:String = ""
    //Bools for all Alerts
    @State private var showAlert_CallListComplete = false
    //..USING LOCAL VARIABLES TO PROPERLY UPDATE SCROLL VIEW WHEN CLIENT VACATIONS ARE ADDED OR REMOVED
    @State private var localVacations = [[String]]()
    
    var body: some View {
        
        //Main content
        VStack {
            //Output Preferences
            VStack (alignment: .leading) {
                
                //OUTPUT DIR FOR CALL LIST
                HStack{
                    Text("Output Directory")
                        .textStyle(LabelTypeStyle())
                    TextField(outputDIR, text: $outputDIR)
                        .textFieldStyle(GlobalTextFieldStyle())
                        .frame(width:570)
                }
                
                //MONTH YEAR
                HStack {
                    
                    //Month
                    Text("Month")
                        .textStyle(LabelTypeStyle())
                    TextField(selectedMonth, text: $selectedMonth)
                        .frame(width:250)
                        .textFieldStyle(GlobalTextFieldStyle())
                         
                    
                    //Year
                    Text("Year")
                        .textStyle(LabelTypeStyle())
                    TextField(selectedYear, text: $selectedYear)
                        .frame(width:250)
                        .textFieldStyle(GlobalTextFieldStyle())
                 
                    
                    Button("Select DIR"){
                        outputDIR = selectDIR()
                    }
                    .buttonStyle(SelectButtonStyle())
                }
            }

            //Vacations Section
            Text("Vacations")
                .textStyle(BigLabelTypeStyle())
            
            //Section below the Vacations label
            HStack (alignment: .top){
                
                //Section to the Left of the grid where they can add or remove vacation dates
                HStack {
                    
                    VStack (alignment: .leading, spacing: 10){
                        
                        HStack {
                            TextField(newVacation_name, text: $newVacation_name)
                                .frame(width:200)
                                .textFieldStyle(GlobalTextFieldStyle())
                            Text("Name")
                                .textStyle(LabelTypeStyle())
                            
                            Spacer()
                        }
                        
                        HStack {
                            TextField(newVacation_startDate, text: $newVacation_startDate)
                                .frame(width:200)
                                .textFieldStyle(GlobalTextFieldStyle())
                            Text("Start Date")
                                .textStyle(LabelTypeStyle())
                            
                            Spacer()
                        }
                        
                        HStack {
                            TextField(newVacation_endDate, text: $newVacation_endDate)
                                .frame(width:200)
                                .textFieldStyle(GlobalTextFieldStyle())
                            Text("End Date")
                                .textStyle(LabelTypeStyle())
                            
                            Spacer()
                        }
                        
                        //Button underneat the textfields section to add or remove vacations
                        HStack {
                            
                            //Add vacation button
                            Button("Add Vacation") {
                                
                                if ((newVacation_name != "") && (newVacation_startDate != "") && (newVacation_endDate != "")) {
                                    
                                    let tempVacationArray = [newVacation_name, newVacation_startDate, newVacation_endDate]
                                    
                                    let tempArray = MARPFunctions.CallList.AddMARPVacation(newVacation: tempVacationArray, originalVacations: MARPFunctions.CallList.MemberVacations.vacations)
                                    
                                    //Add vacation array to global variable
                                    MARPFunctions.CallList.MemberVacations.vacations = tempArray
                                    
                                    //Add vaction array to local variable
                                    localVacations = tempArray
                                }
                            }
                            .buttonStyle(SelectButtonStyle())
                            
                            //Spacer between buttons
                            Spacer()
                                .frame(width:20)
                            
                            //Remove selected vacation button
                            Button("Remove Selected"){
                                
                                //make sure the selected [String] is not empy
                                if (!selectedRow.isEmpty) {
                                    
                                    //remove the vacation from the global array and assign it to a temporary variable
                                    let tempVacationArray = MARPFunctions.CallList.RemoveMARPVacation(selectedVacation: selectedRow, originalVacations: MARPFunctions.CallList.MemberVacations.vacations)
                                    
                                    //Assign newly created array to global variable
                                    MARPFunctions.CallList.MemberVacations.vacations = tempVacationArray
                                    
                                    //Assign newly created array to local variable
                                    localVacations = tempVacationArray
                                    
                                }
                            }
                            .buttonStyle(SelectButtonStyle())
                        }
                    }
                    .frame(width:300)
                    
                    Spacer()
                }
                
                //Vertical divider between textfield section and the vacations list
                Divider()
                    .padding(.trailing, 10)
                
                //Grid of Marp Vacation Names, Start Dates, and End Dates
                HStack {
                    
                    VStack (alignment: .trailing){
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), alignment: .leading) {
                            
                            ForEach(localVacations, id:\.self) { row in
                                
                                VStack (alignment: .trailing){
                                    //Vacation Information Row
                                    HStack {
                                        Text("\(row[0]):")
                                            .font(.custom("Avenir-Light", size: 15))
                                            .foregroundColor(selectedRow == row ? Color.white: Color.OffBlack)
                                            .background(Color.clear)
                                        
                                        Spacer()
                                        
                                        Text("\(row[1]) - \(row[2])")
                                            .font(.custom("Avenir-Light", size: 15))
                                            .foregroundColor(selectedRow == row ? Color.white: Color.OffBlack)
                                            .background(Color.clear)
                                    }
                                    .onTapGesture {
                                        selectedRow = row
                                    }
                                }
                            }
                        }
                    }
                    
                    //Spacer used to better align the vacations section
                    Spacer()
                    
                }
                
                //Spacer to better align vacations section
                Spacer()
            }
            
            //button at the bottom of the window to create calllist
            HStack {
                
                //Spacer used to make sure the run button is at the bottom right of the window
                Spacer()
                
                //Run button
                Button ("Run") {
                    
                  
                    
                    //Get the names of members who have a vacation on this month according to the vacations csv file
                    let currentMonthVacations = MARPFunctions.CallList.GatherMonthVacations(vacations: MARPFunctions.CallList.MemberVacations.vacations, selectedMonth: selectedMonth)
                    
                    //generate the output directory along with the file name (DrugScreen-CallList-(June-2021).xlsx)
                    let outputPath = MARPFunctions.CallList.CreateCallListPath(outputDIR: outputDIR, month: selectedMonth, year: String(selectedYear))
                    
                    //create the directories
                    MARPFunctions.CallList.CreateMonthDIRs(members: MARPFunctions.MemberManagement.MemberNameList, dirPath: outputDIR, month: selectedMonth, year: String(selectedYear))
                    
                    
                    //run the python script
                    _ = MARPFunctions.CallList.RunCallListScript(csvFilePath: MARPMemberListPath.path, outputPath: outputPath, vacations: currentMonthVacations)
                    
                    //Change bool which will show an alert 
                    showAlert_CallListComplete.toggle()
                }
                .buttonStyle(RunButtonStyle())
                .frame(alignment: .trailing)
                .padding(.bottom, 40)
                
            }
        }
        .padding(10)
        .onAppear(perform: {
            
            //Get current date
            let currentDate = Date()
            //Add month to current date
            var dateComponent = DateComponents()
            dateComponent.month = 1
            let nextMonth = Calendar.current.date(byAdding: dateComponent, to: currentDate)
            //Extract month from the date type
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            let monthString = dateFormatter.string(from: nextMonth!)
            //Extract current year from date type
            dateFormatter.dateFormat = "yyyy"
            let yearString = dateFormatter.string(from: currentDate)
            
            //Set the Defaults
            selectedMonth = monthString
            selectedYear = yearString
            
            //Initialize local vacation variable
            localVacations = MARPFunctions.CallList.MemberVacations.vacations
        })
        .toast(isPresenting: $showAlert_CallListComplete){
            AlertToast(displayMode: .alert, type: .complete(Color.OffBlack), title: "Call List Generated")
        }
    }
}

struct MARPCallListView_Previews: PreviewProvider {
    static var previews: some View {
        MARPCallListView().environmentObject(GlobalPreferences())
    }
}
