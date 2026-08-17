//
//  GameViewModel.swift
//  Chess3D
//
//  Created by Prajjwal on 06/08/26.
//
import RealityKit
import Combine
import Foundation


struct MoveLogEntry: Identifiable {
    let id = UUID()
    let text: String
}

@MainActor
final class GameViewModel: ObservableObject {
    let engine: GameEngine
    let mode: GameMode
    private var cpuPlayer: CPUPlayer?
    @Published var whiteTimeRemaining: TimeInterval = 0
    @Published var blackTimeRemaining: TimeInterval = 0
    private(set) var isClockEnabled = false
    private var timeControl: TimeControl?
    private var clockTimer: Timer?
    @Published var isAnimating = false
    @Published var moveLog: [MoveLogEntry] = []
    @Published var capturedByWhite: [PieceType] = []   // black pieces White has captured
    @Published var capturedByBlack: [PieceType] = []
    @Published var selectedSquare: Square? = nil {
        didSet { updateHighlights() }
    }
    private var squareEntities: [String: Entity] = [:]
    private var highlightEntities: [Entity] = []
    @Published var isGameOver = false
    @Published var resultText: String = ""
    private var sceneRoot: Entity?
    private var pieceEntities: [String: Entity] = [:]
    init(mode: GameMode) {
        self.engine = GameEngine()
        self.mode = mode

        var tc: TimeControl? = nil
        switch mode {
        case .vsCPU(let difficulty, let timeControl):
            self.cpuPlayer = CPUPlayer(difficulty: difficulty)
            tc = timeControl
        case .localTwoPlayer(_, let timeControl):
            tc = timeControl
        }

        if let tc {
            self.timeControl = tc
            self.isClockEnabled = true
            self.whiteTimeRemaining = tc.seconds
            self.blackTimeRemaining = tc.seconds
        }
    }
    private func matchOpponentLabel() -> String {
        switch mode {
        case .localTwoPlayer(let name, _): return "vs \(name)"
        case .vsCPU(let difficulty, _): return "CPU (\(difficulty.displayName))"
        }
    }
    // Add this helper method to GameViewModel:
    private func describeMove(_ move: Move) -> String {
        guard let attackerPiece = engine.board.piece(at: move.from) else {
            return "Piece \(move.from.algebraic)-\(move.to.algebraic)"
        }
        let attackerColor = attackerPiece.color == .white ? "White" : "Black"
        let attackerName = attackerPiece.type.rawValue.capitalized

        if move.isCapture, let capturedType = move.capturedType {
            let defenderColor = attackerPiece.color == .white ? "Black" : "White"
            let defenderName = capturedType.rawValue.capitalized
            return "\(attackerColor) \(attackerName) (\(move.from.algebraic)) captures \(defenderColor) \(defenderName) (\(move.to.algebraic))"
        } else {
            return "\(attackerColor) \(attackerName) \(move.from.algebraic)-\(move.to.algebraic)"
        }
    }
    func rematch() {
        engine.reset()
        isGameOver = false
        resultText = ""
        selectedSquare = nil
        moveLog.removeAll()
        capturedByWhite.removeAll()
        capturedByBlack.removeAll()
        isAnimating = false

        if let timeControl {
            whiteTimeRemaining = timeControl.seconds
            blackTimeRemaining = timeControl.seconds
            startClockTicking()
        }

        guard let sceneRoot else { return }
        pieceEntities.values.forEach { $0.removeFromParent() }
        pieceEntities.removeAll()

        let pieces = PieceFactory.startingPosition()
        for piece in pieces {
            sceneRoot.addChild(piece)
            if let square = piece.name.split(separator: "_").last {
                pieceEntities[String(square)] = piece
            }
        }
    }
    // Replace attach(sceneRoot:pieceEntities:) entirely:
    func attach(sceneRoot: Entity, pieceEntities: [String: Entity], squareEntities: [String: Entity]) {
        self.sceneRoot = sceneRoot
        self.pieceEntities = pieceEntities
        self.squareEntities = squareEntities
        startClockTicking()
    }
    /// Called when the player taps a square in the 3D scene.

    func handleTap(on square: Square) {
        guard !isGameOver, !isAnimating else { return }

        if let selected = selectedSquare {
            let candidateMoves = engine.legalMoves(from: selected)
            if let move = candidateMoves.first(where: { $0.to == square }) {
                perform(move: move)
            }
            selectedSquare = nil
        } else if let piece = engine.board.piece(at: square), piece.color == engine.board.sideToMove {
            selectedSquare = square
        }
    }

