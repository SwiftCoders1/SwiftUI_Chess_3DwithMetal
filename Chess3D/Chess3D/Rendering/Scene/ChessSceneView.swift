//
//  ChessSceneView.swift
//  Chess3D
//
//  Created by Prajjwal on 05/08/26.
//
import SwiftUI
import RealityKit

struct ChessSceneView: View {
    let mode: GameMode
    var onMainMenu: () -> Void = {}
    @State private var showHistory = false
    @StateObject private var viewModel: GameViewModel
    @State private var rootEntity = Entity()
    init(mode: GameMode, onMainMenu: @escaping () -> Void = {}) {
        self.mode = mode
        self.onMainMenu = onMainMenu
        _viewModel = StateObject(wrappedValue: GameViewModel(mode: mode))
    }
    var body: some View {
        RealityView { content in
            
            let anchor = AnchorEntity(world: .zero)
            anchor.addChild(rootEntity)
            content.add(anchor)

            // Camera
            let cameraEntity = Entity()
            cameraEntity.components.set(PerspectiveCameraComponent())
            cameraEntity.transform = CameraController.defaultTransform()
            rootEntity.addChild(cameraEntity)

            rootEntity.addChild(LightingRig.build())
            rootEntity.addChild(EnvironmentBuilder.build())
            rootEntity.addChild(EnvironmentBuilder.buildSkybox())
            EnvironmentBuilder.applyImageBasedLighting(to: rootEntity)
            let board = BoardBuilder.build()
            rootEntity.addChild(board)

            var squareLookup: [String: Entity] = [:]
            for square in board.children {
                if square.name.hasPrefix("square_") {
                    let key = String(square.name.dropFirst("square_".count))
                    squareLookup[key] = square
                }
            }
            let pieces = PieceFactory.startingPosition()
            var pieceLookup: [String: Entity] = [:]
            for piece in pieces {
                rootEntity.addChild(piece)
                if let square = piece.name.split(separator: "_").last {
                    pieceLookup[String(square)] = piece
                }
            }
            viewModel.attach(sceneRoot: rootEntity, pieceEntities: pieceLookup, squareEntities: squareLookup)
        }
        .ignoresSafeArea()
        .realityViewCameraControls(.orbit)
        .simultaneousGesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded{ value in
                    handleTap(on: value.entity)
                }
        )
      
        .overlay {
            CapturedPieceTrayView(capturedByWhite: viewModel.capturedByWhite, capturedByBlack: viewModel.capturedByBlack)
        }

        .overlay(alignment: .topLeading) {
            if !viewModel.isGameOver {
                MoveLogView(entries: Array(viewModel.moveLog.reversed().prefix(8))) {
                    showHistory = true
                }
                .padding()
            }
        }
        .overlay(alignment: .topTrailing) {
            if !viewModel.isGameOver {
                VStack(alignment: .trailing, spacing: 6) {
                    if viewModel.engine.isCheck {
                        Text("Check!")
                            .font(.caption.bold())
                            .foregroundStyle(.red)
                    }
                    Button(action: { viewModel.resign() }) {
                        Image(systemName: "flag.fill")
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.black.opacity(0.35), in: Circle())
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showHistory) {
            NavigationStack {
                MoveHistoryView(entries: viewModel.moveLog)
            }
        }
        .overlay {
            if viewModel.isGameOver {
                GameEndOverlay(
                    resultText: viewModel.resultText,
                    onRematch: { viewModel.rematch() },
                    onMainMenu: { onMainMenu() }   // was dismiss()
                )
            }
        }
        .overlay(alignment: .top) {
            if !viewModel.isGameOver {
                Text(statusText)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.35), in: Capsule())
                    .padding(.top, 8)
            }
        }
        .overlay(alignment: .bottom) {
            if viewModel.isClockEnabled && !viewModel.isGameOver {
                ChessClockView(whiteTime: viewModel.whiteTimeRemaining,
                                blackTime: viewModel.blackTimeRemaining,
                                activeColor: viewModel.engine.board.sideToMove)
                    .padding(.top, 24)
            }
        }
    }
    
    
    
    private var statusText: String {
        if viewModel.engine.isCheck {
            return "\(viewModel.engine.board.sideToMove == .white ? "White" : "Black") to move — Check!"
        }
        return "\(viewModel.engine.board.sideToMove == .white ? "White" : "Black") to move"
    }
    private func handleTap(on entity: Entity) {
        // Composite pieces (like the knight) have unnamed sub-parts — walk up to the
        // nearest ancestor that actually has a name (the piece/square root).
        var target: Entity? = entity
        while let current = target, current.name.isEmpty {
            target = current.parent
        }
        guard let resolved = target else { return }

        let name = resolved.name
        let squareString: String
        if name.hasPrefix("square_") {
            squareString = String(name.dropFirst("square_".count))
        } else {
            squareString = String(name.split(separator: "_").last ?? "")
        }
        guard !squareString.isEmpty else { return }
        viewModel.handleTap(on: Square.from(algebraic: squareString))
    }
}
