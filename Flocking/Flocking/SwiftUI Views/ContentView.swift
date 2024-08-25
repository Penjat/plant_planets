import SwiftUI

struct ContentView: View {
  @State var options = Options()
  var body: some View {
    VStack {
      MetalView(options: options)

        .border(Color.black, width: 2)
        .onTapGesture { point in
            options.commandSubject.send(.createCell(position: point))
            print(point)
        }
        SlidersView(options: options)
    }
    .padding()
    .frame(minWidth: 800)
  }
}

#Preview {
  ContentView()
}
