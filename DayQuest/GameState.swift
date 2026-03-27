import SwiftUI

class GameState: ObservableObject {
    enum Screen {
        case overview
        case playing
        case complete
    }

    @Published var screen: Screen = .overview
    @Published var events: [CalendarEvent] = []
    @Published var stats: [String: Int] = [:]
    @Published var eventsCompleted: Int = 0

    let persistent = PersistentStats()

    init() {
        generateNewDay()
    }

    func generateNewDay() {
        events = FakeCalendarGenerator.generateDay()
        stats = [:]
        eventsCompleted = 0
        screen = .overview
    }

    func addStat(_ name: String, value: Int) {
        stats[name, default: 0] += value
        eventsCompleted += 1
    }

    func completeQuest() {
        persistent.recordQuestCompletion(stats: stats)
        persistent.incrementStreak()
        screen = .complete
    }

    func startQuest() {
        screen = .playing
    }
}
