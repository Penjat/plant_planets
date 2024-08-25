import SwiftUI

struct ContentView: View {
    @State var options = Options()
    @State var showMenu = false
    var body: some View {
        VStack {
            MetalView(options: options)
            
                .border(Color.black, width: 2)
                .onTapGesture { point in
                    options.commandSubject.send(.createCell(position: point))
                    print(point)
                }.sheet(isPresented: $showMenu, content: {
                    SlidersViewIOS(options: options)
                })
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
