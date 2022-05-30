//
//  HashGenerator.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 30.05.2022.
//

import Foundation

class HashGenerator {
    
    func getRandomHash() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0..<20 {
            s.append(letters.randomElement()!)
        }
        return s
    }
}
