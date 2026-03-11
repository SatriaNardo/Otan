import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .padding()
            Text("Settings Screen")
                .font(.title2)
        }
    }
}

#Preview {
    SettingsView()
}
