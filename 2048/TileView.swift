import SwiftUI

struct TileView: View {
    let value: Int
    let size: CGFloat
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(tileColor(for: value))
                .frame(width: size, height: size)
                .scaleEffect(scale)
                .animation(.easeOut(duration: 0.2), value: scale)

            if value > 0 {
                Text("\(value)")
                    .font(.system(size: size / 3))
                    .bold()
                    .foregroundColor(.white)
            }
        }
        .onChange(of: value) { oldValue, newValue in
            if newValue > oldValue {
                withAnimation {
                    scale = 1.2
                }
                withAnimation(.easeOut(duration: 0.2).delay(0.1)) {
                    scale = 1.0
                }
            }
        }
    }

    private func tileColor(for value: Int) -> Color {
        switch value {
        case 2: return Color.yellow
        case 4: return Color.orange
        case 8: return Color.red
        case 16: return Color.purple
        case 32: return Color.blue
        case 64: return Color.green
        case 128: return Color.teal
        case 256: return Color.cyan
        case 512: return Color.indigo
        case 1024: return Color.pink
        case 2048: return Color(red: 1.0, green: 0.84, blue: 0.0)
        default: return Color.gray.opacity(0.5)
        }
    }
}
