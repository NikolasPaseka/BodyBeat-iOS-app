//
//  NumberPickerView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI

struct NumberPickerView: View {
    var label: String
    var maxInputRange: Int
    
    @Binding var selectedNumber: Int
    
    var body: some View {
        VStack {
            Text(label)
            Picker("Picker", selection: $selectedNumber) {
                ForEach(0..<maxInputRange) { number in
                    Text("\(number)")
                }
            }.pickerStyle(WheelPickerStyle())
                .frame(width: 60, height: 60)
                .clipped()
                .compositingGroup()
        }
    }
}

extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric , height:  UIView.noIntrinsicMetric)
    }
}


struct NumberPickerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NumberPickerView(label: "label", maxInputRange: 10, selectedNumber: .constant(0))
        }.previewLayout(.fixed(width: 300, height: 70))
    }
}
