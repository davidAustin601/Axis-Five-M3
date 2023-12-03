//
//  GlobalDesignCode.swift
//  Axis Five
//
//  Created by Christopher Austin on 7/19/21.
//
//  FILE DESCRIPTION: This file includes the various design changes for the entire program including colors, button styles, text styles, etc.

import Foundation
import SwiftUI
import AppKit

//*********************** COLORS ****************************
extension Color {
    static let OffBlack = Color("OffBlack")
}

//*********************** BUTTON DESIGN ****************************
struct RunButtonStyle: ButtonStyle {
    
    @State private var overButton = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(0)
            .foregroundColor(overButton ? Color.white: Color.OffBlack)
            .font(.custom("HelveticaNeueLT-95Blk", size: 35))
            .onHover { over in
                overButton = over
            }
    } 
}

struct SelectButtonStyle: ButtonStyle {
    
    @State private var overButton = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(0)
            .foregroundColor(overButton ? Color.white: Color.OffBlack)
            .font(.custom("HelveticaNeueLT-95Blk", size: 15))
            .onHover { over in
                overButton = over
            }
    }
}

struct MenuLinkButtonStyle: ButtonStyle {
    
    @State private var overButton = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(overButton ? Color.white: Color.OffBlack)
            .font(.custom("Avenir-Light", size: 15))
            .onHover { over in
                overButton = over
            }
    }
}

struct PrefButtonStyle: ButtonStyle {
    
    @State private var overButton = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(0)
            .foregroundColor(overButton ? Color.white: Color.OffBlack)
            .font(.custom("HelveticaNeueLT-95Blk", size: 45))
            .onHover { over in
                overButton = over
            }
    }
}

//*********************** TEXT FIELDS DESIGN ****************************
//Remove the focus ring around fields
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

//Design used for all text fields throughout the program
struct GlobalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .textFieldStyle(PlainTextFieldStyle())
            .padding(7)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.OffBlack, lineWidth: 1)
                    .frame(height:25)
            )
            .font(Font.custom("Avenir-Light", size: 16))
            .frame(height:25)
            .foregroundColor(Color.OffBlack)
    }
    
}

//Button on the right side of text fields for clearing the field while typing
//struct TextClearButton: ViewModifier {
//    @Binding var text: String
//    @State private var overButton = false
//
//    public func body(content: Content) -> some View
//    {
//
//        ZStack(alignment: .trailing)
//        {
//            content
//
//            if !text.isEmpty
//            {
//                Button(action:
//                        {
//                            self.text = ""
//                        })
//                {
//                    Image(systemName: "xmark")
//                        .foregroundColor(overButton ? Color.white: Color.OffBlack)
//                        .onHover(perform: { over in
//                            overButton = over
//                        })
//                }
//                .padding(.trailing, 8)
//                .buttonStyle(PlainButtonStyle())
//            }
//        }
//    }
//}

//*********************** TEXT FIELDS DESIGN ****************************
//MARK:- Checkbox Field
struct CheckboxField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let callback: (String, Bool)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 10,
        color: Color = Color.OffBlack,
        callback: @escaping (String, Bool)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.callback = callback
    }
    
    @State var isMarked:Bool = false
    
    var body: some View {
        Button(action:{
            self.isMarked.toggle()
            self.callback(self.id, self.isMarked)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "checkmark.square" : "square") 
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                 
                Text(label)
                    .font(Font.system(size: size))
                    .textStyle(CheckboxLabelStyle())
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(color)
        .buttonStyle(PlainButtonStyle())
    }
}

struct CompletedCheckboxField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let callback: (String, Bool)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 10,
        color: Color = Color.OffBlack,
        callback: @escaping (String, Bool)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.callback = callback
    }
    
    @State var isMarked:Bool = true
    
    var body: some View {
        Button(action:{
            self.isMarked.toggle()
            self.callback(self.id, self.isMarked)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "checkmark.square" : "square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                    .foregroundColor(color)
                 
                Text(label)
                    .strikethrough(true)
                    .font(Font.system(size: size))
                    .textStyle(CompletedCheckboxLabelStyle())
                
                Spacer()
            }
            .foregroundColor(self.color)
        }
        .foregroundColor(color)
        .buttonStyle(PlainButtonStyle())
    }
}

//*********************** TEXT STYLES ****************************
struct BigLabelTypeStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("HelveticaNeueLT-95Blk", size: 25))
            .foregroundColor(Color.OffBlack)
            .background(Color.clear)
    }
}

struct LabelTypeStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Avenir-Light", size: 15))
            .foregroundColor(Color.OffBlack)
            .background(Color.clear)
    }
}

