import SwiftUI

struct DayCompleteView: View {
    @ObservedObject var gameState: GameState

    private var ps: PersistentStats { gameState.persistent }

    private var sortedStats: [(key: String, value: Int)] {
        gameState.stats.sorted { $0.key < $1.key }
    }

    private var sessionXP: Int {
        gameState.stats.values.reduce(0, +)
    }

    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.08, blue: 0.12)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer().frame(height: 30)

                    Text("🏆")
                        .font(.system(size: 64))

                    Text("Quest Complete!")
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(red: 1, green: 0.93, blue: 0.15))

                    Text("You conquered \(gameState.eventsCompleted) adventures today!")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    // Session Stats
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

                        Divider().background(Color.gray.opacity(0.3))

                        HStack {
                            Text("Session XP")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                            Spacer()
                            Text("+\(sessionXP)")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(red: 1, green: 0.93, blue: 0.15))
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.14, green: 0.14, blue: 0.20))
                    )
                    .padding(.horizontal, 30)

                    // Hero Stats
                    VStack(spacing: 14) {
                        Text("Hero Profile")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)

                        HStack {
                            VStack(spacing: 4) {
                                Text("Lv. \(ps.level)")
                                    .font(.system(size: 22, weight: .bold, design: .monospaced))
                                    .foregroundColor(Color(red: 1, green: 0.93, blue: 0.15))
                                Text("Level")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)

                            VStack(spacing: 4) {
                                Text("\(ps.totalXP)")
                                    .font(.system(size: 22, weight: .bold, design: .monospaced))
                                    .foregroundColor(Color(red: 0.16, green: 0.68, blue: 1))
                                Text("Total XP")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)

                            VStack(spacing: 4) {
                                HStack(spacing: 2) {
                                    Text("\(ps.currentStreak)")
                                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                                        .foregroundColor(Color(red: 1, green: 0.47, blue: 0.20))
                                    if ps.currentStreak > 0 {
                                        Text("🔥")
                                            .font(.system(size: 16))
                                    }
                                }
                                Text("Streak")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                        }

                        // XP Progress to next level
                        VStack(spacing: 4) {
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(red: 0.2, green: 0.2, blue: 0.28))
                                        .frame(height: 8)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(red: 1, green: 0.93, blue: 0.15))
                                        .frame(width: geo.size.width * ps.levelProgress, height: 8)
                                }
                            }
                            .frame(height: 8)

                            Text("\(ps.xpInCurrentLevel) / \(ps.xpToNextLevel) XP to Level \(ps.level + 1)")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(.gray)
                        }

                        HStack {
                            Text("Quests Completed")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(ps.questsCompleted)")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.14, green: 0.14, blue: 0.20))
                    )
                    .padding(.horizontal, 30)

                    // New day button
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
}
