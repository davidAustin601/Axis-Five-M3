//
//  SCSNotePreview.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/16/21.
//
//  FILE DESCRIPTION: View used to show the created notes 

import SwiftUI



struct SCSNotePreview: View {
    
    //NEW ENVIRONMENT OBJECT
    @EnvironmentObject var SCSFunctions:SCSFunctionality
    
    //Alert used on a button
    @State private var showAlert = false
    
    
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
                .foregroundColor(Color(hex:  UInt64(mainColorArray[bgColorIndex])))
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
            
            //Main Content
            VStack {
                
                //Close button (XMark) on the top left of the window
                HStack {
                    //Close Button
                    Button {
                        NSApplication.shared.keyWindow?.close()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.largeTitle)
                    }
                    .buttonStyle(RunButtonStyle())
                    
                    Spacer()
                }
                .padding(.top, 0)
                .padding(.bottom, 10)
                .padding(.leading, 20)
                
                //Scrollview holding the newly created note
                ScrollView {
                    
                    VStack {
                        
                        //Editor to show the selected marp members' information
                        TextEditor(text: $SCSFunctions.Notes.CurrentNote)
                            .frame(height: 500, alignment: .leading)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.OffBlack, lineWidth: 1)
                            )
                            .font(.custom("Avenir-Light", size: 15))
                        
                    }
                    .padding(10)
                    
                }
                
                //Buttons at the bottom of the window, underneath the note preview
                HStack {
                    //used to align buttons to the right of the window
                    Spacer()
                        .frame(height:50)
                    
                    //Copy Button
                    Button("Copy") {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString(SCSFunctions.Notes.CurrentNote, forType: .string)
                        
                        showAlert.toggle()
                    }
                    .keyboardShortcut("c", modifiers: .command)
                    .alert(isPresented: $showAlert) { () -> Alert in
                        Alert(title: Text("Note Copied!"))
                    }
                    .buttonStyle(RunButtonStyle())
                    
                    //Cancel Button
                    Button("Cancel") {
                        NSApplication.shared.keyWindow?.close()
                    }
                    .buttonStyle(RunButtonStyle())
                    
                    
                }
                .padding(.bottom, 40)
                .padding(.trailing, 10)
                
            }
        }
        
    }
}

struct SCSNotePreview_Previews: PreviewProvider {
    static var previews: some View {
        SCSNotePreview()
            .environmentObject(SCSFunctionality())
    }
}
