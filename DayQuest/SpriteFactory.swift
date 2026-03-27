import SpriteKit

struct SpriteFactory {
    static let pixelSize: CGFloat = 3.0

    // PICO-8 inspired palette
    static let palette: [UIColor] = [
        .clear,                                                     // 0: transparent
        UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1),     // 1: near-black
        UIColor(red: 0.49, green: 0.15, blue: 0.33, alpha: 1),     // 2: dark purple
        UIColor(red: 0.00, green: 0.53, blue: 0.32, alpha: 1),     // 3: dark green
        UIColor(red: 0.67, green: 0.32, blue: 0.21, alpha: 1),     // 4: brown
        UIColor(red: 0.37, green: 0.34, blue: 0.31, alpha: 1),     // 5: dark gray
        UIColor(red: 0.76, green: 0.76, blue: 0.78, alpha: 1),     // 6: light gray
        UIColor(red: 1.00, green: 0.95, blue: 0.91, alpha: 1),     // 7: white
        UIColor(red: 1.00, green: 0.00, blue: 0.30, alpha: 1),     // 8: red
        UIColor(red: 1.00, green: 0.64, blue: 0.00, alpha: 1),     // 9: orange
        UIColor(red: 1.00, green: 0.93, blue: 0.15, alpha: 1),     // 10: yellow
        UIColor(red: 0.00, green: 0.89, blue: 0.21, alpha: 1),     // 11: green
        UIColor(red: 0.16, green: 0.68, blue: 1.00, alpha: 1),     // 12: blue
        UIColor(red: 0.51, green: 0.46, blue: 0.61, alpha: 1),     // 13: indigo
        UIColor(red: 1.00, green: 0.47, blue: 0.66, alpha: 1),     // 14: pink
        UIColor(red: 1.00, green: 0.80, blue: 0.67, alpha: 1),     // 15: peach/skin
    ]

    static func texture(from pixels: [[Int]]) -> SKTexture {
        let h = pixels.count
        guard h > 0 else { return SKTexture() }
        let w = pixels[0].count
        let size = CGSize(width: CGFloat(w) * pixelSize, height: CGFloat(h) * pixelSize)

        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            for y in 0..<h {
                for x in 0..<w {
                    let ci = pixels[y][x]
                    guard ci > 0, ci < palette.count else { continue }
                    palette[ci].setFill()
                    ctx.fill(CGRect(
                        x: CGFloat(x) * pixelSize,
                        y: CGFloat(y) * pixelSize,
                        width: pixelSize, height: pixelSize
                    ))
                }
            }
        }
        let tex = SKTexture(image: image)
        tex.filteringMode = .nearest
        return tex
    }

    // MARK: - Player Character (8x12)

    static func playerTexture(frame: Int = 0, hat: Int = 8, shirt: Int = 12) -> SKTexture {
        let h = hat
        let s = shirt
        let standing: [[Int]] = [
            [0, 0, 0, h, h, h, 0, 0],
            [0, 0, h, h, h, h, h, 0],
            [0, 0,15,15,15,15, 0, 0],
            [0,15, 1,15,15, 1,15, 0],
            [0, 0,15,15,15,15, 0, 0],
            [0, 0,15,14,14,15, 0, 0],
            [0, s, s, s, s, s, s, 0],
            [15, s, s, s, s, s, s,15],
            [0, 0, s, s, s, s, 0, 0],
            [0, 0, 1, 1, 1, 1, 0, 0],
            [0, 0, 1, 0, 0, 1, 0, 0],
            [0, 0, 4, 0, 0, 4, 0, 0],
        ]

        let walk1: [[Int]] = [
            [0, 0, 0, h, h, h, 0, 0],
            [0, 0, h, h, h, h, h, 0],
            [0, 0,15,15,15,15, 0, 0],
            [0,15, 1,15,15, 1,15, 0],
            [0, 0,15,15,15,15, 0, 0],
            [0, 0,15,14,14,15, 0, 0],
            [0, s, s, s, s, s, s, 0],
            [15, s, s, s, s, s, s,15],
            [0, 0, s, s, s, s, 0, 0],
            [0, 0, 1, 1, 1, 1, 0, 0],
            [0, 4, 1, 0, 0, 1, 4, 0],
            [0, 4, 0, 0, 0, 0, 4, 0],
        ]

        let walk2: [[Int]] = [
            [0, 0, 0, h, h, h, 0, 0],
            [0, 0, h, h, h, h, h, 0],
            [0, 0,15,15,15,15, 0, 0],
            [0,15, 1,15,15, 1,15, 0],
            [0, 0,15,15,15,15, 0, 0],
            [0, 0,15,14,14,15, 0, 0],
            [0, s, s, s, s, s, s, 0],
            [15, s, s, s, s, s, s,15],
            [0, 0, s, s, s, s, 0, 0],
            [0, 0, 1, 1, 1, 1, 0, 0],
            [0, 0, 0, 4, 4, 0, 0, 0],
            [0, 0, 0, 4, 4, 0, 0, 0],
        ]

        switch frame {
        case 1: return texture(from: walk1)
        case 2: return texture(from: walk2)
        default: return texture(from: standing)
        }
    }

    /// Available color options for customization (palette indices)
    static let customizableColors: [(name: String, index: Int)] = [
        ("Red", 8), ("Orange", 9), ("Yellow", 10), ("Green", 11),
        ("Blue", 12), ("Indigo", 13), ("Pink", 14), ("Brown", 4),
        ("Dark Green", 3), ("White", 7),
    ]

    // MARK: - NPC Character (8x12)

    static func npcTexture(shirtColor: Int = 11, hatColor: Int = 10) -> SKTexture {
        let s = shirtColor
        let h = hatColor
        let pixels: [[Int]] = [
            [0, 0, 0, h, h, h, 0, 0],
            [0, 0, h, h, h, h, h, 0],
            [0, 0,15,15,15,15, 0, 0],
            [0,15, 1,15,15, 1,15, 0],
            [0, 0,15,15,15,15, 0, 0],
            [0, 0,15,14,14,15, 0, 0],
            [0, s, s, s, s, s, s, 0],
            [15, s, s, s, s, s, s,15],
            [0, 0, s, s, s, s, 0, 0],
            [0, 0, 1, 1, 1, 1, 0, 0],
            [0, 0, 1, 0, 0, 1, 0, 0],
            [0, 0, 4, 0, 0, 4, 0, 0],
        ]
        return texture(from: pixels)
    }

    // MARK: - Buildings (16x16)

    static func buildingTexture(roofColor: Int, wallColor: Int = 7) -> SKTexture {
        let r = roofColor
        let w = wallColor
        let pixels: [[Int]] = [
            [0, 0, 0, 0, 0, 0, r, r, r, r, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, r, r, r, r, r, r, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, r, r, r, r, r, r, r, r, 0, 0, 0, 0],
            [0, 0, 0, r, r, r, r, r, r, r, r, r, r, 0, 0, 0],
            [0, 0, r, r, r, r, r, r, r, r, r, r, r, r, 0, 0],
            [0, 1, r, r, r, r, r, r, r, r, r, r, r, r, 1, 0],
            [0, 1, w, w, w, w, w, w, w, w, w, w, w, w, 1, 0],
            [0, 1, w, w,12,12, w, w, w,12,12, w, w, w, 1, 0],
            [0, 1, w, w,12,12, w, w, w,12,12, w, w, w, 1, 0],
            [0, 1, w, w, w, w, w, w, w, w, w, w, w, w, 1, 0],
            [0, 1, w, w, w, w, w, 4, 4, w, w, w, w, w, 1, 0],
            [0, 1, w, w, w, w, w, 4, 4, w, w, w, w, w, 1, 0],
            [0, 1, w, w, w, w, w, 4, 4, w, w, w, w, w, 1, 0],
            [0, 1, w, w, w, w, w, 4, 4, w, w, w, w, w, 1, 0],
            [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        ]
        return texture(from: pixels)
    }

    static func homeTexture() -> SKTexture {
        buildingTexture(roofColor: 4, wallColor: 15)
    }

    static func buildingTexture(for eventType: EventType) -> SKTexture {
        buildingTexture(roofColor: eventType.roofColorIndex)
    }

    // MARK: - Decorations

    static func treeTexture() -> SKTexture {
        let pixels: [[Int]] = [
            [0, 0, 0, 3, 3, 0, 0, 0],
            [0, 0, 3,11, 3, 3, 0, 0],
            [0, 3,11,11,11, 3, 0, 0],
            [0, 3,11, 3,11,11, 3, 0],
            [3,11,11,11,11,11, 3, 0],
            [3,11, 3,11, 3,11, 3, 0],
            [3,11,11,11,11,11, 3, 0],
            [0, 3, 3,11, 3, 3, 0, 0],
            [0, 0, 0, 4, 4, 0, 0, 0],
            [0, 0, 0, 4, 4, 0, 0, 0],
            [0, 0, 0, 4, 4, 0, 0, 0],
            [0, 0, 4, 4, 4, 4, 0, 0],
        ]
        return texture(from: pixels)
    }

    static func flowerTexture(color: Int = 8) -> SKTexture {
        let c = color
        let pixels: [[Int]] = [
            [0, c, 0],
            [c,10, c],
            [0, c, 0],
            [0, 3, 0],
            [0, 3, 0],
        ]
        return texture(from: pixels)
    }

    static func bushTexture() -> SKTexture {
        let pixels: [[Int]] = [
            [0, 0, 3, 3, 3, 0, 0],
            [0, 3,11,11,11, 3, 0],
            [3,11, 3,11, 3,11, 3],
            [3,11,11,11,11,11, 3],
            [0, 3, 3, 3, 3, 3, 0],
        ]
        return texture(from: pixels)
    }

    // MARK: - Ambient

    static func cloudTexture() -> SKTexture {
        let pixels: [[Int]] = [
            [0, 0, 0, 0, 7, 7, 7, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 7, 7, 7, 7, 7, 0, 0, 7, 7, 0, 0],
            [0, 0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0],
            [0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7],
            [7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7],
            [0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0],
        ]
        return texture(from: pixels)
    }

    static func heartTexture() -> SKTexture {
        let pixels: [[Int]] = [
            [0, 8, 0, 0, 8, 0],
            [8, 8, 8, 8, 8, 8],
            [8, 8, 8, 8, 8, 8],
            [0, 8, 8, 8, 8, 0],
            [0, 0, 8, 8, 0, 0],
            [0, 0, 0, 0, 0, 0],
        ]
        return texture(from: pixels)
    }

    static func starParticleTexture() -> SKTexture {
        let pixels: [[Int]] = [
            [0, 0,10, 0, 0],
            [0,10,10,10, 0],
            [10,10,10,10,10],
            [0,10,10,10, 0],
            [0, 0,10, 0, 0],
        ]
        return texture(from: pixels)
    }

    // MARK: - UI Elements

    static func markerTexture() -> SKTexture {
        let pixels: [[Int]] = [
            [0, 0, 0,10,10, 0, 0, 0],
            [0, 0,10,10,10,10, 0, 0],
            [0,10,10,10,10,10,10, 0],
            [10,10,10,10,10,10,10,10],
            [0, 0,10,10,10,10, 0, 0],
            [0, 0,10,10,10,10, 0, 0],
            [0, 0,10,10,10,10, 0, 0],
            [0, 0, 0,10,10, 0, 0, 0],
        ]
        return texture(from: pixels)
    }

    static func checkmarkTexture() -> SKTexture {
        let pixels: [[Int]] = [
            [0, 0, 0, 0, 0, 0, 0,11],
            [0, 0, 0, 0, 0, 0,11,11],
            [0, 0, 0, 0, 0,11,11, 0],
            [11, 0, 0, 0,11,11, 0, 0],
            [11,11, 0,11,11, 0, 0, 0],
            [0,11,11,11, 0, 0, 0, 0],
            [0, 0,11, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
        ]
        return texture(from: pixels)
    }
}
