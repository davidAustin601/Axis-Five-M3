//
//  PreferencesView.swift
//  Axis Five
//
//  Created by Christopher Austin on 6/5/21.
//
//  FILE DESCRIPTION: View to present and allow the editing of preferences. Includes a top bar with buttons for MARP and SCS preferences as well as the actual active preference view underneath the top bar

import SwiftUI
import DynamicColor


struct PreferencesView: View {
    
    @EnvironmentObject var GlobalActivePrefsWindow: ActivePreferencesWindow
    
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
            
            //Main content
            VStack {
                //Close button (XMark) on the top left of the window
                HStack {
                    Button {
                        NSApplication.shared.keyWindow?.close()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 35.0, weight: .heavy, design: .default))
                    }
                    .buttonStyle(RunButtonStyle())

                    Spacer()
                }
                .padding(.top, 0)
                .padding(.bottom, 10)
                .padding(.leading, 20)
                .offset(y: -15)
                .offset(x: 0)
                
                //Top bar with icon buttons navigating between SCS and MARP perference views
                PreferencesTopMenuView()
                    .background(Color.clear)
                    .frame(height:10)
                    .padding(.top, 0)
                    .offset(y: -15)
                
                //Divider between top bar and currently loaded preference view
                Divider()
                
                //Check 'GlobalActivePrefsWindow' for which view should be active in the window
                switch(GlobalActivePrefsWindow.activePrefsWindows){
                case PrefsWindows.MARP:
                    MARPOptionsView()
                        .frame(minWidth:800, maxWidth: 800)
                case PrefsWindows.SCS:
                    SCSOptionsView()
                        .frame(minWidth:800, maxWidth:800)
                }
                
            }
            .padding(.top, 0)
            .background(Color.clear)
            
        }
    }
    
}

//Menu at the top of the preferences - include MARP, and SCS
struct PreferencesTopMenuView: View {
    
    @EnvironmentObject var GlobalActivePrefsWindow: ActivePreferencesWindow
    
    var body: some View {
        
        //Main HStack for content
        HStack {
            //MARP WORK SETTINGS BUTTON
            Button("MARP") {
                
                GlobalActivePrefsWindow.activePrefsWindows = PrefsWindows.MARP
            }
            .buttonStyle(PrefButtonStyle())
            
            //Space between button
            Spacer()
                .frame(width:10)
            
            //SCS WORK SETTINGS BUTTON
            Button("SCS") {
                
                GlobalActivePrefsWindow.activePrefsWindows = PrefsWindows.SCS
            }
            .buttonStyle(PrefButtonStyle())
          
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .environmentObject(GlobalPreferences())
            .environmentObject(ActivePreferencesWindow())
    }
}

