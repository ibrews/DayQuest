import SpriteKit

class DayQuestScene: SKScene {

    // MARK: - Properties

    private let events: [CalendarEvent]
    private var onEventComplete: (String, Int) -> Void
    private var onQuestComplete: () -> Void

    private var playerNode: SKSpriteNode!
    private var cameraNode: SKCameraNode!

    private struct EventLocation {
        let node: SKNode
        let event: CalendarEvent
        let position: CGPoint
        var visited: Bool = false
        var markerNode: SKSpriteNode?
    }

    private var eventLocations: [EventLocation] = []
    private var currentEventIndex: Int = 0
    private var isPlayerMoving = false

    private enum DialogueState {
        case none, showingIntro, showingChoices, showingOutcome
    }
    private var dialogueState: DialogueState = .none
    private var dialogueContainer: SKNode?
    private var currentDialogue: (title: String, detail: String)?

    private var walkFrames: [SKTexture] = []
    private var standingTexture: SKTexture!

    // HUD
    private var hudContainer: SKNode!
    private var progressDots: [SKShapeNode] = []
    private var hudLabel: SKLabelNode!

    // Layout
    private let sceneWidth: CGFloat = 390
    private let sceneHeight: CGFloat = 844
    private let pathCenterX: CGFloat = 195
    private let startY: CGFloat = 150
    private let eventSpacing: CGFloat = 280

    // Dust trail timer
    private var dustTimer: TimeInterval = 0

    // MARK: - Init

    init(events: [CalendarEvent],
         onEventComplete: @escaping (String, Int) -> Void,
         onQuestComplete: @escaping () -> Void) {
        self.events = events
        self.onEventComplete = onEventComplete
        self.onQuestComplete = onQuestComplete
        super.init(size: CGSize(width: 390, height: 844))
        self.scaleMode = .aspectFill
        self.anchorPoint = CGPoint(x: 0, y: 0)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        setupTextures()
        backgroundColor = UIColor(red: 0.36, green: 0.65, blue: 0.35, alpha: 1)
        setupGrassTufts()
        setupPath()
        setupHome()
        setupEvents()
        setupDecorations()
        setupPlayer()
        setupCamera()
        setupClouds()
        setupHUD()

        run(.sequence([
            .wait(forDuration: 0.8),
            .run { [weak self] in self?.highlightCurrentEvent() }
        ]))
    }

    override func update(_ currentTime: TimeInterval) {
        // Spawn dust trail while walking
        if isPlayerMoving {
            if dustTimer <= 0 {
                spawnDust(at: playerNode.position)
                dustTimer = 0.12
            }
            dustTimer -= 1.0 / 60.0
        }
    }

    // MARK: - Setup

    private func setupTextures() {
        standingTexture = SpriteFactory.playerTexture(frame: 0)
        walkFrames = [
            SpriteFactory.playerTexture(frame: 1),
            SpriteFactory.playerTexture(frame: 0),
            SpriteFactory.playerTexture(frame: 2),
            SpriteFactory.playerTexture(frame: 0),
        ]
    }

    private func setupGrassTufts() {
        let totalHeight = startY + CGFloat(events.count + 2) * eventSpacing
        for _ in 0..<80 {
            let x = CGFloat.random(in: 0...sceneWidth)
            let y = CGFloat.random(in: 0...totalHeight)
            guard abs(x - pathCenterX) > 30 else { continue }

            let tuft = SKShapeNode(ellipseOf: CGSize(width: 6, height: 3))
            tuft.fillColor = UIColor(red: 0.30, green: 0.58, blue: 0.28, alpha: 0.5)
            tuft.strokeColor = .clear
            tuft.position = CGPoint(x: x, y: y)
            addChild(tuft)
        }
    }

