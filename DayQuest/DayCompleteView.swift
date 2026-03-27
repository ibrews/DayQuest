import SwiftUI

struct DayCompleteView: View {
    @ObservedObject var gameState: GameState

    private var sortedStats: [(key: String, value: Int)] {
        gameState.stats.sorted { $0.key < $1.key }
    }

    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.08, blue: 0.12)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("🏆")
                    .font(.system(size: 64))

                Text("Quest Complete!")
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(red: 1, green: 0.93, blue: 0.15))

                Text("You conquered \(gameState.eventsCompleted) adventures today!")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                // Stats
                VStack(spacing: 14) {
                    Text("Stats Gained")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)

                    ForEach(sortedStats, id: \.key) { stat in
                        HStack {
                            Text(stat.key)
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundColor(.white)
                            Spacer()
                            Text("+\(stat.value)")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(red: 0, green: 0.89, blue: 0.21))
                        }
                    }

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    HStack {
                        Text("Total XP")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                        Spacer()
                        Text("+\(gameState.stats.values.reduce(0, +))")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(red: 1, green: 0.93, blue: 0.15))
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.14, green: 0.14, blue: 0.20))
                )
                .padding(.horizontal, 40)

                Spacer()

                Button(action: { withAnimation { gameState.generateNewDay() } }) {
                    HStack {
                        Text("🌅")
                        Text("New Day")
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
                .padding(.bottom, 40)
            }
        }
    }
}
