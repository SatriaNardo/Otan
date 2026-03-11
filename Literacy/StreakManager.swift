import Foundation

class StreakManager {
    static let shared = StreakManager()
    private init() {}
    
    func logAppOpen() {
        let rightNow = Date()
        UserDefaults.standard.set(rightNow, forKey: "lastLoginDate")
        print("Backend Success: Logged app open at \(rightNow)")
    }
}//
//  StreakManager.swift
//  Literacy
//
//  Created by Ferdynand Kee on 11/03/26.
//