    private func setupPath() {
        let totalHeight = startY + CGFloat(events.count + 1) * eventSpacing + 50

        let shadow = SKShapeNode(rectOf: CGSize(width: 44, height: totalHeight - startY + 40), cornerRadius: 20)
        shadow.fillColor = UIColor(red: 0.45, green: 0.35, blue: 0.22, alpha: 1)
        shadow.strokeColor = .clear
        shadow.position = CGPoint(x: pathCenterX, y: startY + (totalHeight - startY) / 2)
        shadow.zPosition = 1
        addChild(shadow)

        let road = SKShapeNode(rectOf: CGSize(width: 36, height: totalHeight - startY + 32), cornerRadius: 16)
        road.fillColor = UIColor(red: 0.72, green: 0.58, blue: 0.40, alpha: 1)
        road.strokeColor = .clear
        road.position = CGPoint(x: pathCenterX, y: startY + (totalHeight - startY) / 2)
        road.zPosition = 2
        addChild(road)

        var dotY = startY
        while dotY < totalHeight {
            let dot = SKShapeNode(circleOfRadius: 1.5)
            dot.fillColor = UIColor(red: 0.65, green: 0.50, blue: 0.32, alpha: 0.5)
            dot.strokeColor = .clear
            dot.position = CGPoint(x: pathCenterX + CGFloat.random(in: -10...10), y: dotY)
            dot.zPosition = 3
            addChild(dot)
            dotY += CGFloat.random(in: 15...25)
        }
    }

    private func setupHome() {
        let homeSprite = SKSpriteNode(texture: SpriteFactory.homeTexture())
        homeSprite.position = CGPoint(x: pathCenterX + 65, y: startY)
        homeSprite.zPosition = 5
        homeSprite.setScale(2.5)
        addChild(homeSprite)

        let label = makeLabel("Home", size: 14)
        label.position = CGPoint(x: pathCenterX + 65, y: startY - 38)
        label.zPosition = 6
        addChild(label)
    }

    private func setupEvents() {
        for (i, event) in events.enumerated() {
            let y = startY + CGFloat(i + 1) * eventSpacing
            let side: CGFloat = (i % 2 == 0) ? 1 : -1
            let buildingX = pathCenterX + side * 75

            let building = SKSpriteNode(texture: SpriteFactory.buildingTexture(for: event.type))
            building.position = CGPoint(x: buildingX, y: y + 10)
            building.zPosition = 5
            building.setScale(2.5)
            addChild(building)

            // Event name — bigger, with shadow for readability
            let nameShadow = makeLabel(event.title, size: 13)
            nameShadow.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            nameShadow.position = CGPoint(x: buildingX + 1, y: y - 33)
            nameShadow.zPosition = 5.9
            addChild(nameShadow)

            let nameLabel = makeLabel(event.title, size: 13)
            nameLabel.position = CGPoint(x: buildingX, y: y - 32)
            nameLabel.zPosition = 6
            addChild(nameLabel)

            // Time — bigger, with background pill
            let timeBg = SKShapeNode(rectOf: CGSize(width: 80, height: 18), cornerRadius: 9)
            timeBg.fillColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
            timeBg.strokeColor = .clear
            timeBg.position = CGPoint(x: buildingX, y: y - 50)
            timeBg.zPosition = 5.9
            addChild(timeBg)

            let timeLabel = makeLabel(event.timeString, size: 12)
            timeLabel.fontColor = UIColor(red: 1, green: 0.93, blue: 0.15, alpha: 1)
            timeLabel.position = CGPoint(x: buildingX, y: y - 54)
            timeLabel.zPosition = 6
            addChild(timeLabel)

            // NPCs
            let shirtColors = [11, 9, 14, 13, 12]
            let hatColors   = [10, 3,  2,  6,  8]
            for (j, _) in event.attendees.prefix(3).enumerated() {
                let npcX = buildingX + CGFloat(j - min(event.attendees.count - 1, 2) / 2) * 28
                let npc = SKSpriteNode(texture: SpriteFactory.npcTexture(
                    shirtColor: shirtColors[j % shirtColors.count],
                    hatColor: hatColors[j % hatColors.count]
                ))
                npc.position = CGPoint(x: npcX, y: y - 14)
                npc.zPosition = 5
                npc.setScale(2.0)
                addChild(npc)

                let bob = SKAction.sequence([
                    .moveBy(x: 0, y: 3, duration: 0.5 + Double.random(in: 0...0.3)),
                    .moveBy(x: 0, y: -3, duration: 0.5 + Double.random(in: 0...0.3)),
                ])
                npc.run(.repeatForever(bob))
            }

            // Marker
            let marker = SKSpriteNode(texture: SpriteFactory.markerTexture())
            marker.position = CGPoint(x: pathCenterX, y: y + 55)
            marker.zPosition = 10
            marker.setScale(2.0)
            marker.alpha = 0
            addChild(marker)

            marker.run(.repeatForever(.sequence([
                .moveBy(x: 0, y: 8, duration: 0.4),
                .moveBy(x: 0, y: -8, duration: 0.4),
            ])))

            eventLocations.append(EventLocation(
                node: building, event: event,
                position: CGPoint(x: pathCenterX, y: y),
                markerNode: marker
            ))
        }
    }

