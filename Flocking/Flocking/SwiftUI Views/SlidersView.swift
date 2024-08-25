import SwiftUI

// swiftlint:disable unused_closure_parameter

struct SlidersView: View {
    @Bindable var options: Options

    @State var selectedIndex = IndexDude(item: 0, section: 0)
    @State var selectedSlider = 0.0

    init(options: Options) {
        self.options = options
    }

    var body: some View {
        VStack {
            Picker("", selection: $options.selectedType) {
                ForEach(BoidType.allCases, id: \.self) { cellType in
                    Text(cellType.name).tint(cellType.color)
                }
            }
            .colorMultiply(options.selectedType.color)
            .pickerStyle(SegmentedPickerStyle())
            HStack {
                Grid {
                    GridRow {
                        Rectangle().fill(.clear).frame(width: 10, height: 10)
                        ForEach(0..<6) { colorIndex in
                            Rectangle().fill(BoidType(rawValue: Int32(colorIndex))?.color  ?? .gray).frame(width: 10, height: 10)
                        }
                    }

                    ForEach(0..<6) { rowIndex in
                        GridRow {
                            Rectangle().fill(BoidType(rawValue: Int32(rowIndex))?.color ?? .gray).frame(width: 10, height: 10)
                            ForEach(0..<6) { colIndex in

                                let string = String(format: "%.2f", options.getValueFromMatrix(row: rowIndex, col:colIndex)*10000)
                                Text(string).font(.footnote)
                                    .frame(width:40, height: 40)
                                    .background(selectedIndex == IndexDude(item: rowIndex, section: colIndex) ? .gray : .clear)
                                    .onTapGesture {
                                        selectedIndex = IndexDude(item: rowIndex, section: colIndex)
                                        selectedSlider = Double(options.getValueFromMatrix(row: rowIndex, col: colIndex))
                                    }
                            }
                        }
                    }
                    Slider(value: $selectedSlider, in: Double(options.attractionRange.lowerBound)...Double(options.attractionRange.upperBound)) { changed in
                        options.setValueInMatrix(row: selectedIndex.item, col: selectedIndex.section, value: Float(selectedSlider))
                    }
                }.padding()
                VStack {
                    
                    Button {
                        options.randomizeMatrix()
                    } label: {
                        Text("Radnomize Attraction")
                    }

                    Button {
                        options.clearMatrix()
                    } label: {
                        Text("Clear Atttraction")
                    }
                    Button {
                        options.commandSubject.send(.randomizePosition)
                    } label: {
                        Text("Radomize Position")
                    }

                    Button {
                        options.particleCount = 1
                    } label: {
                        Text("Clear Cells")
                    }

                    Text("Cells: \(options.particleCount)")

                    Text("Radius for neigbors:")
                    Text("\(options.neighborRadius, specifier: "%.0f")")
                    Slider(value: $options.neighborRadius, in: 50...1000) { editing in
                    }

                    Text("Max Speed: \(options.maxSpeed)")
                    Slider(value: $options.maxSpeed, in: 0.5...20.0)

                    Text("Particle Size: \(options.particleSize)")
                    Slider(value: $options.particleSize, in: 1.0...20.0)

                    Text("friction: \(1-options.friction)")
                    Slider(value: $options.friction, in: 0.8...1.0)
                }.frame(width: 200)
            }
        }
    }
}
// swiftlint:enable unused_closure_parameter
