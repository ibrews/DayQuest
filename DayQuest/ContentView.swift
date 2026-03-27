import SwiftUI

struct ContentView: View {
    @StateObject private var gameState = GameState()

    var body: some View {
        ZStack {
            switch gameState.screen {
            case .overview:
                DayOverviewView(gameState: gameState)
                    .transition(.opacity)
            case .playing:
                GameContainerView(gameState: gameState)
                    .transition(.opacity)
            case .complete:
                DayCompleteView(gameState: gameState)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: gameState.screen == .playing)
    }
}
