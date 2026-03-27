import Foundation
import UIKit

enum EventType: String, CaseIterable {
    case meeting
    case call
    case lunch
    case focus
    case exercise
    case coffee
    case errand

    var emoji: String {
        switch self {
        case .meeting:  return "⚔️"
        case .call:     return "🐦"
        case .lunch:    return "🍖"
        case .focus:    return "📜"
        case .exercise: return "💪"
        case .coffee:   return "🧪"
        case .errand:   return "🗺️"
        }
    }

    var questName: String {
        switch self {
        case .meeting:  return "Council Meeting"
        case .call:     return "Carrier Pigeon"
        case .lunch:    return "Tavern Feast"
        case .focus:    return "Scholar's Study"
        case .exercise: return "Training Grounds"
        case .coffee:   return "Alchemist's Brew"
        case .errand:   return "Village Errand"
        }
    }

    var roofColorIndex: Int {
        switch self {
        case .meeting:  return 8   // red
        case .call:     return 12  // blue
        case .lunch:    return 10  // yellow
        case .focus:    return 13  // indigo
        case .exercise: return 11  // green
        case .coffee:   return 4   // brown
        case .errand:   return 9   // orange
        }
    }

    var arrivalDialogue: (title: String, description: String) {
        switch self {
        case .meeting:
            return ("The Grand Council assembles!", "Heroes gather to deliberate matters of great importance.")
        case .call:
            return ("A carrier pigeon arrives!", "An important message must be received.")
        case .lunch:
            return ("The tavern beckons!", "Mysterious aromas waft from within.")
        case .focus:
            return ("The ancient library awaits!", "Knowledge and wisdom lie within these walls.")
        case .exercise:
            return ("The training grounds are ready!", "Time to hone your skills, brave hero!")
        case .coffee:
            return ("The Alchemist's shop glows!", "A potion of awakening awaits.")
        case .errand:
            return ("A quest marker appears!", "Adventure awaits in the village.")
        }
    }

    func arrivalTitle(with attendees: [String]) -> String {
        guard !attendees.isEmpty else { return arrivalDialogue.title }
        let names = attendees.joined(separator: " & ")
        switch self {
        case .meeting: return "Council of \(names) assembles!"
        case .call:    return "A message from \(names) arrives!"
        case .lunch:   return "Feast with \(names) awaits!"
        default:       return arrivalDialogue.title
        }
    }

    var responses: [(text: String, outcome: String, stat: String, value: Int)] {
        switch self {
        case .meeting:
            return [
                ("For glory!", "The council reaches great wisdom!", "Teamwork", 10),
                ("Let us deliberate!", "A legendary plan is forged!", "Strategy", 8),
            ]
        case .call:
            return [
                ("Accept the call!", "The message is received!", "Connection", 5),
                ("Send a reply!", "Words of wisdom dispatched!", "Charisma", 7),
            ]
        case .lunch:
            return [
                ("Feast heartily!", "HP fully restored!", "Energy", 15),
                ("Sample the specials!", "A rare dish discovered!", "Discovery", 12),
            ]
        case .focus:
            return [
                ("Study the tomes!", "Ancient knowledge gained!", "Wisdom", 10),
                ("Practice the craft!", "Skills sharpened!", "Focus", 12),
            ]
        case .exercise:
            return [
                ("Train hard!", "Muscles grow stronger!", "Strength", 10),
                ("Master the form!", "Technique perfected!", "Agility", 8),
            ]
        case .coffee:
            return [
                ("One potion, please!", "Alertness surges!", "Energy", 10),
                ("Make it a double!", "MAXIMUM ENERGY!", "Energy", 20),
            ]
        case .errand:
            return [
                ("On my way!", "Errand completed with style!", "Reputation", 5),
                ("Adventure time!", "A side quest unfolds!", "Experience", 8),
            ]
        }
    }
}

struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let startTime: Date
    let duration: TimeInterval
    let type: EventType
    let attendees: [String]

    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }
}
