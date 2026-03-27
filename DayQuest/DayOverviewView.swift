import SwiftUI

struct DayOverviewView: View {
    @ObservedObject var gameState: GameState

    private var ps: PersistentStats { gameState.persistent }

    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.08, blue: 0.12)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Title + Level
                VStack(spacing: 6) {
                    Text("⚔️")
                        .font(.system(size: 44))
                    Text("DayQuest")
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)

                    // Level & streak bar
                    HStack(spacing: 16) {
                        Label("Lv. \(ps.level)", systemImage: "star.fill")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(red: 1, green: 0.93, blue: 0.15))

                        if ps.currentStreak > 0 {
                            Label("\(ps.currentStreak) day streak", systemImage: "flame.fill")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(red: 1, green: 0.47, blue: 0.20))
                        }

                        Text("\(ps.totalXP) XP")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.gray)
                    }

                    // XP progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(red: 0.2, green: 0.2, blue: 0.28))
                                .frame(height: 6)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(red: 1, green: 0.93, blue: 0.15))
                                .frame(width: geo.size.width * ps.levelProgress, height: 6)
                        }
                    }
                    .frame(height: 6)
                    .padding(.horizontal, 60)
                }
                .padding(.top, 30)

                // Character customization
                HStack(spacing: 20) {
                    VStack(spacing: 6) {
                        Text("Hat")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.gray)
                        HStack(spacing: 6) {
                            ForEach(SpriteFactory.customizableColors, id: \.index) { color in
                                Circle()
                                    .fill(Color(SpriteFactory.palette[color.index]))
                                    .frame(width: 22, height: 22)
                                    .overlay(
                                        Circle()
                                            .stroke(ps.hatColorIndex == color.index ? Color.white : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture { ps.hatColorIndex = color.index }
                            }
                        }
                    }
                    VStack(spacing: 6) {
                        Text("Shirt")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.gray)
                        HStack(spacing: 6) {
                            ForEach(SpriteFactory.customizableColors, id: \.index) { color in
                                Circle()
                                    .fill(Color(SpriteFactory.palette[color.index]))
                                    .frame(width: 22, height: 22)
                                    .overlay(
                                        Circle()
                                            .stroke(ps.shirtColorIndex == color.index ? Color.white : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture { ps.shirtColorIndex = color.index }
                            }
                        }
                    }
                }
                .padding(.horizontal)

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
                .padding(.bottom, 16)
            }
        }
    }
}
