import Foundation

class PersistentStats: ObservableObject {
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let totalXP = "dq_totalXP"
        static let level = "dq_level"
        static let questsCompleted = "dq_questsCompleted"
        static let currentStreak = "dq_currentStreak"
        static let lastPlayedDate = "dq_lastPlayedDate"
        static let allTimeStats = "dq_allTimeStats"
        static let hatColor = "dq_hatColor"
        static let shirtColor = "dq_shirtColor"
    }

    @Published var totalXP: Int {
        didSet { defaults.set(totalXP, forKey: Keys.totalXP) }
    }
    @Published var level: Int {
        didSet { defaults.set(level, forKey: Keys.level) }
    }
    @Published var questsCompleted: Int {
        didSet { defaults.set(questsCompleted, forKey: Keys.questsCompleted) }
    }
    @Published var currentStreak: Int {
        didSet { defaults.set(currentStreak, forKey: Keys.currentStreak) }
    }
    @Published var lastPlayedDate: Date? {
        didSet { defaults.set(lastPlayedDate, forKey: Keys.lastPlayedDate) }
    }
    @Published var allTimeStats: [String: Int] {
        didSet { defaults.set(allTimeStats, forKey: Keys.allTimeStats) }
    }

    // Character customization
    @Published var hatColorIndex: Int {
        didSet { defaults.set(hatColorIndex, forKey: Keys.hatColor) }
    }
    @Published var shirtColorIndex: Int {
        didSet { defaults.set(shirtColorIndex, forKey: Keys.shirtColor) }
    }

    // XP needed per level (grows each level)
    static func xpForLevel(_ level: Int) -> Int {
        return 50 + (level - 1) * 30
    }

    var xpToNextLevel: Int {
        Self.xpForLevel(level)
    }

    var xpInCurrentLevel: Int {
        var remaining = totalXP
        for l in 1..<level {
            remaining -= Self.xpForLevel(l)
        }
        return remaining
    }

    var levelProgress: Double {
        Double(xpInCurrentLevel) / Double(xpToNextLevel)
    }

    init() {
        self.totalXP = defaults.integer(forKey: Keys.totalXP)
        self.level = max(1, defaults.integer(forKey: Keys.level))
        self.questsCompleted = defaults.integer(forKey: Keys.questsCompleted)
        self.currentStreak = defaults.integer(forKey: Keys.currentStreak)
        self.lastPlayedDate = defaults.object(forKey: Keys.lastPlayedDate) as? Date
        self.allTimeStats = (defaults.dictionary(forKey: Keys.allTimeStats) as? [String: Int]) ?? [:]
        self.hatColorIndex = defaults.object(forKey: Keys.hatColor) as? Int ?? 8  // red default
        self.shirtColorIndex = defaults.object(forKey: Keys.shirtColor) as? Int ?? 12 // blue default

        // Fix level if it was never set
        if level == 0 { level = 1 }

        updateStreak()
    }

    func recordQuestCompletion(stats: [String: Int]) {
        let sessionXP = stats.values.reduce(0, +)
        totalXP += sessionXP
        questsCompleted += 1
        lastPlayedDate = Date()

        // Merge stats
        for (key, value) in stats {
            allTimeStats[key, default: 0] += value
        }

        // Level up check
        while xpInCurrentLevel >= xpToNextLevel {
            level += 1
        }

        updateStreak()
    }

    private func updateStreak() {
        guard let lastPlayed = lastPlayedDate else {
            currentStreak = 0
            return
        }

        let calendar = Calendar.current
        if calendar.isDateInToday(lastPlayed) {
            // Already played today, streak is current
            return
        } else if calendar.isDateInYesterday(lastPlayed) {
            // Played yesterday, streak continues (will increment on next completion)
            return
        } else {
            // Missed a day, reset streak
            currentStreak = 0
        }
    }

    func incrementStreak() {
        guard let lastPlayed = lastPlayedDate else {
            currentStreak = 1
            return
        }
        let calendar = Calendar.current
        if !calendar.isDateInToday(lastPlayed) {
            currentStreak += 1
        }
    }
}
