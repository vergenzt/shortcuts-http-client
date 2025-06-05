import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Spacer()
      
      Text("Hello, Shortcuts developer!")
        .font(.largeTitle)
        .multilineTextAlignment(.center)
      
      Spacer()
      
      Text("Open the Shortcuts app to view this app's shortcuts.")
        .multilineTextAlignment(.center)
      
      Spacer()
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
