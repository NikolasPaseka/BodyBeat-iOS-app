//
//  LabelTimerView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI

struct LabelTimerView: View {
    var label: String
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Picker("Picker", selection: $minutes) {
                ForEach(0..<6) { minute in
                    Text("\(minute)")
                }
            }.pickerStyle(WheelPickerStyle())
                .frame(width: 60)
                .clipped()
                .compositingGroup()
            Text(":")
            Picker("Picker", selection: $seconds) {
                ForEach(0..<60) { second in
                    Text("\(second)").tag(second)
                }
            }.pickerStyle(WheelPickerStyle())
                .frame(width: 60)
                .clipped()
                .compositingGroup()
        }
    }
}

//extension UIPickerView {
//    open override var intrinsicContentSize: CGSize {
//        return CGSize(width: UIView.noIntrinsicMetric , height:  super.intrinsicContentSize.height)
//    }
//}

struct LabelTimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LabelTimerView(label: "test", minutes: .constant(0), seconds: .constant(0))
        }.previewLayout(.fixed(width: 300, height: 70))
    }
}