    private func setupDecorations() {
        let totalHeight = startY + CGFloat(events.count + 2) * eventSpacing

        for _ in 0..<20 {
            let x: CGFloat = Bool.random()
                ? CGFloat.random(in: 10...75)
                : CGFloat.random(in: 315...380)
            let y = CGFloat.random(in: 50...totalHeight)
            let tree = SKSpriteNode(texture: SpriteFactory.treeTexture())
            tree.position = CGPoint(x: x, y: y)
            tree.zPosition = 4
            tree.setScale(2.0)
            addChild(tree)
        }

        let flowerColors = [8, 14, 10, 12]
        for _ in 0..<30 {
            let x = CGFloat.random(in: 10...380)
            let y = CGFloat.random(in: 50...totalHeight)
            guard abs(x - pathCenterX) > 28 else { continue }

            let flower = SKSpriteNode(texture: SpriteFactory.flowerTexture(
                color: flowerColors.randomElement()!
            ))
            flower.position = CGPoint(x: x, y: y)
            flower.zPosition = 3
            flower.setScale(2.0)
            addChild(flower)

            flower.run(.repeatForever(.sequence([
                .rotate(byAngle: 0.08, duration: 0.7 + Double.random(in: 0...0.4)),
                .rotate(byAngle: -0.08, duration: 0.7 + Double.random(in: 0...0.4)),
            ])))
        }

        for _ in 0..<10 {
            let x: CGFloat = Bool.random()
                ? CGFloat.random(in: 25...110)
                : CGFloat.random(in: 280...365)
            let y = CGFloat.random(in: 50...totalHeight)
            let bush = SKSpriteNode(texture: SpriteFactory.bushTexture())
            bush.position = CGPoint(x: x, y: y)
            bush.zPosition = 4
            bush.setScale(2.0)
            addChild(bush)
        }
    }

    private func setupClouds() {
        // Floating clouds attached to camera so they're always visible
        for _ in 0..<4 {
            let cloud = SKSpriteNode(texture: SpriteFactory.cloudTexture())
            cloud.setScale(CGFloat.random(in: 2.0...3.5))
            cloud.alpha = CGFloat.random(in: 0.15...0.3)
            cloud.zPosition = 50

            let startX = CGFloat.random(in: -250...250)
            let cloudY = CGFloat.random(in: -300...350)
            cloud.position = CGPoint(x: startX, y: cloudY)
            cameraNode.addChild(cloud)

            // Drift across the screen
            let speed = Double.random(in: 25...50)
            let driftRight = SKAction.moveBy(x: 600, y: 0, duration: 600 / speed)
            let reset = SKAction.moveBy(x: -600, y: CGFloat.random(in: -50...50), duration: 0)
            cloud.run(.repeatForever(.sequence([driftRight, reset])))
        }
    }

    private func setupPlayer() {
        playerNode = SKSpriteNode(texture: standingTexture)
        playerNode.position = CGPoint(x: pathCenterX, y: startY)
        playerNode.zPosition = 20
        playerNode.setScale(2.5)
        addChild(playerNode)

        playerNode.run(.repeatForever(.sequence([
            .moveBy(x: 0, y: 2, duration: 0.5),
            .moveBy(x: 0, y: -2, duration: 0.5),
        ])), withKey: "idle")
    }

