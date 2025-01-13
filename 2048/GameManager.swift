import SwiftUI

class GameManager: ObservableObject {
    @Published var board: [[Int]] = []
    @Published var score: Int = 0
    @Published var movesCount: Int = 0
    @Published var gameOver: Bool = false
    @Published var size: Int

    init(size: Int = 4) {
        self.size = size
        startNewGame()
    }

    func startNewGame(size: Int? = nil) {
        if let newSize = size {
            self.size = newSize
        }
        board = Array(repeating: Array(repeating: 0, count: self.size), count: self.size)
        score = 0
        movesCount = 0
        gameOver = false
        addRandomTile()
        addRandomTile()
    }

    func swipe(direction: SwipeDirection) {
        guard !gameOver else { return }

        let originalBoard = board
        switch direction {
        case .up: moveUp()
        case .down: moveDown()
        case .left: moveLeft()
        case .right: moveRight()
        }

        if board != originalBoard {
            movesCount += 1
            addRandomTile()
            if !canMakeMove() {
                gameOver = true
            }
        }
    }

    private func addRandomTile() {
        let emptyCells = board.indices.flatMap { row in
            board[row].indices.compactMap { col in
                board[row][col] == 0 ? (row, col) : nil
            }
        }
        guard !emptyCells.isEmpty else { return }
        let (row, col) = emptyCells.randomElement()!
        board[row][col] = Int.random(in: 0..<10) < 9 ? 2 : 4
    }

    private func moveLeft() {
        for row in 0..<size {
            let (mergedRow, _) = mergeLine(board[row])
            board[row] = mergedRow
        }
    }

    private func moveRight() {
        for row in 0..<size {
            let reversedRow = board[row].reversed()
            let (mergedRow, _) = mergeLine(Array(reversedRow))
            board[row] = Array(mergedRow.reversed())
        }
    }

    private func moveUp() {
        for col in 0..<size {
            let column = (0..<size).map { board[$0][col] }
            let (mergedColumn, _) = mergeLine(column)
            for row in 0..<size {
                board[row][col] = mergedColumn[row]
            }
        }
    }

    private func moveDown() {
        for col in 0..<size {
            let column = (0..<size).map { board[$0][col] }.reversed()
            let (mergedColumn, _) = mergeLine(Array(column))
            for row in 0..<size {
                board[size - row - 1][col] = mergedColumn[row]
            }
        }
    }

    private func mergeLine(_ line: [Int]) -> ([Int], Int) {
        var newLine = line.filter { $0 != 0 }
        var mergedLine: [Int] = []
        var skipNext = false
        var points = 0

        for i in 0..<newLine.count {
            if skipNext {
                skipNext = false
                continue
            }

            if i < newLine.count - 1 && newLine[i] == newLine[i + 1] {
                let mergedValue = newLine[i] * 2
                mergedLine.append(mergedValue)
                points += mergedValue
                skipNext = true
            } else {
                mergedLine.append(newLine[i])
            }
        }

        while mergedLine.count < size {
            mergedLine.append(0)
        }

        score += points
        return (mergedLine, points)
    }

    private func canMakeMove() -> Bool {
        for row in 0..<size {
            for col in 0..<size {
                if board[row][col] == 0 { return true }
                if col < size - 1 && board[row][col] == board[row][col + 1] { return true }
                if row < size - 1 && board[row][col] == board[row + 1][col] { return true }
            }
        }
        return false
    }
}
