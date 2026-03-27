import SpriteKit

struct SpriteFactory {
    static let pixelSize: CGFloat = 3.0

    // Sweetie 16 palette — warmer, more charming tones
    static let palette: [UIColor] = [
        .clear,                                                     // 0: transparent
        UIColor(red: 0.10, green: 0.11, blue: 0.17, alpha: 1),     // 1: #1a1c2c deep navy
        UIColor(red: 0.36, green: 0.15, blue: 0.36, alpha: 1),     // 2: #5d275d dark plum
        UIColor(red: 0.15, green: 0.44, blue: 0.47, alpha: 1),     // 3: #257179 dark teal
        UIColor(red: 0.54, green: 0.31, blue: 0.24, alpha: 1),     // 4: #8a503d warm brown
        UIColor(red: 0.34, green: 0.42, blue: 0.53, alpha: 1),     // 5: #566c86 steel gray
        UIColor(red: 0.58, green: 0.69, blue: 0.76, alpha: 1),     // 6: #94b0c2 soft gray
        UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1),     // 7: #f4f4f4 warm white
        UIColor(red: 0.69, green: 0.24, blue: 0.33, alpha: 1),     // 8: #b13e53 crimson
        UIColor(red: 0.94, green: 0.49, blue: 0.34, alpha: 1),     // 9: #ef7d57 warm orange
        UIColor(red: 1.00, green: 0.80, blue: 0.46, alpha: 1),     // 10: #ffcd75 gold
        UIColor(red: 0.22, green: 0.72, blue: 0.39, alpha: 1),     // 11: #38b764 lush green
        UIColor(red: 0.23, green: 0.36, blue: 0.79, alpha: 1),     // 12: #3b5dc9 royal blue
        UIColor(red: 0.16, green: 0.21, blue: 0.44, alpha: 1),     // 13: #29366f deep blue
        UIColor(red: 0.94, green: 0.51, blue: 0.63, alpha: 1),     // 14: #f082a1 rose pink
        UIColor(red: 0.87, green: 0.74, blue: 0.60, alpha: 1),     // 15: #debc9a warm skin
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

    // MARK: - Player Character (16x24) — Stardew-style chibi proportions