    private func setupCamera() {
        cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: sceneWidth / 2, y: startY)
        camera = cameraNode
        addChild(cameraNode)
    }

    // MARK: - HUD

    private func setupHUD() {
        hudContainer = SKNode()
        hudContainer.zPosition = 90
        cameraNode.addChild(hudContainer)

        let hudY: CGFloat = sceneHeight / 2 - 70

        // Background pill
        let bgWidth: CGFloat = CGFloat(events.count) * 28 + 20
        let bg = SKShapeNode(rectOf: CGSize(width: bgWidth, height: 30), cornerRadius: 15)
        bg.fillColor = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 0.8)
        bg.strokeColor = UIColor(white: 1, alpha: 0.2)
        bg.lineWidth = 1
        bg.position = CGPoint(x: 0, y: hudY)
        hudContainer.addChild(bg)

        // Progress dots
        let totalWidth = CGFloat(events.count - 1) * 28
        for i in 0..<events.count {
            let dot = SKShapeNode(circleOfRadius: 8)
            dot.fillColor = UIColor(red: 0.25, green: 0.25, blue: 0.35, alpha: 1)
            dot.strokeColor = UIColor(white: 1, alpha: 0.3)
            dot.lineWidth = 1
            dot.position = CGPoint(x: CGFloat(i) * 28 - totalWidth / 2, y: hudY)
            hudContainer.addChild(dot)

            // Tiny emoji
            let emoji = SKLabelNode(text: events[i].type.emoji)
            emoji.fontSize = 10
            emoji.verticalAlignmentMode = .center
            emoji.position = CGPoint(x: CGFloat(i) * 28 - totalWidth / 2, y: hudY)
            hudContainer.addChild(emoji)

            progressDots.append(dot)
        }
    }

    private func updateHUD(completedIndex: Int) {
        guard completedIndex < progressDots.count else { return }
        let dot = progressDots[completedIndex]
        dot.run(.sequence([
            .scale(to: 1.5, duration: 0.15),
            .group([
                .scale(to: 1.0, duration: 0.15),
                .run {
                    dot.fillColor = UIColor(red: 0, green: 0.89, blue: 0.21, alpha: 1)
                    dot.strokeColor = UIColor(red: 0, green: 0.89, blue: 0.21, alpha: 0.5)
                }
            ])
        ]))
    }

    // MARK: - Effects

    private func spawnDust(at position: CGPoint) {
        let dust = SKShapeNode(circleOfRadius: CGFloat.random(in: 2...4))
        dust.fillColor = UIColor(red: 0.72, green: 0.58, blue: 0.40, alpha: 0.6)
        dust.strokeColor = .clear
        dust.position = CGPoint(
            x: position.x + CGFloat.random(in: -8...8),
            y: position.y - 20
        )
        dust.zPosition = 19
        addChild(dust)

        dust.run(.sequence([
            .group([
                .fadeOut(withDuration: 0.5),
                .moveBy(x: CGFloat.random(in: -10...10), y: -8, duration: 0.5),
                .scale(to: 2.0, duration: 0.5),
            ]),
            .removeFromParent()
        ]))
    }

    private func spawnSparkles(at position: CGPoint) {
        for _ in 0..<12 {
            let sparkle = SKSpriteNode(texture: SpriteFactory.starParticleTexture())
            sparkle.setScale(CGFloat.random(in: 0.5...1.5))
            sparkle.position = position
            sparkle.zPosition = 25
            addChild(sparkle)

            let angle = CGFloat.random(in: 0...(2 * .pi))
            let dist = CGFloat.random(in: 30...80)
            let dx = cos(angle) * dist
            let dy = sin(angle) * dist

            sparkle.run(.sequence([
                .group([
                    .moveBy(x: dx, y: dy, duration: 0.6),
                    .fadeOut(withDuration: 0.6),
                    .rotate(byAngle: CGFloat.random(in: -3...3), duration: 0.6),
                ]),
                .removeFromParent()
            ]))
        }
    }

    private func spawnHearts(at position: CGPoint) {
        for _ in 0..<5 {
            let heart = SKSpriteNode(texture: SpriteFactory.heartTexture())
            heart.setScale(CGFloat.random(in: 1.0...2.0))
            heart.position = CGPoint(
                x: position.x + CGFloat.random(in: -30...30),
                y: position.y
            )
            heart.zPosition = 25
            addChild(heart)

            heart.run(.sequence([
                .group([
                    .moveBy(x: CGFloat.random(in: -15...15), y: CGFloat.random(in: 40...80), duration: 0.8),
                    .fadeOut(withDuration: 0.8),
                ]),
                .removeFromParent()
            ]))
        }
    }

    // MARK: - Gameplay

    private func highlightCurrentEvent() {
        guard currentEventIndex < eventLocations.count else { return }
        let loc = eventLocations[currentEventIndex]
        loc.markerNode?.run(.fadeIn(withDuration: 0.3))
        loc.node.run(.repeatForever(.sequence([
            .scale(to: 2.7, duration: 0.5),
            .scale(to: 2.5, duration: 0.5),
        ])), withKey: "pulse")
    }

    private func movePlayerToEvent(at index: Int) {
        guard !isPlayerMoving, index < eventLocations.count else { return }
        isPlayerMoving = true
        dustTimer = 0

        let target = eventLocations[index].position
        let dist = abs(target.y - playerNode.position.y)
        let duration = TimeInterval(dist / 150)

        playerNode.removeAction(forKey: "idle")
        playerNode.run(.repeatForever(.animate(with: walkFrames, timePerFrame: 0.15)), withKey: "walk")

        let move = SKAction.move(to: CGPoint(x: pathCenterX, y: target.y), duration: duration)
        move.timingMode = .easeInEaseOut

        let camMove = SKAction.move(to: CGPoint(x: sceneWidth / 2, y: target.y), duration: duration)
        camMove.timingMode = .easeInEaseOut
        cameraNode.run(camMove)

        playerNode.run(move) { [weak self] in
            guard let self else { return }
            self.isPlayerMoving = false
            self.playerNode.removeAction(forKey: "walk")
            self.playerNode.texture = self.standingTexture
            self.playerNode.run(.repeatForever(.sequence([
                .moveBy(x: 0, y: 2, duration: 0.5),
                .moveBy(x: 0, y: -2, duration: 0.5),
            ])), withKey: "idle")
            self.showDialogue(for: index)
        }
    }

    private func walkHome() {
        isPlayerMoving = true
        dustTimer = 0
        playerNode.removeAction(forKey: "idle")
        playerNode.run(.repeatForever(.animate(with: walkFrames, timePerFrame: 0.15)), withKey: "walk")

        let dist = abs(playerNode.position.y - startY)
        let duration = TimeInterval(dist / 180) // slightly faster walk home

        let move = SKAction.move(to: CGPoint(x: pathCenterX, y: startY), duration: duration)
        move.timingMode = .easeInEaseOut

        let camMove = SKAction.move(to: CGPoint(x: sceneWidth / 2, y: startY), duration: duration)
        camMove.timingMode = .easeInEaseOut
        cameraNode.run(camMove)

        playerNode.run(move) { [weak self] in
            guard let self else { return }
            self.isPlayerMoving = false
            self.playerNode.removeAction(forKey: "walk")
            self.playerNode.texture = self.standingTexture
            self.playerNode.run(.repeatForever(.sequence([
                .moveBy(x: 0, y: 2, duration: 0.5),
                .moveBy(x: 0, y: -2, duration: 0.5),
            ])), withKey: "idle")

            // Celebration sparkles then complete
            self.spawnSparkles(at: self.playerNode.position)
            self.spawnHearts(at: CGPoint(x: self.playerNode.position.x, y: self.playerNode.position.y + 30))
            self.run(.sequence([
                .wait(forDuration: 1.2),
                .run { self.onQuestComplete() }
            ]))
        }
    }

    // MARK: - Dialogue

    private func showDialogue(for eventIndex: Int) {
        let event = eventLocations[eventIndex].event
        dialogueState = .showingIntro

        // Get a random dialogue for this event type and cache it
        let dialogue = event.type.randomDialogue()
        currentDialogue = dialogue

        let container = SKNode()
        container.zPosition = 100
        cameraNode.addChild(container)
        dialogueContainer = container

        let boxH: CGFloat = 200
        let boxW: CGFloat = 350
        let boxY: CGFloat = -sceneHeight / 2 + boxH / 2 + 40

        let bg = SKShapeNode(rectOf: CGSize(width: boxW, height: boxH), cornerRadius: 12)
        bg.fillColor = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 0.94)
        bg.strokeColor = UIColor(red: 1, green: 0.93, blue: 0.15, alpha: 1)
        bg.lineWidth = 2
        bg.position = CGPoint(x: 0, y: boxY)
        container.addChild(bg)

        let emojiLabel = SKLabelNode(text: event.type.emoji)
        emojiLabel.fontSize = 28
        emojiLabel.position = CGPoint(x: 0, y: boxY + 60)
        container.addChild(emojiLabel)

        let titleText = event.type.arrivalTitle(with: event.attendees)
        let titleLabel = SKLabelNode(text: titleText)
        titleLabel.fontName = "Menlo-Bold"
        titleLabel.fontSize = 13
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: 0, y: boxY + 28)
        titleLabel.preferredMaxLayoutWidth = boxW - 40
        titleLabel.numberOfLines = 2
        container.addChild(titleLabel)

        let descLabel = SKLabelNode(text: dialogue.detail)
        descLabel.fontName = "Menlo"
        descLabel.fontSize = 11
        descLabel.fontColor = UIColor(red: 0.76, green: 0.76, blue: 0.78, alpha: 1)
        descLabel.position = CGPoint(x: 0, y: boxY - 2)
        descLabel.preferredMaxLayoutWidth = boxW - 40
        descLabel.numberOfLines = 2
        container.addChild(descLabel)

        let eventLabel = SKLabelNode(text: "「\(event.title) · \(event.timeString)」")
        eventLabel.fontName = "Menlo"
        eventLabel.fontSize = 10
        eventLabel.fontColor = UIColor(red: 1, green: 0.93, blue: 0.15, alpha: 1)
        eventLabel.position = CGPoint(x: 0, y: boxY - 35)
        container.addChild(eventLabel)

        let hint = SKLabelNode(text: "▼ tap to continue")
        hint.fontName = "Menlo"
        hint.fontSize = 9
        hint.fontColor = UIColor(white: 1, alpha: 0.5)
        hint.position = CGPoint(x: 0, y: boxY - 75)
        container.addChild(hint)
        hint.run(.repeatForever(.sequence([
            .fadeAlpha(to: 0.3, duration: 0.5),
            .fadeAlpha(to: 0.8, duration: 0.5),
        ])))
    }

    private func showChoices(for eventIndex: Int) {
        guard let container = dialogueContainer else { return }
        dialogueState = .showingChoices
        container.removeAllChildren()

        let event = eventLocations[eventIndex].event
        let responses = event.type.responses

        let boxH: CGFloat = 200
        let boxW: CGFloat = 350
        let boxY: CGFloat = -sceneHeight / 2 + boxH / 2 + 40

        let bg = SKShapeNode(rectOf: CGSize(width: boxW, height: boxH), cornerRadius: 12)
        bg.fillColor = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 0.94)
        bg.strokeColor = UIColor(red: 1, green: 0.93, blue: 0.15, alpha: 1)
        bg.lineWidth = 2
        bg.position = CGPoint(x: 0, y: boxY)
        container.addChild(bg)

        let prompt = SKLabelNode(text: "What do you do?")
        prompt.fontName = "Menlo-Bold"
        prompt.fontSize = 14
        prompt.fontColor = .white
        prompt.position = CGPoint(x: 0, y: boxY + 55)
        container.addChild(prompt)

        for (i, response) in responses.enumerated() {
            let btnY = boxY + 10 - CGFloat(i) * 55

            let btn = SKShapeNode(rectOf: CGSize(width: 300, height: 40), cornerRadius: 8)
            btn.fillColor = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1)
            btn.strokeColor = UIColor(red: 0.16, green: 0.68, blue: 1, alpha: 0.8)
            btn.lineWidth = 1.5
            btn.position = CGPoint(x: 0, y: btnY)
            btn.name = "choice_\(i)"
            container.addChild(btn)

            let lbl = SKLabelNode(text: "▸ \(response.text)")
            lbl.fontName = "Menlo-Bold"
            lbl.fontSize = 13
            lbl.fontColor = UIColor(red: 0.16, green: 0.68, blue: 1, alpha: 1)
            lbl.verticalAlignmentMode = .center
            lbl.position = CGPoint(x: 0, y: btnY)
            lbl.name = "choice_\(i)"
            container.addChild(lbl)
        }
    }

    private func showOutcome(choiceIndex: Int, eventIndex: Int) {
        guard let container = dialogueContainer else { return }
        dialogueState = .showingOutcome
        container.removeAllChildren()

        let response = eventLocations[eventIndex].event.type.responses[choiceIndex]

        let boxH: CGFloat = 200
        let boxW: CGFloat = 350
        let boxY: CGFloat = -sceneHeight / 2 + boxH / 2 + 40

        let bg = SKShapeNode(rectOf: CGSize(width: boxW, height: boxH), cornerRadius: 12)
        bg.fillColor = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 0.94)
        bg.strokeColor = UIColor(red: 0, green: 0.89, blue: 0.21, alpha: 1)
        bg.lineWidth = 2
        bg.position = CGPoint(x: 0, y: boxY)
        container.addChild(bg)

        let star = SKLabelNode(text: "⭐")
        star.fontSize = 36
        star.position = CGPoint(x: 0, y: boxY + 50)
        container.addChild(star)

        let outcome = SKLabelNode(text: response.outcome)
        outcome.fontName = "Menlo-Bold"
        outcome.fontSize = 14
        outcome.fontColor = UIColor(red: 0, green: 0.89, blue: 0.21, alpha: 1)
        outcome.position = CGPoint(x: 0, y: boxY + 10)
        outcome.preferredMaxLayoutWidth = boxW - 40
        outcome.numberOfLines = 2
        container.addChild(outcome)

        let stat = SKLabelNode(text: "+\(response.value) \(response.stat)")
        stat.fontName = "Menlo-Bold"
        stat.fontSize = 18
        stat.fontColor = UIColor(red: 1, green: 0.93, blue: 0.15, alpha: 1)
        stat.position = CGPoint(x: 0, y: boxY - 25)
        container.addChild(stat)

        stat.setScale(0.1)
        stat.run(.sequence([
            .scale(to: 1.3, duration: 0.2),
            .scale(to: 1.0, duration: 0.1),
        ]))

        let hint = SKLabelNode(text: "▼ tap to continue")
        hint.fontName = "Menlo"
        hint.fontSize = 9
        hint.fontColor = UIColor(white: 1, alpha: 0.5)
        hint.position = CGPoint(x: 0, y: boxY - 70)
        container.addChild(hint)
        hint.run(.repeatForever(.sequence([
            .fadeAlpha(to: 0.3, duration: 0.5),
            .fadeAlpha(to: 0.8, duration: 0.5),
        ])))

        // Sparkle effect on the player
        spawnSparkles(at: playerNode.position)

        onEventComplete(response.stat, response.value)
    }

    private func dismissDialogue() {
        dialogueContainer?.removeFromParent()
        dialogueContainer = nil
        dialogueState = .none
        currentDialogue = nil

        // Mark visited
        eventLocations[currentEventIndex].visited = true
        eventLocations[currentEventIndex].markerNode?.run(.fadeOut(withDuration: 0.3))
        eventLocations[currentEventIndex].node.removeAction(forKey: "pulse")
        eventLocations[currentEventIndex].node.run(.scale(to: 2.5, duration: 0.2))

        // Update HUD
        updateHUD(completedIndex: currentEventIndex)

        // Checkmark
        let check = SKSpriteNode(texture: SpriteFactory.checkmarkTexture())
        check.position = CGPoint(
            x: eventLocations[currentEventIndex].node.position.x + 30,
            y: eventLocations[currentEventIndex].node.position.y + 30
        )
        check.zPosition = 15
        check.setScale(0.5)
        check.alpha = 0
        addChild(check)
        check.run(.group([
            .fadeIn(withDuration: 0.2),
            .scale(to: 2.5, duration: 0.3),
        ]))

        currentEventIndex += 1

        if currentEventIndex < eventLocations.count {
            run(.sequence([
                .wait(forDuration: 0.5),
                .run { [weak self] in self?.highlightCurrentEvent() }
            ]))
        } else {
            // Walk home then complete
            run(.sequence([
                .wait(forDuration: 0.8),
                .run { [weak self] in self?.walkHome() }
            ]))
        }
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        switch dialogueState {
        case .none:
            if !isPlayerMoving, currentEventIndex < eventLocations.count {
                movePlayerToEvent(at: currentEventIndex)
            }

        case .showingIntro:
            showChoices(for: currentEventIndex)

        case .showingChoices:
            guard let container = dialogueContainer else { return }
            let loc = touch.location(in: container)
            for node in container.nodes(at: loc) {
                if let name = node.name, name.hasPrefix("choice_"),
                   let idx = Int(name.replacingOccurrences(of: "choice_", with: "")) {
                    showOutcome(choiceIndex: idx, eventIndex: currentEventIndex)
                    return
                }
            }

        case .showingOutcome:
            dismissDialogue()
        }
    }

    // MARK: - Helpers

    private func makeLabel(_ text: String, size: CGFloat) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.fontName = "Menlo-Bold"
        label.fontSize = size
        label.fontColor = .white
        label.horizontalAlignmentMode = .center
        return label
    }
}
