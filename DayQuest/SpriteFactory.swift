import SpriteKit

struct SpriteFactory {
    static let pixelSize: CGFloat = 2.0

    // Sweetie 16 palette + extended warm/bright colors + depth shading colors
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
        // Extended palette for Pokemon GBC richness
        UIColor(red: 0.60, green: 0.82, blue: 0.95, alpha: 1),     // 16: light sky blue
        UIColor(red: 0.55, green: 0.88, blue: 0.50, alpha: 1),     // 17: bright leaf green
        UIColor(red: 0.96, green: 0.75, blue: 0.65, alpha: 1),     // 18: peach/apricot
        UIColor(red: 0.72, green: 0.58, blue: 0.88, alpha: 1),     // 19: lavender
        UIColor(red: 0.95, green: 0.92, blue: 0.84, alpha: 1),     // 20: cream/ivory
        UIColor(red: 0.36, green: 0.22, blue: 0.15, alpha: 1),     // 21: dark brown
        UIColor(red: 0.12, green: 0.38, blue: 0.28, alpha: 1),     // 22: dark green
        UIColor(red: 1.00, green: 0.90, blue: 0.55, alpha: 1),     // 23: light gold
        // Depth/shading colors
        UIColor(red: 0.42, green: 0.30, blue: 0.24, alpha: 1),     // 24: dark roof shadow
        UIColor(red: 0.70, green: 0.95, blue: 0.62, alpha: 1),     // 25: light green highlight
        UIColor(red: 0.75, green: 0.90, blue: 1.00, alpha: 1),     // 26: window reflection blue
        // New axonometric depth colors
        UIColor(red: 0.08, green: 0.09, blue: 0.18, alpha: 0.35),  // 27: cast shadow (semi-transparent dark)
        UIColor(red: 0.82, green: 0.78, blue: 0.70, alpha: 1),     // 28: wall shadow (darker cream for side faces)
        UIColor(red: 0.36, green: 0.24, blue: 0.18, alpha: 1),     // 29: roof shadow dark (darker roof for left edge)
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

    // MARK: - Player Character (24x24) — Pokemon FRLG squat 3/4 view with depth

    static func playerTexture(frame: Int = 0, hat: Int = 8, shirt: Int = 12) -> SKTexture {
        let h = hat, s = shirt
        let k = 15  // skin
        let b = 4   // skin outline (warm brown)
        let m = 14  // mouth (rose pink)
        let p = 5   // pants (steel gray)
        let f = 21  // shoes (dark brown)
        let e = 18  // blush/ear accent (peach)
        let w = 7   // eye highlight (white)
        let hd = 29 // hat shadow (dark left side)
        let sd = 13 // shirt shadow (deep blue, right side)
        let sh = 27 // cast shadow on ground

        // Standing: squat 3/4 view, top of hat visible, cast shadow
        // Head rows 1-12, body rows 13-20, shadow rows 21-22
        let standing: [[Int]] = [
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,hd,hd,h,h,h,h,h,h,h,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,hd,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0,0,0],
            [0,0,0,0,0,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0,0],
            [0,0,0,0,hd,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,0,hd,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,0,hd,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,0,b,b,b,k,k,k,k,k,k,k,k,k,k,b,b,b,0,0,0,0],
            [0,0,0,0,b,k,k,k,k,k,k,k,k,k,k,k,k,k,k,b,0,0,0,0],
            [0,0,0,0,b,k,k,1,1,1,k,k,k,k,1,1,1,k,k,b,0,0,0,0],
            [0,0,0,0,b,k,k,1,w,1,k,k,k,k,1,w,1,k,k,b,0,0,0,0],
            [0,0,0,0,b,e,k,k,k,k,k,k,k,k,k,k,k,k,e,b,0,0,0,0],
            [0,0,0,0,0,b,k,k,k,k,k,m,m,k,k,k,k,k,b,0,0,0,0,0],
            [0,0,0,0,0,0,b,b,k,k,k,k,k,k,k,k,b,b,0,0,0,0,0,0],
            [0,0,0,0,0,0,s,s,s,s,s,s,s,s,s,s,s,s,0,0,0,0,0,0],
            [0,0,0,0,0,s,s,s,s,s,s,s,s,s,s,s,s,sd,sd,0,0,0,0,0],
            [0,0,0,0,k,s,s,s,s,s,s,s,s,s,s,s,sd,sd,k,k,0,0,0,0],
            [0,0,0,0,k,k,s,s,s,s,s,s,s,s,s,sd,sd,s,k,k,0,0,0,0],
            [0,0,0,0,0,0,s,s,s,s,s,s,s,s,s,s,s,s,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,p,p,p,p,0,0,p,p,p,p,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,p,p,p,p,0,0,p,p,p,p,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,f,f,f,f,f,0,0,f,f,f,f,f,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,0,0,0,0],
        ]

