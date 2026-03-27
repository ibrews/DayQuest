import SwiftUI
import SpriteKit

struct GameContainerView: View {
    @ObservedObject var gameState: GameState

    var body: some View {
        SpriteKitView(
            events: gameState.events,
            hatColor: gameState.persistent.hatColorIndex,
            shirtColor: gameState.persistent.shirtColorIndex,
            onEventComplete: { stat, value in
                gameState.addStat(stat, value: value)
            },
            onQuestComplete: {
                DispatchQueue.main.async {
                    withAnimation { gameState.completeQuest() }
                }
            }
        )
        .ignoresSafeArea()
    }
}

struct SpriteKitView: UIViewRepresentable {
    let events: [CalendarEvent]
    let hatColor: Int
    let shirtColor: Int
    let onEventComplete: (String, Int) -> Void
    let onQuestComplete: () -> Void

    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.ignoresSiblingOrder = true
        let scene = DayQuestScene(
            events: events,
            hatColor: hatColor,
            shirtColor: shirtColor,
            onEventComplete: onEventComplete,
            onQuestComplete: onQuestComplete
        )
        view.presentScene(scene)
        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {}
}