    static func playerTexture(frame: Int = 0, hat: Int = 8, shirt: Int = 12) -> SKTexture {
        let h = hat, s = shirt
        let k = 15  // skin
        let b = 4   // skin outline (warm brown — colored outline, not black!)
        let m = 14  // mouth (rose pink)
        let p = 5   // pants (steel gray)
        let f = 4   // boots (warm brown)

        let standing: [[Int]] = [
            [0,0,0,0,0,0,h,h,h,h,0,0,0,0,0,0],
            [0,0,0,0,0,h,h,h,h,h,h,0,0,0,0,0],
            [0,0,0,0,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,h,h,h,h,h,h,h,h,h,h,0,0,0],
            [0,0,1,h,h,h,h,h,h,h,h,h,h,1,0,0],
            [0,0,b,k,k,k,k,k,k,k,k,k,k,b,0,0],
            [0,0,b,k,k,k,k,k,k,k,k,k,k,b,0,0],
            [0,0,b,k,7,1,k,k,k,k,1,7,k,b,0,0],
            [0,0,b,k,k,k,k,k,k,k,k,k,k,b,0,0],
            [0,0,0,b,k,k,k,m,m,k,k,k,b,0,0,0],
            [0,0,0,0,b,k,k,k,k,k,k,b,0,0,0,0],
            [0,0,0,0,0,b,k,k,k,k,b,0,0,0,0,0],
            [0,0,0,0,s,s,s,s,s,s,s,s,0,0,0,0],
            [0,0,0,s,s,s,s,s,s,s,s,s,s,0,0,0],
            [0,0,k,s,s,s,s,s,s,s,s,s,s,k,0,0],
            [0,0,k,s,s,s,s,s,s,s,s,s,s,k,0,0],
            [0,0,0,s,s,s,s,s,s,s,s,s,s,0,0,0],
            [0,0,0,0,s,s,s,s,s,s,s,s,0,0,0,0],
            [0,0,0,0,1,p,p,p,p,p,p,1,0,0,0,0],
            [0,0,0,0,1,p,p,0,0,p,p,1,0,0,0,0],
            [0,0,0,0,1,p,p,0,0,p,p,1,0,0,0,0],
            [0,0,0,0,f,f,f,0,0,f,f,f,0,0,0,0],
            [0,0,0,f,f,f,f,0,0,f,f,f,f,0,0,0],
            [0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0],
        ]

        let walk1: [[Int]] = [
            [0,0,0,0,0,0,h,h,h,h,0,0,0,0,0,0],
            [0,0,0,0,0,h,h,h,h,h,h,0,0,0,0,0],
            [0,0,0,0,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,h,h,h,h,h,h,h,h,h,h,0,0,0],
            [0,0,1,h,h,h,h,h,h,h,h,h,h,1,0,0],
            [0,0,b,k,k,k,k,k,k,k,k,k,k,b,0,0],
            [0,0,b,k,k,k,k,k,k,k,k,k,k,b,0,0],
            [0,0,b,k,7,1,k,k,k,k,1,7,k,b,0,0],
            [0,0,b,k,k,k,k,k,k,k,k,k,k,b,0,0],
            [0,0,0,b,k,k,k,m,m,k,k,k,b,0,0,0],
            [0,0,0,0,b,k,k,k,k,k,k,b,0,0,0,0],
            [0,0,0,0,0,b,k,k,k,k,b,0,0,0,0,0],
            [0,0,0,0,s,s,s,s,s,s,s,s,0,0,0,0],
            [0,0,0,s,s,s,s,s,s,s,s,s,s,0,0,0],
            [0,0,k,s,s,s,s,s,s,s,s,s,s,k,0,0],
            [0,0,k,s,s,s,s,s,s,s,s,s,s,k,0,0],
            [0,0,0,s,s,s,s,s,s,s,s,s,s,0,0,0],
            [0,0,0,0,s,s,s,s,s,s,s,s,0,0,0,0],
            [0,0,0,0,1,p,p,p,p,p,p,1,0,0,0,0],
            [0,0,0,p,p,1,0,0,0,0,1,p,p,0,0,0],
            [0,0,f,f,1,0,0,0,0,0,0,1,p,p,0,0],
            [0,f,f,f,0,0,0,0,0,0,0,0,f,f,0,0],
            [0,1,1,1,0,0,0,0,0,0,0,f,f,f,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0],
        ]

        let walk2: [[Int]] = [
            [0,0,0,0,0,0,h,h,h,h,0,0,0,0,0,0],
            [0,0,0,0,0,h,h,h,h,h,h,0,0,0,0,0],
            [0,0,0,0,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,h,h,h,h,h,h,h,h,h,h,0,0,0],
            [0,0,1,h,h,h,h,h,h,h,h,h,h,1,0,0],
            [0,0,b,k,k,k,k,k,k,k,k,k,k,b,0,0],
            [0,0,b,k,k,k,k,k,k,k,k,k,k,b,0,0],
            [0,0,b,k,7,1,k,k,k,k,1,7,k,b,0,0],
            [0,0,b,k,k,k,k,k,k,k,k,k,k,b,0,0],
            [0,0,0,b,k,k,k,m,m,k,k,k,b,0,0,0],
            [0,0,0,0,b,k,k,k,k,k,k,b,0,0,0,0],
            [0,0,0,0,0,b,k,k,k,k,b,0,0,0,0,0],
            [0,0,0,0,s,s,s,s,s,s,s,s,0,0,0,0],
            [0,0,0,s,s,s,s,s,s,s,s,s,s,0,0,0],
            [0,0,k,s,s,s,s,s,s,s,s,s,s,k,0,0],
            [0,0,k,s,s,s,s,s,s,s,s,s,s,k,0,0],
            [0,0,0,s,s,s,s,s,s,s,s,s,s,0,0,0],
            [0,0,0,0,s,s,s,s,s,s,s,s,0,0,0,0],
            [0,0,0,0,1,p,p,p,p,p,p,1,0,0,0,0],
            [0,0,0,0,0,p,p,0,0,p,p,0,0,0,0,0],
            [0,0,0,0,0,f,f,0,0,f,f,0,0,0,0,0],
            [0,0,0,0,0,f,f,0,0,f,f,0,0,0,0,0],
            [0,0,0,0,f,f,f,0,0,f,f,f,0,0,0,0],
            [0,0,0,0,1,1,1,0,0,1,1,1,0,0,0,0],
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
        ("Dark Teal", 3), ("White", 7),
    ]

    // MARK: - NPC Character (16x24)

    static func npcTexture(shirtColor: Int = 11, hatColor: Int = 10) -> SKTexture {
        let s = shirtColor, h = hatColor
        let k = 15, b = 4, m = 14, p = 5, f = 4
        let pixels: [[Int]] = [
            [0,0,0,0,0,0,h,h,h,h,0,0,0,0,0,0],
            [0,0,0,0,0,h,h,h,h,h,h,0,0,0,0,0],
            [0,0,0,0,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,h,h,h,h,h,h,h,h,h,h,0,0,0],
            [0,0,1,h,h,h,h,h,h,h,h,h,h,1,0,0],
            [0,0,b,k,k,k,k,k,k,k,k,k,k,b,0,0],
            [0,0,b,k,k,k,k,k,k,k,k,k,k,b,0,0],
            [0,0,b,k,7,1,k,k,k,k,1,7,k,b,0,0],
            [0,0,b,k,k,k,k,k,k,k,k,k,k,b,0,0],
            [0,0,0,b,k,k,k,m,m,k,k,k,b,0,0,0],
            [0,0,0,0,b,k,k,k,k,k,k,b,0,0,0,0],
            [0,0,0,0,0,b,k,k,k,k,b,0,0,0,0,0],
            [0,0,0,0,s,s,s,s,s,s,s,s,0,0,0,0],
            [0,0,0,s,s,s,s,s,s,s,s,s,s,0,0,0],
            [0,0,k,s,s,s,s,s,s,s,s,s,s,k,0,0],
            [0,0,k,s,s,s,s,s,s,s,s,s,s,k,0,0],
            [0,0,0,s,s,s,s,s,s,s,s,s,s,0,0,0],
            [0,0,0,0,s,s,s,s,s,s,s,s,0,0,0,0],
            [0,0,0,0,1,p,p,p,p,p,p,1,0,0,0,0],
            [0,0,0,0,1,p,p,0,0,p,p,1,0,0,0,0],
            [0,0,0,0,1,p,p,0,0,p,p,1,0,0,0,0],
            [0,0,0,0,f,f,f,0,0,f,f,f,0,0,0,0],
            [0,0,0,f,f,f,f,0,0,f,f,f,f,0,0,0],
            [0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0],
        ]
        return texture(from: pixels)
    }

    // MARK: - Buildings (16x16) — colored outlines

    static func buildingTexture(roofColor: Int, wallColor: Int = 7) -> SKTexture {
        let r = roofColor
        let w = wallColor
        let o = 5   // wall outline: steel gray (colored, not black!)
        let pixels: [[Int]] = [
            [0, 0, 0, 0, 0, 0, r, r, r, r, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, r, r, r, r, r, r, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, r, r, r, r, r, r, r, r, 0, 0, 0, 0],
            [0, 0, 0, r, r, r, r, r, r, r, r, r, r, 0, 0, 0],
            [0, 0, r, r, r, r, r, r, r, r, r, r, r, r, 0, 0],
            [0, o, r, r, r, r, r, r, r, r, r, r, r, r, o, 0],
            [0, o, w, w, w, w, w, w, w, w, w, w, w, w, o, 0],
            [0, o, w, w,13,13, w, w, w,13,13, w, w, w, o, 0],
            [0, o, w, w,13,13, w, w, w,13,13, w, w, w, o, 0],
            [0, o, w, w, w, w, w, w, w, w, w, w, w, w, o, 0],
            [0, o, w, w, w, w, w, 4, 4, w, w, w, w, w, o, 0],
            [0, o, w, w, w, w, w, 4, 4, w, w, w, w, w, o, 0],
            [0, o, w, w, w, w, w, 4, 4, w, w, w, w, w, o, 0],
            [0, o, w, w, w, w, w, 4, 4, w, w, w, w, w, o, 0],
            [0, o, o, o, o, o, o, o, o, o, o, o, o, o, o, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        ]
        return texture(from: pixels)
    }

    static func homeTexture() -> SKTexture {
        // Home with chimney
        let r = 4   // brown roof
        let w = 15  // warm skin walls (cozy!)
        let o = 5
        let pixels: [[Int]] = [
            [0, 0, 0, 0, 0, 0, r, r, r, r, 0, 4, 4, 0, 0, 0],
            [0, 0, 0, 0, 0, r, r, r, r, r, r, 4, 4, 0, 0, 0],
            [0, 0, 0, 0, r, r, r, r, r, r, r, r, 4, 0, 0, 0],
            [0, 0, 0, r, r, r, r, r, r, r, r, r, r, 0, 0, 0],
            [0, 0, r, r, r, r, r, r, r, r, r, r, r, r, 0, 0],
            [0, o, r, r, r, r, r, r, r, r, r, r, r, r, o, 0],
            [0, o, w, w, w, w, w, w, w, w, w, w, w, w, o, 0],
            [0, o, w, w,13,13, w, w, w,13,13, w, w, w, o, 0],
            [0, o, w, w,13,13, w, w, w,13,13, w, w, w, o, 0],
            [0, o, w, w, w, w, w, w, w, w, w, w, w, w, o, 0],
            [0, o, w, w, w, w, w, 4, 4, w, w, w, w, w, o, 0],
            [0, o, w, w, w, w, w, 4, 4, w, w, w, w, w, o, 0],
            [0, o, w, w, w, w, w, 4, 4, w, w, w, w, w, o, 0],
            [0, o, w, w, w, w, w, 4, 4, w, w, w, w, w, o, 0],
            [0, o, o, o, o, o, o, o, o, o, o, o, o, o, o, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        ]
        return texture(from: pixels)
    }

    static func buildingTexture(for eventType: EventType) -> SKTexture {
        buildingTexture(roofColor: eventType.roofColorIndex)
    }

    // MARK: - Decorations

    static func treeTexture() -> SKTexture {
        let d = 3   // dark teal (shadow leaves)
        let g = 11  // lush green (lit leaves)
        let t = 4   // trunk (warm brown)
        let pixels: [[Int]] = [
            [0, 0, 0, d, d, 0, 0, 0],
            [0, 0, d, g, d, d, 0, 0],
            [0, d, g, g, g, d, 0, 0],
            [0, d, g, d, g, g, d, 0],
            [d, g, g, g, g, g, d, 0],
            [d, g, d, g, d, g, d, 0],
            [d, g, g, g, g, g, d, 0],
            [0, d, d, g, d, d, 0, 0],
            [0, 0, 0, t, t, 0, 0, 0],
            [0, 0, 0, t, t, 0, 0, 0],
            [0, 0, 0, t, t, 0, 0, 0],
            [0, 0, t, t, t, t, 0, 0],
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

    static func butterflyTexture(color: Int = 14) -> SKTexture {
        let c = color
        let pixels: [[Int]] = [
            [c, 0, 0, 0, c],
            [c, c, 1, c, c],
            [0, c, 1, c, 0],
            [c, c, 1, c, c],
            [c, 0, 0, 0, c],
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