    private func recordCapture(_ move: Move) {
        guard move.isCapture, let capturedType = move.capturedType else { return }
        let mover = engine.board.sideToMove   // mover is the side to move BEFORE apply
        if mover == .white {
            capturedByWhite.append(capturedType)
        } else {
            capturedByBlack.append(capturedType)
        }
    }
    private func updateHighlights() {
        highlightEntities.forEach { $0.removeFromParent() }
        highlightEntities.removeAll()

        guard let selected = selectedSquare else { return }
        let destinations = engine.legalMoves(from: selected).map { $0.to }

        for square in destinations {
            guard let squareEntity = squareEntities[square.algebraic] else { continue }
            let marker = ModelEntity(
                mesh: .generatePlane(width: 0.5, depth: 0.5, cornerRadius: 0.25),
                materials: [PieceMaterials.highlight]
            )
            marker.position = [0, 0.06, 0]
            squareEntity.addChild(marker)
            highlightEntities.append(marker)
        }
    }
    private func perform(move: Move) {
        guard let sceneRoot, !isAnimating else { return }
        isAnimating = true

        if move.isCapture, let event = makeCaptureEvent(for: move) {
            CaptureAnimator.shared.handleCapture(event, in: sceneRoot) { [weak self] in
                self?.finishMove(move)
            }
        } else {
            animateQuietMove(move)
            finishMove(move)
        }
    }

    private func finishMove(_ move: Move) {
        let notation = describeMove(move)
        let applied = engine.apply(move)

        guard applied else {
            // Move became invalid between being queued and being applied — discard it silently
            // rather than corrupting visual/engine sync. This should be rare now that isAnimating blocks input.
            isAnimating = false
            return
        }
        recordCapture(move)

        capturedByWhite.removeAll()
        capturedByBlack.removeAll()
        
        updateEntityKey(for: move)
        moveLog.append(MoveLogEntry(text: notation))
        isAnimating = false

        if engine.gameOver {
            isGameOver = true
            if engine.isCheckmate {
                let winner = engine.board.sideToMove == .white ? "Black" : "White"
                resultText = "Checkmate! \(winner) wins"
                let localResult: GameResult = (winner == "White") ? .win : .loss
                ScoreboardStore.shared.record(result: localResult, mode: mode)

                let opponent = matchOpponentLabel()
                let moveTexts = moveLog.map { $0.text }
                Task { await RemoteScoreboardService.shared.uploadGame(result: localResult, opponent: opponent, moves: moveTexts) }
            } else {
                resultText = "Stalemate"
                ScoreboardStore.shared.record(result: .draw, mode: mode)
            }
            return
        }

        if case .vsCPU = mode, engine.board.sideToMove == .black {
            requestCPUMove()
        }
    }
    
    private func requestCPUMove() {
        guard let cpuPlayer else { return }
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            let board = await self.engine.board
            let move = cpuPlayer.chooseMove(board: board)
            await MainActor.run {
                if let move { self.perform(move: move) }
            }
        }
    }
   
  
    private func makeCaptureEvent(for move: Move) -> CaptureEvent? {
        guard let attacker = pieceEntities [move.from.algebraic],
              let defender = pieceEntities[move.to.algebraic],
              let attackerPiece = engine.board.piece(at: move.from),
              let capturedType = move.capturedType else { return nil }
        return CaptureEvent(attacker: attacker, defender: defender, attackerType: attackerPiece.type, defenderType: capturedType, toSquare: move.to.algebraic)
    }
    private func animateQuietMove(_ move: Move) {
        guard let entity = pieceEntities[move.from.algebraic] else { return }
        var transform = entity.transform
        transform.translation = BoardCoordinates.worldPosition(square: move.to.algebraic, yOffset: 0.001)
        entity.move(to: transform, relativeTo: entity.parent, duration: 0.3, timingFunction: .easeInOut)
    }
    private func updateEntityKey(for move: Move) {
        guard let entity = pieceEntities[move.from.algebraic] else { return }
        pieceEntities[move.from.algebraic] = nil
        pieceEntities[move.to.algebraic] = entity

        let nameParts = entity.name.split(separator: "_")
        if nameParts.count >= 2 {
            let prefix = nameParts.dropLast().joined(separator: "_")
            entity.name = "\(prefix)_\(move.to.algebraic)"
        }
    }
    
    func resign() {
        isGameOver = true
        resultText = "\(engine.board.sideToMove == .white ? "Black" : "White") wins by resignation."
        ScoreboardStore.shared.record(result: engine.board.sideToMove == .white ? .loss : .win, mode: mode)
    }
    private func startClockTicking() {
        guard isClockEnabled else { return }
        clockTimer?.invalidate()
        clockTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tickClock() }
        }
    }

    private func tickClock() {
        guard isClockEnabled, !isGameOver else { return }
        if engine.board.sideToMove == .white {
            whiteTimeRemaining = max(0, whiteTimeRemaining - 0.1)
            if whiteTimeRemaining == 0 { handleTimeout(loser: .white) }
        } else {
            blackTimeRemaining = max(0, blackTimeRemaining - 0.1)
            if blackTimeRemaining == 0 { handleTimeout(loser: .black) }
        }
    }

    private func handleTimeout(loser: PieceColor) {
        clockTimer?.invalidate()
        isGameOver = true
        let winnerName = loser == .white ? opponentDisplayName() : "White"
        resultText = "\(winnerName) wins on time"
    }

    private func opponentDisplayName() -> String {
        if case .localTwoPlayer(let name, _) = mode { return name }
        return "CPU"
    }
}
