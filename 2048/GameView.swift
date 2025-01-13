import SwiftUI

struct GameView: View {
    @StateObject private var gameManager = GameManager()
    @State private var selectedSize: Int = 4

    var body: some View {
        let tileSize = UIScreen.main.bounds.width / CGFloat(gameManager.size + 2)

        VStack {
            Text("2048")
                .font(.largeTitle)
                .bold()
                .padding()

            Picker("Board Size", selection: $selectedSize) {
                Text("4x4").tag(4)
                Text("5x5").tag(5)
                Text("6x6").tag(6)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedSize) { _, newSize in
                gameManager.startNewGame(size: newSize)
            }

            VStack {
                Text("Score: \(gameManager.score)")
                    .font(.headline)
                Text("Moves: \(gameManager.movesCount)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 16)

            VStack(spacing: 4) {
                ForEach(0..<gameManager.size, id: \.self) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<gameManager.size, id: \.self) { col in
                            TileView(value: gameManager.board[row][col], size: tileSize)
                        }
                    }
                }
            }
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(16)

            if gameManager.gameOver {
                Text("Game Over!")
                    .font(.title)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Restart") {
                gameManager.startNewGame()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .gesture(
            DragGesture()
                .onEnded { value in
                    let direction = determineSwipeDirection(value)
                    gameManager.swipe(direction: direction)
                }
        )
    }

    private func determineSwipeDirection(_ value: DragGesture.Value) -> SwipeDirection {
        let horizontal = value.translation.width
        let vertical = value.translation.height

        if abs(horizontal) > abs(vertical) {
            return horizontal > 0 ? .right : .left
        } else {
            return vertical > 0 ? .down : .up
        }
    }
}
