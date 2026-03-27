import Foundation

struct FakeCalendarGenerator {
    private static let meetingTitles = [
        "Team Standup", "Sprint Planning", "Design Review",
        "1:1 with Manager", "Project Kickoff", "Brainstorm Session",
        "All Hands", "Feature Review", "Retrospective",
    ]

    private static let callTitles = [
        "Call with Sarah", "Chat with Mike", "Sync with Jordan",
        "Check-in with Alex", "Client Call", "Vendor Sync",
    ]

    private static let focusTitles = [
        "Deep Work Block", "Code Review", "Write Documentation",
        "Research Time", "Bug Fixing", "Design Mockups",
    ]

    private static let names = [
        "Sarah", "Mike", "Jordan", "Alex", "Pat", "Chris",
        "Sam", "Jamie", "Taylor", "Morgan", "Casey", "Robin",
    ]

    static func generateDay() -> [CalendarEvent] {
        let calendar = Calendar.current
        let today = Date()

        var slots: [(type: EventType, hour: Int)] = []
        var currentHour = 8

        // Morning coffee (50% chance)
        if Bool.random() {
            slots.append((.coffee, currentHour))
            currentHour += 1
        }

        // Morning events
        for _ in 0..<Int.random(in: 1...2) {
            let type: EventType = [.meeting, .call, .focus].randomElement()!
            slots.append((type, currentHour))
            currentHour += 1
        }

        // Lunch
        slots.append((.lunch, 12))
        currentHour = 13

        // Afternoon events
        for _ in 0..<Int.random(in: 1...3) {
            let type: EventType = [.meeting, .call, .focus, .errand, .presentation].randomElement()!
            slots.append((type, currentHour))
            currentHour += 1
        }

        // Optional exercise or doctor
        if Bool.random() {
            let type: EventType = Bool.random() ? .exercise : .doctor
            slots.append((type, currentHour))
            currentHour += 1
        }

        // Optional happy hour
        if Bool.random() {
            slots.append((.happyHour, currentHour))
        }

        // Trim to 4-6 events
        let target = Int.random(in: 4...6)
        while slots.count > target {
            let idx = Int.random(in: 0..<slots.count)
            if slots[idx].type != .lunch { slots.remove(at: idx) }
        }

        slots.sort { $0.hour < $1.hour }

        return slots.map { slot in
            let startTime = calendar.date(
                bySettingHour: slot.hour,
                minute: [0, 15, 30].randomElement()!,
                second: 0, of: today
            )!

            let title: String
            var attendees: [String] = []
            let duration: TimeInterval

            switch slot.type {
            case .meeting:
                title = meetingTitles.randomElement()!
                duration = Double([30, 45, 60].randomElement()!)
                attendees = Array(names.shuffled().prefix(Int.random(in: 1...3)))
            case .call:
                title = callTitles.randomElement()!
                duration = Double([15, 30].randomElement()!)
                attendees = [names.randomElement()!]
            case .lunch:
                title = ["Lunch", "Lunch Break", "Team Lunch"].randomElement()!
                duration = 60
                if Bool.random() {
                    attendees = Array(names.shuffled().prefix(Int.random(in: 1...2)))
                }
            case .focus:
                title = focusTitles.randomElement()!
                duration = Double([60, 90].randomElement()!)
            case .exercise:
                title = ["Gym", "Workout", "Run", "Yoga"].randomElement()!
                duration = Double([30, 45, 60].randomElement()!)
            case .coffee:
                title = ["Morning Coffee", "Coffee Break", "Espresso Time"].randomElement()!
                duration = 15
            case .errand:
                title = ["Pick up package", "Pharmacy run", "Grocery stop", "Bank visit"].randomElement()!
                duration = 30
            case .presentation:
                title = ["Quarterly Review", "Demo Day", "Lightning Talk", "Team Presentation"].randomElement()!
                duration = Double([30, 45, 60].randomElement()!)
                attendees = Array(names.shuffled().prefix(Int.random(in: 2...4)))
            case .doctor:
                title = ["Doctor Appointment", "Annual Checkup", "Dentist Visit", "Eye Exam"].randomElement()!
                duration = Double([30, 60].randomElement()!)
            case .happyHour:
                title = ["Happy Hour", "Team Drinks", "Celebration", "Friday Social"].randomElement()!
                duration = Double([60, 90].randomElement()!)
                attendees = Array(names.shuffled().prefix(Int.random(in: 2...4)))
            }

            return CalendarEvent(
                title: title,
                startTime: startTime,
                duration: duration,
                type: slot.type,
                attendees: attendees
            )
        }
    }
}
