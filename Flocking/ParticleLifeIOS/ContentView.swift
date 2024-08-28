import SwiftUI

struct ContentView: View {
    @State var options = Options()
    @State var showMenu = false
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(.black)
            MetalView(options: options)
                .onTapGesture { point in
                    options.commandSubject.send(.createCell(position: point))
                    print(point)
                }
            HStack {
                CellColorPicker(cellType: $options.selectedType).onTapGesture {
                    print("never gets called ")
                }
                Spacer()
            }.padding()

        }
        .ignoresSafeArea()
        .sheet(isPresented: $showMenu, content: {
            SlidersViewIOS(options: options)
        })


    }
}

#Preview {
    ContentView()
}
