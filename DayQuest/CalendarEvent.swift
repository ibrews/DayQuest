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
    case presentation
    case doctor
    case happyHour

    var emoji: String {
        switch self {
        case .meeting:      return "⚔️"
        case .call:         return "🐦"
        case .lunch:        return "🍖"
        case .focus:        return "📜"
        case .exercise:     return "💪"
        case .coffee:       return "🧪"
        case .errand:       return "🗺️"
        case .presentation: return "🎭"
        case .doctor:       return "🏥"
        case .happyHour:    return "🍺"
        }
    }

    var roofColorIndex: Int {
        switch self {
        case .meeting:      return 8   // red
        case .call:         return 12  // blue
        case .lunch:        return 10  // yellow
        case .focus:        return 13  // indigo
        case .exercise:     return 11  // green
        case .coffee:       return 4   // brown
        case .errand:       return 9   // orange
        case .presentation: return 2   // dark purple
        case .doctor:       return 7   // white
        case .happyHour:    return 9   // orange
        }
    }

    // Returns a random dialogue pair for variety
    func randomDialogue() -> (title: String, detail: String) {
        let options: [(String, String)]
        switch self {
        case .meeting:
            options = [
                ("The Grand Council assembles!", "Heroes gather to deliberate matters of great importance."),
                ("A war council is called!", "The fate of the realm hangs in the balance."),
                ("The round table awaits!", "All voices must be heard in this chamber."),
            ]
        case .call:
            options = [
                ("A carrier pigeon arrives!", "An important message must be received."),
                ("The crystal ball glows!", "Someone seeks an audience from afar."),
                ("A raven lands on your windowsill!", "Dark wings bring urgent words."),
            ]
        case .lunch:
            options = [
                ("The tavern beckons!", "Mysterious aromas waft from within."),
                ("A feast is prepared!", "The kitchen has outdone itself today."),
                ("The innkeeper waves you over!", "Today's special looks legendary."),
            ]
        case .focus:
            options = [
                ("The ancient library awaits!", "Knowledge and wisdom lie within these walls."),
                ("The enchanted study calls!", "Scrolls of power demand your attention."),
                ("The wizard's workshop hums!", "Arcane matters require deep concentration."),
            ]
        case .exercise:
            options = [
                ("The training grounds are ready!", "Time to hone your skills, brave hero!"),
                ("The arena master summons you!", "Your body is your greatest weapon."),
                ("The obstacle course awaits!", "Legends are forged through sweat and steel."),
            ]
        case .coffee:
            options = [
                ("The Alchemist's shop glows!", "A potion of awakening awaits."),
                ("The brew master beckons!", "Ancient beans from distant lands..."),
                ("The cauldron bubbles warmly!", "A magical elixir is almost ready."),
            ]
        case .errand:
            options = [
                ("A quest marker appears!", "Adventure awaits in the village."),
                ("The village elder needs help!", "A task of utmost importance beckons."),
                ("A side quest unfolds!", "Every hero must tend to their affairs."),
            ]
        case .presentation:
            options = [
                ("The grand stage awaits!", "Your audience hungers for wisdom."),
                ("The amphitheater fills!", "All eyes will be upon you, hero."),
                ("The bard's platform is set!", "Time to captivate the masses!"),
            ]
        case .doctor:
            options = [
                ("The healer's tent glows!", "Time for a wellness check, adventurer."),
                ("The apothecary awaits!", "Even heroes need healing sometimes."),
                ("The medic summons you!", "A routine inspection of your vitality."),
            ]
        case .happyHour:
            options = [
                ("The mead hall roars!", "Celebration echoes through the village!"),
                ("The tavern glows golden!", "Companions gather for revelry!"),
                ("The victory feast begins!", "Tonight, we celebrate our conquests!"),
            ]
        }
        return options.randomElement()!
    }

    func arrivalTitle(with attendees: [String]) -> String {
        guard !attendees.isEmpty else { return randomDialogue().title }
        let names = attendees.joined(separator: " & ")
        switch self {
        case .meeting:      return "Council of \(names) assembles!"
        case .call:         return "A message from \(names) arrives!"
        case .lunch:        return "Feast with \(names) awaits!"
        case .happyHour:    return "\(names) raise their glasses!"
        case .presentation: return "\(names) take their seats!"
        default:            return randomDialogue().title
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
        case .presentation:
            return [
                ("Command the stage!", "The crowd erupts in applause!", "Charisma", 15),
                ("Speak from the heart!", "A standing ovation!", "Confidence", 12),
            ]
        case .doctor:
            return [
                ("Check my vitals!", "Clean bill of health!", "Vitality", 8),
                ("Full examination!", "All systems optimal!", "Resilience", 10),
            ]
        case .happyHour:
            return [
                ("Cheers to all!", "Bonds of friendship deepen!", "Morale", 12),
                ("Tell a great tale!", "You become the life of the party!", "Charisma", 15),
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
