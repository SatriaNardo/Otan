import SwiftUI
import UIKit
import Combine

class OrientationManager: ObservableObject {
    static let shared = OrientationManager()
    
    @Published var orientationMask: UIInterfaceOrientationMask = .portrait
    
    private init() {}
    
    func lock(_ orientation: UIInterfaceOrientationMask) {
        DispatchQueue.main.async {
            self.orientationMask = orientation
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            
            // This is the heavy-duty command
            let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientation)
            
            windowScene.requestGeometryUpdate(geometryPreferences) { error in
                print("DEBUG: Rotation blocked: \(error.localizedDescription)")
            }
            
            // This tells the window to wake up and re-read the rules
            windowScene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
}
