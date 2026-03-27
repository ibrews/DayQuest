import SwiftUI

struct DayOverviewView: View {
    @ObservedObject var gameState: GameState

    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.08, blue: 0.12)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Title
                VStack(spacing: 8) {
                    Text("⚔️")
                        .font(.system(size: 48))
                    Text("DayQuest")
                        .font(.system(size: 34, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    Text("Today's Adventures Await")
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)

                // Event list
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(gameState.events) { event in
                            HStack(spacing: 12) {
                                Text(event.type.emoji)
                                    .font(.system(size: 24))
                                    .frame(width: 40)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(event.title)
                                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                        .foregroundColor(.white)

                                    HStack(spacing: 4) {
                                        Text(event.timeString)
                                            .font(.system(size: 12, design: .monospaced))
                                            .foregroundColor(Color(red: 1, green: 0.93, blue: 0.15))

                                        if !event.attendees.isEmpty {
                                            Text("· \(event.attendees.joined(separator: ", "))")
                                                .font(.system(size: 11, design: .monospaced))
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                        }
                                    }
                                }

                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 0.14, green: 0.14, blue: 0.20))
                            )
                        }
                    }
                    .padding(.horizontal)
                }

                // Start button
                Button(action: { withAnimation { gameState.startQuest() } }) {
                    HStack {
                        Text("⚔️")
                        Text("Begin Today's Quest")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 1, green: 0.93, blue: 0.15))
                    )
                }
                .padding(.horizontal, 24)

                // Shuffle
                Button(action: { gameState.generateNewDay() }) {
                    Text("🎲 Randomize Day")
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 20)
            }
        }
    }
}