        // Walk frame 1: left leg forward, cast shadow shifts
        let walk1: [[Int]] = [
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,hd,hd,h,h,h,h,h,h,h,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,hd,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0,0,0],
            [0,0,0,0,0,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0,0],
            [0,0,0,0,hd,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,0,hd,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,0,hd,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,0,b,b,b,k,k,k,k,k,k,k,k,k,k,b,b,b,0,0,0,0],
            [0,0,0,0,b,k,k,k,k,k,k,k,k,k,k,k,k,k,k,b,0,0,0,0],
            [0,0,0,0,b,k,k,1,1,1,k,k,k,k,1,1,1,k,k,b,0,0,0,0],
            [0,0,0,0,b,k,k,1,w,1,k,k,k,k,1,w,1,k,k,b,0,0,0,0],
            [0,0,0,0,b,e,k,k,k,k,k,k,k,k,k,k,k,k,e,b,0,0,0,0],
            [0,0,0,0,0,b,k,k,k,k,k,m,m,k,k,k,k,k,b,0,0,0,0,0],
            [0,0,0,0,0,0,b,b,k,k,k,k,k,k,k,k,b,b,0,0,0,0,0,0],
            [0,0,0,0,0,0,s,s,s,s,s,s,s,s,s,s,s,s,0,0,0,0,0,0],
            [0,0,0,0,0,s,s,s,s,s,s,s,s,s,s,s,s,sd,sd,0,0,0,0,0],
            [0,0,0,0,k,s,s,s,s,s,s,s,s,s,s,s,sd,sd,k,k,0,0,0,0],
            [0,0,0,0,k,k,s,s,s,s,s,s,s,s,s,sd,sd,s,k,k,0,0,0,0],
            [0,0,0,0,0,0,s,s,s,s,s,s,s,s,s,s,s,s,0,0,0,0,0,0],
            [0,0,0,0,0,p,p,p,p,0,0,0,0,0,p,p,p,0,0,0,0,0,0,0],
            [0,0,0,0,p,p,p,0,0,0,0,0,0,0,0,p,p,p,0,0,0,0,0,0],
            [0,0,0,f,f,f,f,0,0,0,0,0,0,0,0,f,f,f,f,0,0,0,0,0],
            [0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,0,0,0,0],
        ]

        // Walk frame 2: right leg forward, cast shadow shifts
        let walk2: [[Int]] = [
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,hd,hd,h,h,h,h,h,h,h,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,hd,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0,0,0],
            [0,0,0,0,0,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0,0],
            [0,0,0,0,hd,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,0,hd,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,0,hd,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,0,b,b,b,k,k,k,k,k,k,k,k,k,k,b,b,b,0,0,0,0],
            [0,0,0,0,b,k,k,k,k,k,k,k,k,k,k,k,k,k,k,b,0,0,0,0],
            [0,0,0,0,b,k,k,1,1,1,k,k,k,k,1,1,1,k,k,b,0,0,0,0],
            [0,0,0,0,b,k,k,1,w,1,k,k,k,k,1,w,1,k,k,b,0,0,0,0],
            [0,0,0,0,b,e,k,k,k,k,k,k,k,k,k,k,k,k,e,b,0,0,0,0],
            [0,0,0,0,0,b,k,k,k,k,k,m,m,k,k,k,k,k,b,0,0,0,0,0],
            [0,0,0,0,0,0,b,b,k,k,k,k,k,k,k,k,b,b,0,0,0,0,0,0],
            [0,0,0,0,0,0,s,s,s,s,s,s,s,s,s,s,s,s,0,0,0,0,0,0],
            [0,0,0,0,0,s,s,s,s,s,s,s,s,s,s,s,s,sd,sd,0,0,0,0,0],
            [0,0,0,0,k,s,s,s,s,s,s,s,s,s,s,s,sd,sd,k,k,0,0,0,0],
            [0,0,0,0,k,k,s,s,s,s,s,s,s,s,s,sd,sd,s,k,k,0,0,0,0],
            [0,0,0,0,0,0,s,s,s,s,s,s,s,s,s,s,s,s,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,p,p,p,0,0,0,0,0,p,p,p,p,0,0,0,0,0],
            [0,0,0,0,0,0,p,p,p,0,0,0,0,0,0,0,p,p,p,0,0,0,0,0],
            [0,0,0,0,0,f,f,f,f,0,0,0,0,0,0,0,f,f,f,f,0,0,0,0],
            [0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,0,0,0,0],
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

    // MARK: - NPC Character (24x24)

    static func npcTexture(shirtColor: Int = 11, hatColor: Int = 10) -> SKTexture {
        let s = shirtColor, h = hatColor
        let k = 15, b = 4, m = 14, p = 5, f = 21
        let e = 18, w = 7
        let hd = 29 // hat shadow (dark left side)
        let sd = 3  // shirt shadow (dark teal for NPC distinction, right side)
        let sh = 27 // cast shadow

        let pixels: [[Int]] = [
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,hd,hd,h,h,h,h,h,h,h,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,hd,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0,0,0],
            [0,0,0,0,0,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0,0],
            [0,0,0,0,hd,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,0,hd,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,0,hd,hd,h,h,h,h,h,h,h,h,h,h,h,h,h,h,0,0,0,0],
            [0,0,0,0,b,b,b,k,k,k,k,k,k,k,k,k,k,b,b,b,0,0,0,0],
            [0,0,0,0,b,k,k,k,k,k,k,k,k,k,k,k,k,k,k,b,0,0,0,0],
            [0,0,0,0,b,k,k,1,1,1,k,k,k,k,1,1,1,k,k,b,0,0,0,0],
            [0,0,0,0,b,k,k,1,w,1,k,k,k,k,1,w,1,k,k,b,0,0,0,0],
            [0,0,0,0,b,e,k,k,k,k,k,k,k,k,k,k,k,k,e,b,0,0,0,0],
            [0,0,0,0,0,b,k,k,k,k,k,m,m,k,k,k,k,k,b,0,0,0,0,0],
            [0,0,0,0,0,0,b,b,k,k,k,k,k,k,k,k,b,b,0,0,0,0,0,0],
            [0,0,0,0,0,0,s,s,s,s,s,s,s,s,s,s,s,s,0,0,0,0,0,0],
            [0,0,0,0,0,s,s,s,s,s,s,s,s,s,s,s,s,sd,sd,0,0,0,0,0],
            [0,0,0,0,k,s,s,s,s,s,s,s,s,s,s,s,sd,sd,k,k,0,0,0,0],
            [0,0,0,0,k,k,s,s,s,s,s,s,s,s,s,sd,sd,s,k,k,0,0,0,0],
            [0,0,0,0,0,0,s,s,s,s,s,s,s,s,s,s,s,s,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,p,p,p,p,0,0,p,p,p,p,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,p,p,p,p,0,0,p,p,p,p,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,f,f,f,f,f,0,0,f,f,f,f,f,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh,0,0,0,0],
        ]
        return texture(from: pixels)
    }

    // MARK: - Buildings (40x40) — Axonometric 3/4 view: top + front + right side

    static func buildingTexture(roofColor: Int, wallColor: Int = 7) -> SKTexture {
        let r = roofColor
        let rs = 24 // roof shadow (right edge of top face, slightly darker)
        let rl = 29 // roof left-edge shadow
        let c = 20  // cream front wall (medium brightness)
        let cw = 28 // side wall (darker cream, right face)
        let cs = 5  // side wall darkest edge
        let o = 5   // outline (steel gray)
        let wb = 26 // window glass (reflection blue)
        let wd = 13 // window divider (deep blue)
        let g = 23  // window glow (light gold)
        let d = 21  // door (dark brown)
        let dn = 4  // door frame (warm brown)
        let aw = 9  // awning (warm orange)
        let fn = 5  // foundation (steel gray)
        let sh = 27 // cast shadow

        //  40 wide x 40 tall
        //  Rows 0-1: empty above roof
        //  Rows 2-10: TOP face (roof parallelogram, ~9 rows)
        //  Rows 11-12: roof overhang / eave line
        //  Rows 13-35: FRONT face (main wall) with RIGHT SIDE face (6px strip on right)
        //  Rows 36-37: foundation
        //  Rows 38-39: cast shadow extending bottom-right
        let pixels: [[Int]] = [
            // Row 0: empty
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            // Row 1: empty
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            // Row 2: top of roof (narrow peak, shifted right for perspective)
            [0,0,0,0,0,0,0,0,0,0,0,0,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,0,0,0,0,0,0,0],
            // Row 3: roof widens
            [0,0,0,0,0,0,0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,rs,0,0,0,0,0,0],
            // Row 4
            [0,0,0,0,0,0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,rs,0,0,0,0,0],
            // Row 5
            [0,0,0,0,0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,rs,0,0,0,0],
            // Row 6
            [0,0,0,0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,rs,0,0,0],
            // Row 7
            [0,0,0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,rs,0,0],
            // Row 8
            [0,0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,rs,0],
            // Row 9: roof widest
            [0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,rs],
            // Row 10: roof bottom edge / eave
            [0,0,0,0,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o],
            // Row 11: eave overhang shadow line
            [0,0,0,0,o,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,o,cs,cs,cs,cs,cs,o],
            // Row 12: front wall starts + right side face starts
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 13: wall
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 14: upper windows row top
            [0,0,0,0,o,c,c,wd,wb,26,wb,wd,c,c,c,c,c,c,c,c,wd,wb,26,wb,wd,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 15: upper windows
            [0,0,0,0,o,c,c,wd,wb,wb,wb,wd,c,c,c,c,c,c,c,c,wd,wb,wb,wb,wd,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 16: window cross-pane
            [0,0,0,0,o,c,c,wd,wd,wd,wd,wd,c,c,c,c,c,c,c,c,wd,wd,wd,wd,wd,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 17: lower pane
            [0,0,0,0,o,c,c,wd,wb,wb,wb,wd,c,c,c,c,c,c,c,c,wd,wb,wb,wb,wd,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 18: window bottom + glow
            [0,0,0,0,o,c,c,wd,wb,g,wb,wd,c,c,c,c,c,c,c,c,wd,wb,g,wb,wd,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 19: below windows
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 20: awning top
            [0,0,0,0,o,c,c,c,c,c,c,c,aw,aw,aw,aw,aw,aw,aw,aw,aw,aw,aw,aw,aw,aw,aw,aw,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 21: awning bottom slope
            [0,0,0,0,o,c,c,c,c,c,c,c,c,aw,c,c,c,c,c,c,c,c,c,c,c,c,aw,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 22: flower boxes
            [0,0,0,0,o,c,c,11,17,17,11,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,11,17,17,11,c,o,cw,cw,cw,cw,cw,o],
            // Row 23: blank wall
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 24: door frame top
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,dn,dn,dn,dn,dn,dn,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 25: door top
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,d,d,d,d,d,d,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 26: door with window
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,d,g,g,g,g,d,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 27: door body
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,d,d,d,d,d,d,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 28: door body
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,d,d,d,d,d,d,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 29: door lower window
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,d,g,g,g,g,d,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 30: door bottom
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,d,d,d,d,d,d,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 31: door frame bottom
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,dn,dn,dn,dn,dn,dn,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 32: wall
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 33: wall
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 34: foundation top
            [0,0,0,0,o,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,o,cs,cs,cs,cs,cs,o],
            // Row 35: foundation bottom / outline
            [0,0,0,0,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o],
            // Row 36: cast shadow row 1
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh],
            // Row 37: cast shadow row 2
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,sh,sh],
            // Row 38: cast shadow row 3 (fading)
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,0],
            // Row 39: empty
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        ]
        return texture(from: pixels)
    }

    static func homeTexture() -> SKTexture {
        // Home with chimney — cozy Pokemon-style house, axonometric 3/4 view
        // 40x40: top face (roof) + front face + right side face + cast shadow
        let r = 9   // warm orange roof (top face, brightest)
        let rs = 24 // roof right-edge shadow
        let rl = 29 // roof left-edge shadow (darkest)
        let c = 20  // cream front wall
        let cw = 28 // side wall (darker cream, right face)
        let cs = 5  // side wall darkest edge
        let o = 5   // outline (steel gray)
        let wb = 26 // window glass
        let wd = 13 // window divider
        let g = 23  // window glow (gold/amber)
        let d = 21  // door (dark brown)
        let dn = 4  // door frame
        let ch = 4  // chimney
        let chd = 21 // chimney dark
        let sm = 6  // smoke
        let fl = 8  // flower red
        let fn = 5  // foundation
        let sh = 27 // cast shadow

        let pixels: [[Int]] = [
            // Row 0: smoke wisps above chimney
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,sm,0,0,0,0,0,0,0,0,0,0,0,0,0],
            // Row 1: smoke + chimney top
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,sm,ch,chd,sm,0,0,0,0,0,0,0,0,0,0,0,0],
            // Row 2: chimney body + roof peak
            [0,0,0,0,0,0,0,0,0,0,0,0,r,r,r,r,r,r,r,r,r,r,r,r,ch,chd,ch,r,r,r,r,r,r,0,0,0,0,0,0,0],
            // Row 3: roof widens
            [0,0,0,0,0,0,0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,ch,sm,ch,r,r,r,r,r,r,rs,0,0,0,0,0,0],
            // Row 4
            [0,0,0,0,0,0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,ch,ch,ch,r,r,r,r,r,r,r,rs,0,0,0,0,0],
            // Row 5
            [0,0,0,0,0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,rs,0,0,0,0],
            // Row 6
            [0,0,0,0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,rs,0,0,0],
            // Row 7
            [0,0,0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,rs,0,0],
            // Row 8
            [0,0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,rs,0],
            // Row 9: roof bottom
            [0,0,0,0,0,rl,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,rs],
            // Row 10: eave outline
            [0,0,0,0,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o],
            // Row 11: eave shadow
            [0,0,0,0,o,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,o,cs,cs,cs,cs,cs,o],
            // Row 12: front wall start + right side face
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 13
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 14: windows top
            [0,0,0,0,o,c,c,wd,wb,26,wb,wd,c,c,c,c,c,c,c,c,c,c,wd,wb,26,wb,wd,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 15: windows
            [0,0,0,0,o,c,c,wd,wb,wb,wb,wd,c,c,c,c,c,c,c,c,c,c,wd,wb,wb,wb,wd,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 16: cross-pane
            [0,0,0,0,o,c,c,wd,wd,wd,wd,wd,c,c,c,c,c,c,c,c,c,c,wd,wd,wd,wd,wd,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 17: lower pane
            [0,0,0,0,o,c,c,wd,wb,wb,wb,wd,c,c,c,c,c,c,c,c,c,c,wd,wb,wb,wb,wd,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 18: window glow
            [0,0,0,0,o,c,c,wd,wb,g,wb,wd,c,c,c,c,c,c,c,c,c,c,wd,wb,g,wb,wd,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 19: flower boxes under windows
            [0,0,0,0,o,c,c,fl,11,fl,11,fl,c,c,c,c,c,c,c,c,c,c,fl,11,fl,11,fl,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 20: blank wall
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 21: blank wall
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 22: door frame top
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,dn,dn,dn,dn,dn,dn,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 23: door top
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,d,d,d,d,d,d,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 24: door with window glow
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,d,g,g,g,g,d,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 25: door body
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,d,d,d,d,d,d,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 26: door body
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,d,d,d,d,d,d,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 27: door lower glow
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,d,g,g,g,g,d,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 28: door bottom
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,d,d,d,d,d,d,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 29: welcome mat
            [0,0,0,0,o,c,c,c,c,c,c,c,c,10,10,dn,dn,dn,dn,dn,dn,10,10,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 30: door frame bottom
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,dn,dn,dn,dn,dn,dn,dn,dn,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 31: wall
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 32: wall
            [0,0,0,0,o,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,o,cw,cw,cw,cw,cw,o],
            // Row 33: foundation
            [0,0,0,0,o,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,fn,o,cs,cs,cs,cs,cs,o],
            // Row 34: base outline
            [0,0,0,0,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o],
            // Row 35: cast shadow 1
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,sh,sh,sh],
            // Row 36: cast shadow 2
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,sh,sh],
            // Row 37: cast shadow 3
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,0],
            // Row 38: empty
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            // Row 39: empty
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        ]
        return texture(from: pixels)
    }

    static func buildingTexture(for eventType: EventType) -> SKTexture {
        buildingTexture(roofColor: eventType.roofColorIndex)
    }

    // MARK: - Decorations

    static func treeTexture() -> SKTexture {
        // Volumetric layered tree with 4-shade depth, 16x28
        // Light from top-left: RIGHT side of canopy is LIGHTER, LEFT side DARKER
        // Visible canopy volume with layered tiers, cast shadow at base
        let h = 25  // light green highlight (right side, lit)
        let g = 11  // lush green (main body)
        let d = 3   // dark teal (left shadow)
        let dd = 22 // dark green (deepest shadow)
        let t = 4   // trunk (warm brown)
        let to = 21 // trunk dark side (left)
        let tr = 15 // trunk highlight (right)
        let sh = 27 // cast shadow

        let pixels: [[Int]] = [
            // Row 0: tiny crown top highlight
            [0,0,0,0,0,0,0,g,h,0,0,0,0,0,0,0],
            // Row 1: crown
            [0,0,0,0,0,0,d,g,g,h,0,0,0,0,0,0],
            // Row 2: tier 1 (small dome)
            [0,0,0,0,0,d,g,g,g,g,h,0,0,0,0,0],
            // Row 3
            [0,0,0,0,d,d,g,g,g,g,g,h,0,0,0,0],
            // Row 4: slight indent (tier break)
            [0,0,0,0,0,dd,d,g,g,g,h,h,0,0,0,0],
            // Row 5: tier 2 starts wider
            [0,0,0,0,dd,d,g,g,g,g,g,h,0,0,0,0],
            // Row 6
            [0,0,0,dd,d,d,g,g,g,g,g,g,h,0,0,0],
            // Row 7
            [0,0,dd,d,d,g,g,g,g,g,g,g,h,h,0,0],
            // Row 8: tier break
            [0,0,0,0,dd,d,g,g,g,g,g,h,h,0,0,0],
            // Row 9: tier 3 (widest)
            [0,0,0,dd,d,d,g,g,g,g,g,g,h,0,0,0],
            // Row 10
            [0,0,dd,d,d,g,g,g,g,g,g,g,g,h,0,0],
            // Row 11
            [0,dd,d,d,g,g,g,g,g,g,g,g,g,h,h,0],
            // Row 12
            [dd,d,d,g,g,g,g,g,g,g,g,g,g,g,h,h],
            // Row 13: bottom of canopy (round out)
            [0,dd,d,d,g,g,g,g,g,g,g,g,g,h,h,0],
            // Row 14
            [0,0,dd,dd,d,d,g,g,g,g,g,g,h,h,0,0],
            // Row 15: canopy base
            [0,0,0,0,dd,d,d,g,g,g,h,h,0,0,0,0],
            // Row 16: canopy bottom tip
            [0,0,0,0,0,0,dd,d,g,h,0,0,0,0,0,0],
            // Row 17: trunk top
            [0,0,0,0,0,0,0,to,t,0,0,0,0,0,0,0],
            // Row 18: trunk body (3px wide with shading)
            [0,0,0,0,0,0,to,to,t,tr,0,0,0,0,0,0],
            // Row 19
            [0,0,0,0,0,0,to,to,t,tr,0,0,0,0,0,0],
            // Row 20
            [0,0,0,0,0,0,to,to,t,tr,0,0,0,0,0,0],
            // Row 21: trunk widens at base
            [0,0,0,0,0,to,to,to,t,t,tr,0,0,0,0,0],
            // Row 22: trunk base
            [0,0,0,0,0,to,to,to,t,t,tr,0,0,0,0,0],
            // Row 23: roots + ground shadow
            [0,0,0,0,dd,to,to,to,t,t,tr,dd,0,0,0,0],
            // Row 24: cast shadow ellipse row 1
            [0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,0,0,0],
            // Row 25: cast shadow ellipse row 2 (offset right)
            [0,0,0,0,0,0,0,sh,sh,sh,sh,sh,sh,sh,0,0],
            // Row 26: cast shadow fading
            [0,0,0,0,0,0,0,0,sh,sh,sh,sh,sh,0,0,0],
            // Row 27: empty
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        ]
        return texture(from: pixels)
    }

    static func flowerTexture(color: Int = 8) -> SKTexture {
        // Multi-petal with depth shading, 5x8
        let c = color
        let cd = 2  // dark petal shadow (plum)
        let y = 10  // gold center
        let g = 11  // green stem
        let l = 17  // bright leaf

        let pixels: [[Int]] = [
            [0,0,c,0,0],
            [0,c,cd,c,0],
            [c,cd,y,c,c],
            [0,c,cd,c,0],
            [0,0,c,0,0],
            [0,l,g,0,0],
            [0,0,g,0,0],
            [0,0,g,l,0],
        ]
        return texture(from: pixels)
    }

    static func bushTexture() -> SKTexture {
        // Puffy sphere bush with 3-shade depth + cast shadow, 10x8
        let h = 25  // highlight green (right, lit from top-left)
        let g = 11  // lush green (main)
        let d = 22  // dark green (shadow left/bottom)
        let dd = 3  // dark teal (deepest shadow)
        let sh = 27 // cast shadow

        let pixels: [[Int]] = [
            [0,0,0,dd,d,g,g,h,0,0],
            [0,0,dd,d,g,g,g,g,h,0],
            [0,dd,d,g,g,g,g,g,g,h],
            [dd,d,g,g,g,g,g,h,g,h],
            [dd,d,g,g,d,g,g,g,h,h],
            [0,dd,d,g,g,g,g,g,h,0],
            [0,0,dd,dd,d,d,d,h,0,0],
            [0,0,0,sh,sh,sh,sh,sh,sh,0],
        ]
        return texture(from: pixels)
    }

    // MARK: - Ambient

    static func cloudTexture() -> SKTexture {
        // Fluffy cloud with subtle gray shading on bottom, 20x8
        let w = 7   // warm white
        let l = 20  // cream highlight (top)
        let s = 6   // soft gray (bottom shadow)

        let pixels: [[Int]] = [
            [0,0,0,0,0,0,0,w,w,w,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,w,l,l,w,w,0,0,0,w,w,0,0,0,0],
            [0,0,0,0,0,w,l,l,l,l,w,w,0,w,l,w,w,0,0,0],
            [0,0,0,0,w,l,l,w,w,l,l,w,w,l,l,l,w,w,0,0],
            [0,0,0,w,l,w,w,w,w,w,w,w,w,w,w,w,w,w,w,0],
            [0,0,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w],
            [0,s,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,s,0],
            [0,0,s,s,s,w,w,w,w,w,w,w,w,w,w,s,s,s,0,0],
        ]
        return texture(from: pixels)
    }

    static func heartTexture() -> SKTexture {
        let h = 8   // crimson
        let p = 14  // rose pink (highlight)
        let d = 2   // dark plum (shadow)
        let pixels: [[Int]] = [
            [0,0,d,h,h,0,0,0,d,h,h,0,0],
            [0,d,h,h,p,h,0,d,h,h,p,h,0],
            [d,h,h,p,h,h,h,h,h,h,p,h,d],
            [d,h,h,h,h,h,h,h,h,h,h,h,d],
            [d,h,h,h,h,h,h,h,h,h,h,h,d],
            [0,d,h,h,h,h,h,h,h,h,h,d,0],
            [0,0,d,h,h,h,h,h,h,h,d,0,0],
            [0,0,0,d,h,h,h,h,h,d,0,0,0],
            [0,0,0,0,d,h,h,h,d,0,0,0,0],
            [0,0,0,0,0,d,h,d,0,0,0,0,0],
            [0,0,0,0,0,0,d,0,0,0,0,0,0],
        ]
        return texture(from: pixels)
    }

    static func starParticleTexture() -> SKTexture {
        let g = 10  // gold
        let l = 23  // light gold highlight
        let pixels: [[Int]] = [
            [0,0,0,g,0,0,0],
            [0,0,g,l,g,0,0],
            [0,g,l,l,l,g,0],
            [g,l,l,l,l,l,g],
            [0,g,l,l,l,g,0],
            [0,0,g,l,g,0,0],
            [0,0,0,g,0,0,0],
        ]
        return texture(from: pixels)
    }

    static func butterflyTexture(color: Int = 14) -> SKTexture {
        let c = color
        let w = 7   // white wing detail
        let b = 4   // body (warm brown)
        let pixels: [[Int]] = [
            [c,c,0,0,0,c,c],
            [c,c,c,0,c,c,c],
            [c,w,c,b,c,w,c],
            [c,c,c,b,c,c,c],
            [0,c,c,b,c,c,0],
            [c,c,0,b,0,c,c],
            [c,0,0,0,0,0,c],
        ]
        return texture(from: pixels)
    }

    // MARK: - UI Elements

    static func markerTexture() -> SKTexture {
        let g = 10  // gold
        let l = 23  // light gold
        let d = 9   // warm orange outline
        let pixels: [[Int]] = [
            [0,0,0,0,d,g,g,d,0,0,0,0],
            [0,0,0,d,g,l,l,g,d,0,0,0],
            [0,0,d,g,l,l,l,l,g,d,0,0],
            [0,d,g,g,l,l,l,l,g,g,d,0],
            [d,g,g,g,g,l,l,g,g,g,g,d],
            [0,d,g,g,g,g,g,g,g,g,d,0],
            [0,0,d,g,g,g,g,g,g,d,0,0],
            [0,0,0,d,g,g,g,g,d,0,0,0],
            [0,0,0,0,d,g,g,d,0,0,0,0],
            [0,0,0,0,0,d,d,0,0,0,0,0],
        ]
        return texture(from: pixels)
    }

    static func checkmarkTexture() -> SKTexture {
        let g = 11  // lush green
        let l = 17  // bright leaf (highlight)
        let pixels: [[Int]] = [
            [0,0,0,0,0,0,0,0,0,g],
            [0,0,0,0,0,0,0,0,g,l],
            [0,0,0,0,0,0,0,g,l,0],
            [0,0,0,0,0,0,g,l,0,0],
            [g,0,0,0,0,g,l,0,0,0],
            [l,g,0,0,g,l,0,0,0,0],
            [0,l,g,g,l,0,0,0,0,0],
            [0,0,l,l,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
        ]
        return texture(from: pixels)
    }
}
