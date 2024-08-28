import SwiftUI

struct CellColorPicker: View {
    @Binding var cellType: CellType
    @State var isOpen = true
    var body: some View {
        ZStack {
            Circle().fill(cellType.color).frame(width: 20, height: 20)



            if isOpen {

                ForEach(CellType.allCases, id: \.rawValue) { cellType in
                    Circle()
                        .fill(cellType.color)
                        .offset(x:0, y: CGFloat((cellType.rawValue+1)*(-30)))
                        .frame(width: 20, height: 20)

                }
            }
        }.onTapGesture {
            //                    withAnimation {
            isOpen.toggle()
            //                    }
            print("tapped")
        }

    }
}

#Preview {
    CellColorPicker(
        cellType: .constant(.red))
}
