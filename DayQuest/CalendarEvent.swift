import Foundation

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

        // MARK: - Meeting (12 variants)
        case .meeting:
            options = [
                ("The Grand Council assembles!", "Heroes gather to deliberate matters of great importance."),
                ("A war council is called!", "The fate of the realm hangs in the balance."),
                ("The round table awaits!", "All voices must be heard in this chamber."),
                ("Someone sent the meeting scroll to the entire kingdom!", "Half the realm showed up. The other half is pretending they didn't see it."),
                ("A hooded figure enters the council chamber.", "'I have intelligence about the northern border...' Everyone leans in."),
                ("The village elders gather by the fire.", "Tonight they share stories and plan the spring harvest together."),
                ("Ah, another quest marker on the map.", "The developers really love scheduling these council scenes, don't they?"),
                ("War drums echo across the valley!", "Champions from seven provinces answer the summons. This is no ordinary gathering."),
                ("Your old mentor waves from the back of the hall.", "'Saved you a seat, kid. Try not to fall asleep this time.'"),
                ("The guild masters convene in the secret chamber.", "Three knocks, a password, and you're through the hidden door."),
                ("A rival faction requests a parley!", "They arrive under a white banner. Tensions are thick enough to cut with a blade."),
                ("The court jester interrupts the proceedings!", "'Before we begin, I have a VERY important joke.' Nobody laughs. He continues anyway."),
            ]

        // MARK: - Call (12 variants)
        case .call:
            options = [
                ("A carrier pigeon arrives!", "An important message must be received."),
                ("The crystal ball glows!", "Someone seeks an audience from afar."),
                ("A raven lands on your windowsill!", "Dark wings bring urgent words."),
                ("The enchanted mirror ripples to life!", "A familiar face appears in the silver surface, waving frantically."),
                ("A talking fox darts into your camp!", "'Message for you, guv!' It drops a glowing scroll and vanishes."),
                ("Your grandmother's voice echoes through the amulet.", "'Just checking in, dear. Have you been eating enough roast boar?'"),
                ("The loading screen appears... again.", "You'd think magical long-distance communication would have better latency by now."),
                ("A distress signal erupts from the watchtower!", "Red sparks paint the sky. Someone needs your counsel immediately."),
                ("An old rival's sigil appears in the scrying pool.", "Unexpected. Perhaps they've finally come to terms... or set a trap."),
                ("The bard's enchanted lute vibrates with an incoming tune.", "Someone is calling via the musical frequency. How theatrical."),
                ("A spectral messenger materializes in your quarters!", "'Don't panic. I'm from the future. Well, from across town. We need to talk.'"),
                ("The village children come running with a message stone.", "'It's glowing again! Somebody important wants you!' They're breathless with excitement."),
            ]

        // MARK: - Lunch (12 variants)
        case .lunch:
            options = [
                ("The tavern beckons!", "Mysterious aromas waft from within."),
                ("A feast is prepared!", "The kitchen has outdone itself today."),
                ("The innkeeper waves you over!", "Today's special looks legendary."),
                ("A food cart appears in the market square!", "The vendor is shouting about 'Dragon Pepper Stew' and you can smell it from here."),
                ("The halfling chef challenges you to a taste test!", "'Bet you can't tell what the secret ingredient is!' He's grinning ear to ear."),
                ("Your party sets up camp by the river.", "Someone catches a fish the size of a small dog. Lunch is looking promising."),
                ("New DLC just dropped: 'The Lunch Expansion Pack.'", "Adds 47 new food items and one very long eating animation."),
                ("A mysterious invitation slides under your door!", "'You are cordially invited to dine at the Crimson Table. Come alone. Bring an appetite.'"),
                ("Your traveling companion unpacks a suspiciously large picnic.", "'I may have raided the palace pantry. Don't ask questions, just eat.'"),
                ("The monastery bell rings for the midday meal!", "The monks make the best bread in the realm. It's the silence that lets the dough rise properly."),
                ("A merchant offers you an exotic dish from the eastern lands.", "'They call it a burrito where I come from. Trust me, your life is about to change.'"),
                ("The campfire crackles as someone produces a cast-iron skillet.", "In the wilderness, even a simple meal feels like a king's banquet."),
            ]

        // MARK: - Focus (12 variants)
        case .focus:
            options = [
                ("The ancient library awaits!", "Knowledge and wisdom lie within these walls."),
                ("The enchanted study calls!", "Scrolls of power demand your attention."),
                ("The wizard's workshop hums!", "Arcane matters require deep concentration."),
                ("You find a quiet alcove in the castle tower.", "The world below fades. Up here, there is only the work and the wind."),
                ("The dwarven forge of the mind ignites!", "Time to hammer raw ideas into something sharp and true."),
                ("Your cat sits on your spellbook. Again.", "You gently move the familiar aside. The arcane diagrams won't decode themselves."),
                ("A 'Do Not Disturb' rune activates on your door.", "Whoever enchanted this thing, bless them. Two uninterrupted hours of pure craft."),
                ("The Forbidden Archives creak open for you alone.", "These texts haven't been read in a century. The dust alone could tell stories."),
                ("A mysterious patron left you a locked puzzle box.", "Inside: the key to your next breakthrough. But first, you must solve it."),
                ("The monastery of silence accepts you for the afternoon.", "No words. No distractions. Just the scratch of quill on parchment."),
                ("Your rival published their research first!", "Time to go deeper, think harder, and produce something truly extraordinary."),
                ("Rain hammers the roof as you settle into your desk.", "Perfect weather for deep work. The storm outside mirrors the creative storm within."),
            ]

        // MARK: - Exercise (10 variants)
        case .exercise:
            options = [
                ("The training grounds are ready!", "Time to hone your skills, brave hero!"),
                ("The arena master summons you!", "Your body is your greatest weapon."),
                ("The obstacle course awaits!", "Legends are forged through sweat and steel."),
                ("A wandering monk offers to spar!", "'I've trained in seventeen styles. Show me what you've got, friend.'"),
                ("The mountain path calls to you at dawn.", "Cold air, burning lungs, and the summit waiting like a crown."),
                ("Your old drill sergeant appears out of nowhere!", "'THOUGHT YOU COULD SKIP TODAY, DID YA?!' Some things never change."),
                ("The game really wants you to level up your Strength stat.", "Fine. Let's grind some physical XP. At least there's no cooldown timer."),
                ("A dragon was spotted near the village!", "Time to train. You'll need every ounce of power when it returns."),
                ("The festival games are tomorrow!", "Wrestling, archery, the log toss... you're entering them all. Better warm up."),
                ("The enchanted training dummy taunts you!", "'That all you got? My grandmother hits harder!' It's definitely cheating somehow."),
            ]

        // MARK: - Coffee (12 variants)
        case .coffee:
            options = [
                ("The Alchemist's shop glows!", "A potion of awakening awaits."),
                ("The brew master beckons!", "Ancient beans from distant lands..."),
                ("The cauldron bubbles warmly!", "A magical elixir is almost ready."),
                ("The wandering potion merchant unrolls her cart!", "'Fresh batch of liquid motivation! Brewed under a full moon!'"),
                ("The dwarves discovered a new vein of espresso ore!", "They're mining it twenty-four hours a day. The entire mountain vibrates."),
                ("Your familiar nudges the empty mug toward you.", "Even your magical pet knows you're useless before the first cup."),
                ("Potion of Awakening: 5 gold. Knowing you need it: priceless.", "The shopkeeper doesn't even ask anymore. They just start pouring."),
                ("A traveling sage shares a secret brewing technique!", "'Heat the water to exactly 200 degrees, add a phoenix feather...' This changes everything."),
                ("The guild hall's communal brew pot is freshly filled!", "First one there gets the good stuff. Second gets the sludge at the bottom."),
                ("An ancient recipe falls from between the pages of a book.", "'The Elixir of Eternal Alertness.' Ingredients: beans, hot water, hope."),
                ("The forest witch brews something that smells incredible.", "'It'll wake the dead,' she cackles. 'Figuratively. Probably. Drink up.'"),
                ("Rain patters on the roof of the cozy apothecary.", "The perfect morning. Warm mug, crackling fire, and nowhere to be for ten whole minutes."),
            ]

        // MARK: - Errand (10 variants)
        case .errand:
            options = [
                ("A quest marker appears!", "Adventure awaits in the village."),
                ("The village elder needs help!", "A task of utmost importance beckons."),
                ("A side quest unfolds!", "Every hero must tend to their affairs."),
                ("The blacksmith needs materials from the market!", "'Can't forge swords without iron, and I can't leave the furnace. You're up, hero.'"),
                ("Your to-do scroll has grown sentient and is judging you.", "'Three days you've been ignoring me. THREE DAYS.' Fine. Let's go."),
                ("Loading side quest: 'The Mundane Made Grand.'", "Objective: acquire bread, return library books, deliver package. Reward: self-respect."),
                ("A child tugs at your cloak.", "'Please, brave adventurer, my mother sent me to find someone who can... pick up groceries?'"),
                ("The kingdom's postal service is on strike!", "Someone has to deliver these parcels. Looks like that someone is you."),
                ("Your horse gives you a knowing look at the stable door.", "'Errands again?' the look says. You saddle up anyway. The realm won't run itself."),
                ("A notice board overflows with small tasks!", "Help wanted: fence repair, herb gathering, lost cat retrieval. Every quest starts somewhere."),
            ]

        // MARK: - Presentation (10 variants)
        case .presentation:
            options = [
                ("The grand stage awaits!", "Your audience hungers for wisdom."),
                ("The amphitheater fills!", "All eyes will be upon you, hero."),
                ("The bard's platform is set!", "Time to captivate the masses!"),
                ("The royal court demands a performance!", "The king himself leans forward on his throne. Don't mess this up."),
                ("A hush falls over the crowded marketplace.", "Word spread that you have something important to say. The whole town showed up."),
                ("You peek behind the curtain at the packed arena.", "'Why did I agree to this?' Because legends are made on that stage. Now go."),
                ("Cutscene initiated: 'The Big Speech.'", "Hope you prepared. The dialogue options are locked. It's all improv from here."),
                ("Your mentor places a hand on your shoulder backstage.", "'Remember: they're more afraid of you than you are of them.' That... doesn't help."),
                ("The ancient coliseum echoes with anticipation!", "Gladiators fought here. Poets performed here. Today, it's your turn to be remembered."),
                ("Enchanted projection crystals float into position.", "The magical equivalent of a slide deck. At least these ones can't have font issues."),
            ]

        // MARK: - Doctor (10 variants)
        case .doctor:
            options = [
                ("The healer's tent glows!", "Time for a wellness check, adventurer."),
                ("The apothecary awaits!", "Even heroes need healing sometimes."),
                ("The medic summons you!", "A routine inspection of your vitality."),
                ("The temple healer greets you with a warm smile.", "'Let's make sure all your hit points are accounted for, shall we?'"),
                ("A field medic flags you down between quests.", "'When was your last restoration spell? That long? We need to talk.'"),
                ("Your party's cleric gives you The Look.", "'You've been ignoring that debuff for weeks. Healer's tent. Now. No arguments.'"),
                ("Health check DLC: 'Operation: Self-Care.'", "Mandatory content. No skipping. The developers care about your wellbeing."),
                ("The village wise woman reads your aura.", "'Hmm. A bit dim on the left side. Nothing serious, but let's run some tests.'"),
                ("A traveling physician sets up shop in the market.", "'Free checkups for adventurers! You'd be surprised how many heroes skip these.'"),
                ("The healing spring in the forest glen beckons.", "Its waters reveal the truth about your body's condition. Time for honest answers."),
            ]

        // MARK: - Happy Hour (10 variants)
        case .happyHour:
            options = [
                ("The mead hall roars!", "Celebration echoes through the village!"),
                ("The tavern glows golden!", "Companions gather for revelry!"),
                ("The victory feast begins!", "Tonight, we celebrate our conquests!"),
                ("A bard strikes up a lively tune in the corner!", "Feet start tapping. Mugs start clinking. The evening has officially begun."),
                ("The innkeeper rolls out a barrel marked 'THE GOOD STUFF.'", "'On the house tonight, heroes! You've earned it!' The crowd erupts."),
                ("Your quiet drink turns into an unexpected reunion!", "Old friends you haven't seen in ages walk through the tavern door one by one."),
                ("Achievement Unlocked: 'You Survived Another Week.'", "Reward: one cold beverage and the company of people who get it."),
                ("A friendly rivalry breaks out at the dart board!", "The stakes? Bragging rights and the last slice of pie. Things are getting serious."),
                ("Fireflies fill the garden as the outdoor tables fill with laughter.", "Someone strung up lanterns. Someone else brought a lute. Magic doesn't require spells."),
                ("The dwarf challenges everyone to a drinking contest!", "'Last one standing wins my golden tankard!' Three people have already accepted."),
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
        let allOptions: [[(text: String, outcome: String, stat: String, value: Int)]]

        switch self {

        // MARK: - Meeting Responses (12 pairs)
        case .meeting:
            allOptions = [
                [
                    ("For glory!", "The council reaches great wisdom!", "Teamwork", 10),
                    ("Let us deliberate!", "A legendary plan is forged!", "Strategy", 8),
                ],
                [
                    ("Rally the champions!", "Every voice strengthens the cause!", "Leadership", 12),
                    ("Listen before speaking.", "Patience reveals the hidden truth.", "Wisdom", 9),
                ],
                [
                    ("Propose a bold strategy!", "The council is electrified by your vision!", "Courage", 11),
                    ("Build on their ideas.", "Collaboration multiplies the brilliance.", "Teamwork", 10),
                ],
                [
                    ("Crack a joke to break the ice.", "Laughter clears the tension. Ideas flow freely.", "Charisma", 7),
                    ("Get straight to business.", "Efficiency impresses the council elders.", "Focus", 9),
                ],
                [
                    ("Challenge the old ways!", "A heated but productive debate erupts!", "Courage", 13),
                    ("Honor the traditions.", "The elders nod with deep respect.", "Wisdom", 8),
                ],
                [
                    ("Volunteer to lead the initiative.", "The weight of command settles on your shoulders.", "Leadership", 14),
                    ("Support from the sidelines.", "Your quiet strength holds the team together.", "Resilience", 7),
                ],
                [
                    ("Draw a battle map!", "The strategy crystallizes before everyone's eyes!", "Strategy", 11),
                    ("Tell a rallying story.", "Morale surges through the chamber.", "Charisma", 10),
                ],
                [
                    ("Mediate the disagreement.", "Peace is restored. Both sides feel heard.", "Serenity", 9),
                    ("Pick a side and argue!", "Your passion sways the undecided votes.", "Courage", 12),
                ],
                [
                    ("Take meticulous notes.", "Nothing escapes your record. Future you will be grateful.", "Focus", 8),
                    ("Sketch ideas on the board.", "Visual thinking unlocks a breakthrough!", "Creativity", 11),
                ],
                [
                    ("Ask the hard question.", "Uncomfortable silence... then a breakthrough.", "Wisdom", 13),
                    ("Keep the energy positive.", "The meeting ends with everyone smiling.", "Connection", 8),
                ],
                [
                    ("Forge an alliance with the rival faction!", "Enemies become reluctant allies. History is made.", "Strategy", 15),
                    ("Stand firm on your principles.", "Your integrity earns quiet admiration.", "Resilience", 10),
                ],
                [
                    ("Wrap it up efficiently.", "Record time! The council is free before sunset.", "Focus", 9),
                    ("Open the floor for one more voice.", "A shy advisor shares the idea that changes everything.", "Connection", 12),
                ],
            ]

        // MARK: - Call Responses (12 pairs)
        case .call:
            allOptions = [
                [
                    ("Accept the call!", "The message is received!", "Connection", 5),
                    ("Send a reply!", "Words of wisdom dispatched!", "Charisma", 7),
                ],
                [
                    ("Listen carefully.", "Hidden meaning reveals itself in the pauses.", "Wisdom", 9),
                    ("Speak from the heart.", "Your sincerity resonates across the distance.", "Connection", 10),
                ],
                [
                    ("Ask the tough questions.", "Clarity emerges from honest conversation.", "Courage", 8),
                    ("Offer encouragement.", "Your words lift their spirits across the miles.", "Charisma", 7),
                ],
                [
                    ("Share the news eagerly!", "Excitement is contagious, even through a crystal ball.", "Energy", 6),
                    ("Choose your words carefully.", "Precision carries weight. The message lands perfectly.", "Wisdom", 11),
                ],
                [
                    ("Laugh together about old times.", "The bond strengthens with shared memories.", "Connection", 12),
                    ("Focus on the task at hand.", "Business handled with professional grace.", "Focus", 8),
                ],
                [
                    ("Propose a collaboration!", "Two minds spark an idea neither could alone.", "Creativity", 10),
                    ("Request their counsel.", "Their perspective illuminates your blind spot.", "Wisdom", 9),
                ],
                [
                    ("Keep it brief and sharp.", "Respect for their time earns you respect in return.", "Strategy", 6),
                    ("Settle in for a long chat.", "Deep conversation forges an unbreakable bond.", "Connection", 13),
                ],
                [
                    ("Deliver the bad news gently.", "Honesty wrapped in kindness. They appreciate it.", "Serenity", 8),
                    ("Lead with the silver lining.", "Optimism is a choice, and you choose brilliantly.", "Charisma", 9),
                ],
                [
                    ("Take detailed notes during the call.", "Every key point captured. Nothing falls through.", "Focus", 10),
                    ("Just be present and listen.", "Sometimes silence is the greatest gift.", "Serenity", 7),
                ],
                [
                    ("Crack a joke to lighten the mood.", "Laughter echoes through the enchanted link.", "Wit", 8),
                    ("Stay serious and professional.", "Your composure inspires confidence.", "Leadership", 9),
                ],
                [
                    ("Pledge your support!", "An alliance forged through the crystal's glow.", "Teamwork", 11),
                    ("Remain diplomatically neutral.", "You keep your options open. Wise move.", "Strategy", 7),
                ],
                [
                    ("Follow up with a handwritten letter.", "The personal touch turns a call into a lasting memory.", "Connection", 14),
                    ("Send a summary scroll.", "Organized, efficient, and undeniably helpful.", "Focus", 8),
                ],
            ]

        // MARK: - Lunch Responses (12 pairs)
        case .lunch:
            allOptions = [
                [
                    ("Feast heartily!", "HP fully restored!", "Energy", 15),
                    ("Sample the specials!", "A rare dish discovered!", "Creativity", 12),
                ],
                [
                    ("Try something completely new!", "Your palate expands to new horizons!", "Courage", 8),
                    ("Stick with the classic stew.", "Comfort food heals the soul. Full restore.", "Serenity", 10),
                ],
                [
                    ("Share your meal with a stranger.", "A new friendship forms over broken bread.", "Connection", 11),
                    ("Savor every bite in peace.", "Mindful eating restores body and spirit.", "Serenity", 9),
                ],
                [
                    ("Challenge the chef to surprise you!", "A dish you never knew existed changes your life.", "Courage", 13),
                    ("Cook something yourself!", "The act of creation nourishes more than the body.", "Creativity", 10),
                ],
                [
                    ("Order the biggest thing on the menu.", "An absolute unit of a meal. You regret nothing.", "Vitality", 14),
                    ("Go for the light and balanced option.", "Energy without the food coma. Strategic eating.", "Focus", 7),
                ],
                [
                    ("Swap recipes with the innkeeper.", "Knowledge shared over a warm meal. Beautiful.", "Wisdom", 8),
                    ("Eat quickly and get back to questing!", "Efficient refueling. Time is treasure.", "Energy", 6),
                ],
                [
                    ("Host a table for your whole party!", "Laughter and full bellies. The team is recharged.", "Teamwork", 12),
                    ("Find a quiet corner booth.", "Solitude and a good meal. The introvert's paradise.", "Serenity", 9),
                ],
                [
                    ("Leave a generous tip for the staff.", "The innkeeper bows deeply. You're always welcome here.", "Charisma", 7),
                    ("Compliment the chef personally.", "They beam with pride. Your words made their day.", "Connection", 8),
                ],
                [
                    ("Try the suspicious-looking daily special.", "Against all odds... it's INCREDIBLE.", "Courage", 11),
                    ("Ask the locals what they recommend.", "Insider knowledge leads to the best meal of your life.", "Wisdom", 10),
                ],
                [
                    ("Enter the tavern's eating contest!", "Seven plates later, you're a legend. And very full.", "Endurance", 15),
                    ("Pace yourself and enjoy the ambiance.", "The meal is a journey, not a race.", "Serenity", 8),
                ],
                [
                    ("Bring back leftovers for the journey.", "Future you is very grateful for this decision.", "Strategy", 6),
                    ("Finish every last crumb!", "Not a morsel wasted. The plate gleams.", "Vitality", 10),
                ],
                [
                    ("Pair the meal with the perfect drink.", "The combination is transcendent. Chef's kiss.", "Creativity", 9),
                    ("Just water today. Stay sharp.", "Discipline is its own reward. Clear mind achieved.", "Focus", 7),
                ],
            ]

        // MARK: - Focus Responses (12 pairs)
        case .focus:
            allOptions = [
                [
                    ("Study the tomes!", "Ancient knowledge gained!", "Wisdom", 10),
                    ("Practice the craft!", "Skills sharpened!", "Focus", 12),
                ],
                [
                    ("Dive into the deep work.", "Hours vanish. A masterpiece emerges.", "Focus", 14),
                    ("Start with a clear outline.", "Structure transforms chaos into progress.", "Strategy", 9),
                ],
                [
                    ("Enter a flow state.", "Time dissolves. You and the work become one.", "Focus", 15),
                    ("Take strategic breaks.", "The Pomodoro technique of the ancients! It works.", "Wisdom", 8),
                ],
                [
                    ("Tackle the hardest part first.", "The dragon is slain. Everything else feels easy.", "Courage", 12),
                    ("Build momentum with quick wins.", "Small victories snowball into an avalanche of progress.", "Energy", 9),
                ],
                [
                    ("Research before you begin.", "Knowledge is the sharpest blade. You strike true.", "Wisdom", 11),
                    ("Learn by doing!", "Mistakes teach faster than any scroll.", "Resilience", 8),
                ],
                [
                    ("Silence all distractions.", "The enchanted 'Do Not Disturb' rune holds firm.", "Focus", 13),
                    ("Put on ambient dungeon sounds.", "Dripping water and distant echoes... strangely productive.", "Creativity", 7),
                ],
                [
                    ("Push through the mental block!", "Persistence shatters the wall. Ideas pour through.", "Endurance", 10),
                    ("Step back and rethink the approach.", "A new angle reveals what brute force could not.", "Creativity", 11),
                ],
                [
                    ("Write everything down.", "Ink on parchment makes ideas real and accountable.", "Focus", 8),
                    ("Sketch and brainstorm freely.", "Messy diagrams birth elegant solutions.", "Creativity", 12),
                ],
                [
                    ("Set an ambitious deadline.", "Pressure creates diamonds. You shine under it.", "Courage", 10),
                    ("Work at your own pace.", "Steady progress without burnout. The wise path.", "Serenity", 9),
                ],
                [
                    ("Ask for expert guidance.", "A mentor's single sentence saves you hours of wandering.", "Wisdom", 13),
                    ("Figure it out yourself.", "Self-reliance levels up! The knowledge is truly yours.", "Resilience", 10),
                ],
                [
                    ("Document as you go.", "Future adventurers will bless your thoroughness.", "Strategy", 8),
                    ("Just build, document later.", "Raw creation mode. The muse doesn't wait for footnotes.", "Energy", 7),
                ],
                [
                    ("Review and refine your work.", "Polish reveals the gem hidden in the rough.", "Wisdom", 9),
                    ("Ship it and iterate!", "Done is better than perfect. Version two awaits.", "Courage", 11),
                ],
            ]

        // MARK: - Exercise Responses (10 pairs)
        case .exercise:
            allOptions = [
                [
                    ("Train hard!", "Muscles grow stronger!", "Vitality", 10),
                    ("Master the form!", "Technique perfected!", "Focus", 8),
                ],
                [
                    ("Push past the limit!", "A new personal record! The crowd goes wild!", "Endurance", 14),
                    ("Train smart, not just hard.", "Efficiency in motion. Maximum gains, minimum waste.", "Wisdom", 9),
                ],
                [
                    ("Challenge a sparring partner!", "Iron sharpens iron. You both emerge stronger.", "Teamwork", 11),
                    ("Train solo in the moonlight.", "Alone with the night, you find your rhythm.", "Serenity", 8),
                ],
                [
                    ("Sprint the mountain trail!", "Lungs burn, legs ache, spirit SOARS.", "Energy", 13),
                    ("Stretch and center yourself.", "Flexibility prevents the injuries that end careers.", "Resilience", 7),
                ],
                [
                    ("Enter the tournament!", "Win or lose, the arena teaches what training cannot.", "Courage", 15),
                    ("Watch the masters and learn.", "Observation sharpens technique before practice begins.", "Wisdom", 8),
                ],
                [
                    ("Lift the impossible weight!", "What once pinned you down now rises overhead.", "Vitality", 12),
                    ("Focus on bodyweight mastery.", "Your own frame becomes the ultimate instrument.", "Focus", 10),
                ],
                [
                    ("Dance through the obstacle course!", "Grace and power in perfect harmony.", "Creativity", 9),
                    ("Methodically conquer each station.", "Systematic progress. No weakness left unaddressed.", "Strategy", 8),
                ],
                [
                    ("Train through the storm!", "Thunder and rain can't stop what's coming.", "Endurance", 13),
                    ("Rest and recover today.", "Growth happens in recovery. True wisdom.", "Serenity", 6),
                ],
                [
                    ("Teach a beginner the basics.", "Explaining deepens your own understanding.", "Connection", 7),
                    ("Seek out a master trainer.", "Humility opens the door to the next level.", "Wisdom", 11),
                ],
                [
                    ("Break the training dummy!", "Splinters fly! Raw power unleashed!", "Vitality", 15),
                    ("Practice until it feels effortless.", "Repetition transforms effort into instinct.", "Focus", 10),
                ],
            ]

        // MARK: - Coffee Responses (12 pairs)
        case .coffee:
            allOptions = [
                [
                    ("One potion, please!", "Alertness surges!", "Energy", 10),
                    ("Make it a double!", "MAXIMUM ENERGY!", "Energy", 15),
                ],
                [
                    ("Sip slowly and savor.", "Every drop is a revelation. Clarity dawns.", "Serenity", 8),
                    ("Chug it like an adventurer!", "INSTANT POWER-UP! The world snaps into focus.", "Energy", 12),
                ],
                [
                    ("Try the experimental blend!", "Flavors you didn't know existed dance on your tongue.", "Courage", 9),
                    ("Stick with the usual.", "Consistency is comforting. Reliable energy delivered.", "Resilience", 6),
                ],
                [
                    ("Share a pot with a colleague.", "Ideas flow as freely as the coffee.", "Connection", 10),
                    ("Guard your cup jealously.", "This is MY potion. Mine. Back off.", "Focus", 7),
                ],
                [
                    ("Ask the alchemist for something special.", "A custom brew, tailored to your spirit. Extraordinary.", "Charisma", 11),
                    ("Brew it yourself from scratch.", "The ritual of creation is half the magic.", "Creativity", 9),
                ],
                [
                    ("Add an extra shot of espresso essence!", "Your heartbeat sounds like a war drum. Let's GO.", "Energy", 14),
                    ("Go for the herbal alternative.", "Gentle awakening. Like sunrise in a cup.", "Serenity", 7),
                ],
                [
                    ("Pair it with a pastry.", "The combo unlocks a hidden buff: Pure Contentment.", "Vitality", 8),
                    ("Coffee only. Stay lean.", "Pure fuel. No distractions. Ready for battle.", "Focus", 9),
                ],
                [
                    ("Chat with the barista-alchemist.", "They know things. Secret menu things. You're in.", "Connection", 8),
                    ("Grab and go!", "Efficiency incarnate. Coffee acquired. Quest resumed.", "Energy", 6),
                ],
                [
                    ("Discover a rare single-origin bean!", "This batch came from a volcano. You can taste the adventure.", "Creativity", 10),
                    ("Reliable house blend, reliable results.", "No surprises. Just pure, dependable energy.", "Resilience", 7),
                ],
                [
                    ("Write in your journal while sipping.", "Caffeine and reflection produce unexpected insights.", "Wisdom", 11),
                    ("People-watch from the corner table.", "The village flows past. You notice things others miss.", "Wit", 8),
                ],
                [
                    ("Challenge someone to a coffee trivia duel!", "You win on the obscure question about bean roasting temperatures.", "Wit", 9),
                    ("Enjoy the quiet anonymity.", "Nobody knows you're a hero here. Just another coffee lover.", "Serenity", 6),
                ],
                [
                    ("Tip the barista generously!", "They slip you an extra shot next time. Investment pays off.", "Charisma", 7),
                    ("Perfectly measure out exact change.", "Mathematically precise. The coin purse respects you.", "Strategy", 5),
                ],
            ]

        // MARK: - Errand Responses (10 pairs)
        case .errand:
            allOptions = [
                [
                    ("On my way!", "Errand completed with style!", "Energy", 5),
                    ("Adventure time!", "A side quest unfolds!", "Courage", 8),
                ],
                [
                    ("Optimize the route!", "Every stop planned. Maximum efficiency achieved.", "Strategy", 10),
                    ("Wander and discover!", "A wrong turn leads to a hidden shop. Lucky find!", "Creativity", 9),
                ],
                [
                    ("Power through the list!", "Task after task falls. You're a machine.", "Endurance", 11),
                    ("Take your time and enjoy the walk.", "The errands are the journey, not just the destination.", "Serenity", 7),
                ],
                [
                    ("Delegate what you can!", "The apprentice handles three tasks while you do one. Smart.", "Leadership", 8),
                    ("Do it all yourself.", "If you want it done right... Pride in personal effort.", "Resilience", 6),
                ],
                [
                    ("Help a stranger along the way.", "The detour adds time but fills the heart.", "Connection", 10),
                    ("Stay focused on the mission.", "Laser precision. Every item checked off.", "Focus", 9),
                ],
                [
                    ("Race yourself against the clock!", "Record time! The village has never seen errands run so fast.", "Energy", 12),
                    ("Make each stop count.", "Quality over speed. Every interaction matters.", "Wisdom", 7),
                ],
                [
                    ("Discover a shortcut!", "A hidden alley saves twenty minutes. Legendary pathfinding.", "Strategy", 11),
                    ("Take the scenic route.", "Flowers, birdsong, and the satisfaction of a life well-walked.", "Serenity", 8),
                ],
                [
                    ("Turn the chore into a challenge!", "Gamifying reality. Each task is a quest completed.", "Creativity", 9),
                    ("Just get it done.", "No frills, no drama. Reliable. Dependable. Done.", "Resilience", 6),
                ],
                [
                    ("Chat with every shopkeeper.", "The village gossip network is better than any intelligence agency.", "Charisma", 7),
                    ("In and out, no small talk.", "Efficiency is your love language.", "Focus", 8),
                ],
                [
                    ("Bring someone along for company!", "Errands become bonding time. Two birds, one journey.", "Teamwork", 10),
                    ("Enjoy the solo expedition.", "Alone with your thoughts and the open road. Freedom.", "Serenity", 6),
                ],
            ]

        // MARK: - Presentation Responses (10 pairs)
        case .presentation:
            allOptions = [
                [
                    ("Command the stage!", "The crowd erupts in applause!", "Charisma", 15),
                    ("Speak from the heart!", "A standing ovation!", "Courage", 12),
                ],
                [
                    ("Open with a bold declaration!", "The audience is hooked from the first word.", "Courage", 14),
                    ("Begin with a question.", "Minds engage. The room leans forward as one.", "Wisdom", 10),
                ],
                [
                    ("Use dramatic pauses!", "Silence becomes your most powerful tool.", "Charisma", 11),
                    ("Maintain relentless energy!", "The audience rides the wave of your enthusiasm.", "Energy", 13),
                ],
                [
                    ("Make them laugh first!", "A room that laughs together listens together.", "Wit", 10),
                    ("Lead with the data.", "Numbers don't lie. The evidence speaks volumes.", "Strategy", 9),
                ],
                [
                    ("Tell a personal story.", "Vulnerability connects. The audience sees themselves in you.", "Connection", 13),
                    ("Present a grand vision!", "They see the future through your eyes. They want to go there.", "Leadership", 14),
                ],
                [
                    ("Invite audience participation!", "The room transforms from listeners to collaborators.", "Teamwork", 10),
                    ("Deliver a polished monologue.", "Every word rehearsed. Flawless execution.", "Focus", 11),
                ],
                [
                    ("Improvise when things go wrong!", "The crystal projector breaks. You wing it. Best talk ever.", "Resilience", 12),
                    ("Stick to the script perfectly.", "Preparation meets opportunity. Smooth as silk.", "Focus", 9),
                ],
                [
                    ("End with a call to action!", "The crowd rises. They're ready to march.", "Leadership", 15),
                    ("Close with a quiet, powerful truth.", "A pin could drop. Then: thunderous applause.", "Serenity", 10),
                ],
                [
                    ("Challenge the conventional wisdom!", "Gasps, then nods. You've changed minds today.", "Courage", 13),
                    ("Build on what everyone already knows.", "Familiar ground makes new ideas feel safe.", "Wisdom", 8),
                ],
                [
                    ("Answer every question fearlessly!", "No dodge, no deflection. Raw expertise on display.", "Courage", 11),
                    ("Promise to follow up personally.", "Individual attention after a group talk. Class act.", "Connection", 9),
                ],
            ]

        // MARK: - Doctor Responses (10 pairs)
        case .doctor:
            allOptions = [
                [
                    ("Check my vitals!", "Clean bill of health!", "Vitality", 8),
                    ("Full examination!", "All systems optimal!", "Resilience", 10),
                ],
                [
                    ("Ask all your questions!", "Knowledge dispels fear. You leave informed and empowered.", "Wisdom", 11),
                    ("Trust the healer's guidance.", "Expert hands and a calm voice. You're in good care.", "Serenity", 8),
                ],
                [
                    ("Request the deluxe checkup!", "Every stat checked, every buff verified. Thorough.", "Vitality", 13),
                    ("Quick scan and go.", "Efficient health maintenance. No time wasted.", "Energy", 6),
                ],
                [
                    ("Be completely honest about symptoms.", "Transparency leads to the right remedy. Full heal.", "Courage", 9),
                    ("Focus on prevention.", "An ounce of prevention potion beats a pound of cure.", "Wisdom", 10),
                ],
                [
                    ("Follow the treatment plan exactly.", "Discipline in healing pays dividends. Stat boost!", "Resilience", 12),
                    ("Ask about alternative remedies.", "The healer raises an eyebrow but shares the herbal options.", "Creativity", 7),
                ],
                [
                    ("Schedule regular follow-ups.", "Consistent care compounds over time. Investment in yourself.", "Strategy", 8),
                    ("Celebrate the good results!", "Health confirmed! Time to adventure harder than ever.", "Energy", 10),
                ],
                [
                    ("Bring a list of concerns.", "Organized patients get the best care. Every issue addressed.", "Focus", 9),
                    ("Let the healer lead.", "They've seen a thousand adventurers. They know what to look for.", "Serenity", 7),
                ],
                [
                    ("Take the bitter medicine bravely!", "It tastes like defeat but works like victory.", "Endurance", 8),
                    ("Request the flavored version.", "Same healing power, now with hints of elderberry. Much better.", "Wit", 5),
                ],
                [
                    ("Share the results with your party.", "They worry about you. Transparency strengthens trust.", "Connection", 9),
                    ("Keep the details private.", "Your health, your business. Boundaries are healthy too.", "Resilience", 7),
                ],
                [
                    ("Commit to a healthier lifestyle!", "The healer beams. 'Now THAT'S what I like to hear.'", "Vitality", 14),
                    ("Acknowledge the wake-up call.", "A sobering moment leads to lasting change.", "Wisdom", 11),
                ],
            ]

        // MARK: - Happy Hour Responses (10 pairs)
        case .happyHour:
            allOptions = [
                [
                    ("Cheers to all!", "Bonds of friendship deepen!", "Connection", 12),
                    ("Tell a great tale!", "You become the life of the party!", "Charisma", 15),
                ],
                [
                    ("Buy a round for the house!", "The entire tavern chants your name!", "Charisma", 14),
                    ("Raise a quiet toast to absent friends.", "A moment of warmth in the revelry.", "Serenity", 8),
                ],
                [
                    ("Challenge someone to arm wrestling!", "Win or lose, the crowd loves the show.", "Vitality", 10),
                    ("Start a group sing-along.", "Fifty voices, one terrible but glorious song.", "Teamwork", 11),
                ],
                [
                    ("Share your wildest adventure story!", "Jaws drop. Someone spills their drink in shock.", "Charisma", 13),
                    ("Listen to everyone else's stories.", "The best listeners collect the best tales.", "Wisdom", 9),
                ],
                [
                    ("Make friends with a stranger.", "By night's end, they're part of the party. Permanently.", "Connection", 14),
                    ("Deepen bonds with old companions.", "Shared history gains another golden chapter.", "Teamwork", 10),
                ],
                [
                    ("Dance like nobody's watching!", "They're definitely watching. They're also definitely joining in.", "Energy", 11),
                    ("Hold court at the best table.", "Stories, laughter, and wisdom flow freely.", "Leadership", 9),
                ],
                [
                    ("Propose a ridiculous toast!", "'To the one sock we all lose!' The crowd ROARS.", "Wit", 12),
                    ("Give a heartfelt speech.", "Eyes glisten. Real talk in a silly place. Perfect.", "Connection", 13),
                ],
                [
                    ("Start a friendly darts tournament!", "The stakes are low. The fun is astronomical.", "Focus", 7),
                    ("Sit by the fire with your closest ally.", "No words needed. Just warmth and presence.", "Serenity", 10),
                ],
                [
                    ("Try the tavern's mystery cocktail!", "It's blue, it's glowing, and it tastes like... victory?", "Courage", 8),
                    ("Stick with the classic mead.", "You know what you like. Reliable and satisfying.", "Resilience", 6),
                ],
                [
                    ("Close the tavern down!", "Last ones out. Best night in recent memory.", "Endurance", 10),
                    ("Leave at the perfect moment.", "Exit on a high note. Legendary timing.", "Wisdom", 9),
                ],
            ]
        }

        return allOptions.randomElement()!
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
