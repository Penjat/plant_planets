import SwiftUI

struct MenuView: View {
    @ObservedObject var appState: AppState
//    @State var attractionSlider:
    @State var selectedIndex = IndexPath(row: 0, section: 0)
    @State var selectedSlider = 0.0

    let formatter = NumberFormatter()
    var body: some View {
        VStack {
            NumberTextField(number: $appState.maxSpeed, formatter: formatter)

            NumberTextField(number: $appState.repulsionForce, formatter: formatter)
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
                                .background(selectedIndex == IndexPath(row: rowIndex, section: colIndex) ? .gray : .clear)
                                .onTapGesture {
                                    selectedIndex = IndexPath(row: rowIndex, section: colIndex)
                                    selectedSlider = appState.cellAttractionModel.cellAttractionMatrix[rowIndex][colIndex].attraction
                                }
                        }
                    }
                }
            }.padding()
            Slider(value: $selectedSlider, in: -1.0...1.0) { changed in
                appState.cellAttractionModel.cellAttractionMatrix[selectedIndex.row][selectedIndex.section].attraction = selectedSlider
            }.onChange(of: selectedSlider) { newValue in
                appState.cellAttractionModel.cellAttractionMatrix[selectedIndex.row][selectedIndex.section].attraction = selectedSlider
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




struct NumberTextField: View {
    @Binding var number: CGFloat
    let formatter: NumberFormatter
    var body: some View {
        TextField("", text: Binding<String>(
            get: {
                // Convert CGFloat to String
                return "\(number)"
            },
            set: { newValue in
                // Convert String to CGFloat
                if let n = formatter.number(from: newValue) {
                    number = CGFloat(truncating: n)
                }
            }
        ))
    }
}
