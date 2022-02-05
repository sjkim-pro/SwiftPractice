//
//  ContentView.swift
//  Calc
//
//  Created by sjkim on 2022/02/02.
//

import SwiftUI

enum CalcButton : String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "/"
    case multiply = "*"
    case equal = "="
    case clear = "C"
    case decimal = "."
    case percent = "%"
    case negative = "+/-"
    
    func buttonColorFore(toggle:Bool) -> Color {
        switch self {
        case .add, .subtract, .multiply, .divide:
            if toggle {
                return .orange
            } else {
                return .white
            }
        case .equal:
            return .white
        case .clear, .negative, .percent:
            return .black
        default:
            return .white
        }
    }
    
    func buttonColorBack(toggle:Bool) -> Color {
        switch self {
        case .add, .subtract, .multiply, .divide:
            if toggle {
                return .white
            } else {
                return .orange
            }
        case .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(.darkGray)
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    @State var value = "0"
    @State var runningNumber = 0
    @State var currentOperation: Operation = .none
    @State var currentTab = ""
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    var body: some View {
        ZStack{
            Color.black.background().edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                // Text Display
                HStack {
                    Spacer()
                    
                    Text(value)
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                }.padding()
                
                // buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12){
                        ForEach(row, id: \.self) { item in
                            
                            Button(action: {
                                self.didTab(button: item)
                            }, label:{
                                let toggle = (self.currentTab == item.rawValue)
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .bold()
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .foregroundColor(item.buttonColorFore(toggle: toggle))
                                    .background(item.buttonColorBack(toggle: toggle))
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                            
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
    
    func didTab(button: CalcButton) {
        self.currentTab = button.rawValue;
        switch button {
    
        case .add, .subtract, .divide, .multiply, .equal:
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Int(value) ?? 0
            }
            else if button == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Int(value) ?? 0
            }
            else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Int(value) ?? 0
            }
            else if button == .multiply {
                self.currentOperation = .multiply
                self.runningNumber = Int(value) ?? 0
            }
            else if button == .equal {
                let runningValue = self.runningNumber
                let currentValue = Int(self.value) ?? 0
                
                switch self.currentOperation {
                case .add: self.value = "\(runningValue + currentValue)"
                case .subtract: self.value = "\(runningValue - currentValue)"
                case .multiply: self.value = "\(runningValue * currentValue)"
                case .divide: if (currentValue == 0) {
                    self.value = "오류"
                }else {
                    self.value = "\(runningValue / currentValue)"}
                case .none:
                    break;
                }
            }
           
            if button != .equal {
                
            }
        case .clear:
            self.value = "0"
            break
        case .decimal, .percent:
            break
        case .negative:
            let number = ( Int(self.value) ?? 0 ) * -1
            self.value = String(number)
            break
        default:
            let number = button.rawValue
            if self.value == "0" || self.currentTab != "" {
                value = number
            }
            else {
                self.value = "\(self.value)\(number)"
            }
        }
        
    }
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero{
            return (UIScreen.main.bounds.width - (5 * 12)) / 4 * 2
        }
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