struct CheckboxLabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Avenir-Light", size: 20))
            .foregroundColor(Color.OffBlack)
            .background(Color.clear)
    }
}

struct CompletedCheckboxLabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Avenir-Light", size: 20))
            .foregroundColor(Color.OffBlack)
            .background(Color.clear)
    }
}

struct BodyTypeStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Avenir-Light", size: 25))
            .foregroundColor(Color.OffBlack)
            .background(Color.clear)
    }
}

struct SideBarMenuItemTypeStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Avenir-Light", size: 17))
            .background(Color.clear)
    }
}

struct SideBarMenuHeaderTypeStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("HelveticaNeueLT-95Blk", size: 35))
            .foregroundColor(Color.OffBlack)
            .background(Color.clear)
    }
}

//Extension for being able to modify text with custom styles
extension Text {
    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}

//*********************** TEXT EDITOR STYLES ****************************
//Used to make text field background transparent
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}

//***************** COLOR ARRAYS FOR ANIMATED BACKGROUNDS ***************
let colorArray:[UInt64] = [0x65CCC2, 0x6EC6B2, 0x75AA89, 0x83B88A, 0x8BB37E, 0x9EA77E, 0xB0987A, 0xC18F77, 0xD28274, 0xE27771, 0xEC6E72, 0xE17180, 0xD5758E, 0xC9769D, 0xBD79AC, 0xB07BBD, 0xA280CD, 0x9687D5, 0x8E93D2, 0x849FD0, 0x7BADCD, 0x71B9CB, 0x66C8C7, 0x65CCBE, 0x6BC8B3, 0x75C1A4, 0x7CBC96, 0x83B98B, 0x8BB37E, 0x9EA67B, 0xAF9979, 0xC28D77, 0xD28275, 0xE47872, 0xEB6E75, 0xDD7284, 0xCE7696, 0xC078A5, 0xB47BB7, 0xA67FC8, 0x9B80D6, 0x908DD3, 0x879CD1, 0x7DA7CD, 0x73B6CC]

let colorArray2:[UInt64] = [0xFFF3A9, 0xFFD0A8, 0xFFB1B1, 0xD9D1FF, 0xB7EFFF, 0xA8E6CF, 0xDCEDC1, 0xFFD3B6, 0xFFAAA6, 0xFF8B94]

let colorArray3:[UInt64] = [0x92D3EC, 0x99CCFA, 0x94B4F1, 0x91A9EC, 0xABAAF6, 0xB89DF1, 0xCC99F7, 0xD793F2, 0xDE91DB, 0xE895C8, 0xEB92BD, 0xEAA0A4, 0xF4AC9F, 0xECC093, 0xEBCF96, 0xF8E6A4, 0xF1F6A2, 0xDDF6A2, 0xCDF89E, 0xC9FBA9, 0xB4F1BA, 0xB1FEDB]

let mainColorArray:[UInt64] = [0x65CCC2, 0x6EC6B2, 0x75AA89, 0x83B88A, 0x8BB37E, 0x9EA77E, 0xB0987A, 0xC18F77, 0xD28274, 0xE27771, 0xEC6E72, 0xE17180, 0xD5758E, 0xC9769D, 0xBD79AC, 0xB07BBD, 0xA280CD, 0x9687D5, 0x8E93D2, 0x849FD0, 0x7BADCD, 0x71B9CB, 0x66C8C7, 0x65CCBE, 0x6BC8B3, 0x75C1A4, 0x7CBC96, 0x83B98B, 0x8BB37E, 0x9EA67B, 0xAF9979, 0xC28D77, 0xD28275, 0xE47872, 0xEB6E75, 0xDD7284, 0xCE7696, 0xC078A5, 0xB47BB7, 0xA67FC8, 0x9B80D6, 0x908DD3, 0x879CD1, 0x7DA7CD, 0x73B6CC, 0xFFF3A9, 0xFFD0A8, 0xFFB1B1, 0xD9D1FF, 0xB7EFFF, 0xA8E6CF, 0xDCEDC1, 0xFFD3B6, 0xFFAAA6, 0xFF8B94, 0x92D3EC, 0x99CCFA, 0x94B4F1, 0x91A9EC, 0xABAAF6, 0xB89DF1, 0xCC99F7, 0xD793F2, 0xDE91DB, 0xE895C8, 0xEB92BD, 0xEAA0A4, 0xF4AC9F, 0xECC093, 0xEBCF96, 0xF8E6A4, 0xF1F6A2, 0xDDF6A2, 0xCDF89E, 0xC9FBA9, 0xB4F1BA, 0xB1FEDB]
