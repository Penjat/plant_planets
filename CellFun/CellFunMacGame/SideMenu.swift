import SwiftUI

class SideMenuWindowController: NSWindowController {

    convenience init(appState: AppState) {
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 250, height: 500),
                              styleMask: [.titled, .closable],
                              backing: .buffered,
                              defer: false)
        window.title = "Side Menu"
        window.isReleasedWhenClosed = false

        self.init(window: window)
        window.contentViewController = NSHostingController(rootView: SideMenuView(appState: appState))
    }
}


struct SideMenuView: View {
    @ObservedObject var appState: AppState
    @State var selectedIndex = IndexPath(item: 0, section: 0)
    @State var selectedSlider = 0.0
    var body: some View {
        VStack {

            Picker(selection: $appState.selectedType) {
                ForEach(CellType.allCases, id: \.self) { cellType in
                    Text(cellType.name).tint(cellType.color)
                }
            } label: {

            }
            .colorMultiply(appState.selectedType.color)
            .pickerStyle(SegmentedPickerStyle())

            // Matrix
            Divider()

            Grid {
                GridRow {
                    Rectangle().fill(.clear).frame(width: 10, height: 10)
                    ForEach(0..<6) { colorIndex in
                        Rectangle().fill(CellType(rawValue: colorIndex)?.color  ?? .gray).frame(width: 10, height: 10)
                    }
                }

                ForEach(0..<6) { rowIndex in
                    GridRow {
                        Rectangle().fill(CellType(rawValue: rowIndex)?.color ?? .gray).frame(width: 10, height: 10)
                        ForEach(0..<6) { colIndex in

                            let string = String(format: "%.2f", appState.cellAttractionModel.cellAttractionMatrix[rowIndex][colIndex].attraction)
                            Text(string).font(.footnote)
                                .frame(width:40, height: 40)
                                .background(selectedIndex == IndexPath(item: rowIndex, section: colIndex) ? .gray : .clear)
                                .onTapGesture {
                                    selectedIndex = IndexPath(item: rowIndex, section: colIndex)
                                    selectedSlider = appState.cellAttractionModel.cellAttractionMatrix[rowIndex][colIndex].attraction
                                }
                        }
                    }
                }
            }.padding()
            Slider(value: $selectedSlider, in: -1.0...1.0) { changed in
                appState.cellAttractionModel.cellAttractionMatrix[selectedIndex.item][selectedIndex.section].attraction = selectedSlider
            }.onChange(of: selectedSlider) { newValue in
                appState.cellAttractionModel.cellAttractionMatrix[selectedIndex.item][selectedIndex.section].attraction = selectedSlider
            }


            Button {
                appState.cellAttractionModel.resetMatrix()
            } label: {
                Text("clear matrix")
            }

            Button {
                appState.clearNodes()
            } label: {
                Text("clear cells")
            }
            Button {
                appState.cellAttractionModel.randomize()
            }label: {
                Text("randomize")
            }
        }.background(.clear)
    }
}
