#!/usr/bin/swift

import AppKit
import Foundation

// MARK: - Color Helpers

func rgb(_ r: Int, _ g: Int, _ b: Int) -> NSColor {
    NSColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
}

func rgba(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat) -> NSColor {
    NSColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a)
}

// MARK: - Pixel Drawing

class PixelCanvas {
    let width: Int
    let height: Int
    let scale: Int
    let image: NSImage
    let rep: NSBitmapImageRep

    init(width: Int, height: Int, scale: Int) {
        self.width = width
        self.height = height
        self.scale = scale
        let pw = width * scale
        let ph = height * scale
        rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: pw, pixelsHigh: ph,
            bitsPerSample: 8, samplesPerPixel: 4,
            hasAlpha: true, isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: pw * 4,
            bitsPerPixel: 32
        )!
        image = NSImage(size: NSSize(width: pw, height: ph))
        image.addRepresentation(rep)
    }

    func pixel(_ x: Int, _ y: Int, _ color: NSColor) {
        guard x >= 0 && x < width && y >= 0 && y < height else { return }
        let c = color.usingColorSpace(.deviceRGB) ?? color
        let r = UInt8(c.redComponent * 255)
        let g = UInt8(c.greenComponent * 255)
        let b = UInt8(c.blueComponent * 255)
        let a = UInt8(c.alphaComponent * 255)
        // y=0 is top of image in both our coordinate system and bitmap
        for sy in 0..<scale {
            for sx in 0..<scale {
                let px = x * scale + sx
                let py = y * scale + sy
                guard let data = rep.bitmapData else { continue }
                let offset = (py * width * scale + px) * 4
                data[offset] = r
                data[offset+1] = g
                data[offset+2] = b
                data[offset+3] = a
            }
        }
    }

    func fillRect(_ x: Int, _ y: Int, _ w: Int, _ h: Int, _ color: NSColor) {
        for dy in 0..<h {
            for dx in 0..<w {
                pixel(x + dx, y + dy, color)
            }
        }
    }

    // Dithered fill (checkerboard of two colors)
    func ditherRect(_ x: Int, _ y: Int, _ w: Int, _ h: Int, _ c1: NSColor, _ c2: NSColor) {
        for dy in 0..<h {
            for dx in 0..<w {
                pixel(x + dx, y + dy, (dx + dy) % 2 == 0 ? c1 : c2)
            }
        }
    }

    func save(to path: String) -> Bool {
        guard let data = rep.representation(using: .png, properties: [:]) else { return false }
        do {
            try data.write(to: URL(fileURLWithPath: path))
            return true
        } catch {
            print("Error saving: \(error)")
            return false
        }
    }
}

// MARK: - Style A: "Stardew Faithful"
// 32x32 sprites, black outlines, dithered shading, earthy desaturated palette

func generateStyleA() {
    // We'll work at a logical pixel grid and scale up
    // Scene: 128x128 logical pixels, scaled 4x to 512x512
    let canvas = PixelCanvas(width: 128, height: 128, scale: 4)

    // Palette - earthy, desaturated
    let skyTop = rgb(142, 172, 198)      // muted blue sky
    let skyBot = rgb(178, 198, 210)      // lighter horizon
    let grassDark = rgb(76, 112, 56)     // dark olive grass
    let grassMid = rgb(98, 138, 72)      // mid grass
    let grassLight = rgb(118, 156, 88)   // light grass
    let dirtDark = rgb(128, 96, 62)      // dark dirt
    let dirtMid = rgb(156, 118, 78)      // path dirt
    let dirtLight = rgb(178, 142, 98)    // light dirt
    let black = rgb(20, 20, 20)          // outlines
    let woodDark = rgb(108, 76, 48)      // dark wood
    let woodMid = rgb(138, 98, 62)       // mid wood
    let woodLight = rgb(168, 126, 82)    // light wood
    let roofDark = rgb(128, 68, 48)      // dark roof
    let roofMid = rgb(158, 88, 58)       // mid roof
    let stoneDark = rgb(98, 92, 86)      // chimney stone dark
    let stoneMid = rgb(128, 122, 112)    // chimney stone mid
    let stoneLight = rgb(158, 152, 142)  // chimney stone light
    let skinTone = rgb(218, 176, 142)    // character skin
    let skinShade = rgb(188, 148, 118)   // skin shadow
    let hairBrown = rgb(88, 56, 38)      // hair
    let shirtGreen = rgb(68, 98, 58)     // shirt
    let shirtShade = rgb(48, 76, 42)     // shirt shadow
    let pantsBrown = rgb(98, 72, 52)     // pants
    let pantsShade = rgb(78, 56, 38)     // pants shadow
    let trunkDark = rgb(88, 62, 42)      // tree trunk dark
    let trunkMid = rgb(118, 86, 58)      // tree trunk mid
    let leafDark = rgb(56, 88, 42)       // dark leaves
    let leafMid = rgb(78, 112, 56)       // mid leaves
    let leafLight = rgb(98, 132, 72)     // light leaves
    let windowBlue = rgb(142, 178, 198)  // window
    let windowShine = rgb(178, 208, 228) // window highlight
    let doorDark = rgb(88, 58, 38)       // door

    // --- Sky gradient ---
    for y in 0..<40 {
        let t = CGFloat(y) / 40.0
        let r = Int(CGFloat(142) + t * CGFloat(178 - 142))
        let g = Int(CGFloat(172) + t * CGFloat(198 - 172))
        let b = Int(CGFloat(198) + t * CGFloat(210 - 198))
        for x in 0..<128 {
            canvas.pixel(x, y, rgb(r, g, b))
        }
    }

    // --- Ground base (grass) ---
    for y in 40..<128 {
        for x in 0..<128 {
            // Vary grass tiles
            let noise = (x * 7 + y * 13) % 11
            if noise < 4 {
                canvas.pixel(x, y, grassDark)
            } else if noise < 7 {
                canvas.pixel(x, y, grassMid)
            } else {
                canvas.pixel(x, y, grassLight)
            }
        }
    }

    // --- Grass tufts scattered ---
    let tufts = [(5,55), (15,70), (25,52), (95,60), (110,75), (8,90), (115,95), (20,110), (100,105), (85,48)]
    for (tx, ty) in tufts {
        canvas.pixel(tx, ty, grassDark)
        canvas.pixel(tx+1, ty-1, grassDark)
        canvas.pixel(tx-1, ty-1, grassDark)
    }

    // --- Dirt path (winding, bottom-center) ---
    for y in 68..<128 {
        let wobble = Int(sin(Double(y) * 0.15) * 4)
        let cx = 64 + wobble
        let pathW = (y > 100) ? 14 : 10
        for x in (cx - pathW/2)...(cx + pathW/2) {
            let edge = abs(x - cx)
            if edge == pathW/2 {
                canvas.ditherRect(x, y, 1, 1, dirtMid, grassMid)
            } else if edge >= pathW/2 - 1 {
                canvas.pixel(x, y, dirtMid)
            } else {
                if (x + y) % 5 == 0 {
                    canvas.pixel(x, y, dirtLight)
                } else if (x + y) % 7 == 0 {
                    canvas.pixel(x, y, dirtDark)
                } else {
                    canvas.pixel(x, y, dirtMid)
                }
            }
        }
    }

    // === BUILDING (rustic wooden house, 32x32, at position 72,36) ===
    let bx = 72, by = 36

    // Roof (triangular) with black outline
    for row in 0..<10 {
        let halfW = 16 - row
        for col in (16 - halfW)...(16 + halfW) {
            let px = bx + col
            let py = by + row
            if col == 16 - halfW || col == 16 + halfW || row == 0 {
                canvas.pixel(px, py, black)
            } else {
                // Dithered roof shading
                if col < 16 {
                    canvas.ditherRect(px, py, 1, 1, roofDark, roofMid)
                } else {
                    canvas.pixel(px, py, roofMid)
                }
            }
        }
    }

    // Walls
    canvas.fillRect(bx + 2, by + 10, 29, 22, woodMid)
    // Black outline around walls
    canvas.fillRect(bx + 1, by + 10, 1, 22, black) // left wall
    canvas.fillRect(bx + 31, by + 10, 1, 22, black) // right wall
    canvas.fillRect(bx + 1, by + 31, 31, 1, black) // bottom
    // Wood plank lines
    for row in stride(from: 14, to: 30, by: 4) {
        canvas.fillRect(bx + 2, by + row, 29, 1, woodDark)
    }
    // Dithered shadow on left side of wall
    canvas.ditherRect(bx + 2, by + 10, 6, 21, woodDark, woodMid)
    // Light side
    canvas.ditherRect(bx + 24, by + 10, 6, 21, woodMid, woodLight)

    // Window (left)
    canvas.fillRect(bx + 6, by + 15, 8, 7, black)
    canvas.fillRect(bx + 7, by + 16, 6, 5, windowBlue)
    canvas.fillRect(bx + 7, by + 16, 2, 2, windowShine)
    canvas.fillRect(bx + 10, by + 16, 1, 5, black) // cross
    canvas.fillRect(bx + 7, by + 18, 6, 1, black) // cross

    // Window (right)
    canvas.fillRect(bx + 19, by + 15, 8, 7, black)
    canvas.fillRect(bx + 20, by + 16, 6, 5, windowBlue)
    canvas.fillRect(bx + 20, by + 16, 2, 2, windowShine)
    canvas.fillRect(bx + 23, by + 16, 1, 5, black)
    canvas.fillRect(bx + 20, by + 18, 6, 1, black)

    // Door
    canvas.fillRect(bx + 12, by + 22, 8, 10, black)
    canvas.fillRect(bx + 13, by + 23, 6, 8, doorDark)
    canvas.pixel(bx + 17, by + 27, rgb(198, 178, 88)) // knob

    // Chimney (stone, on right side of roof)
    canvas.fillRect(bx + 24, by + 2, 5, 10, black) // outline
    canvas.fillRect(bx + 25, by + 3, 3, 8, stoneMid)
    canvas.pixel(bx + 25, by + 3, stoneDark)
    canvas.pixel(bx + 27, by + 5, stoneLight)
    canvas.pixel(bx + 25, by + 7, stoneDark)
    canvas.pixel(bx + 26, by + 4, stoneLight)
    // Smoke
    canvas.pixel(bx + 26, by + 1, rgba(160, 160, 165, 0.6))
    canvas.pixel(bx + 25, by + 0, rgba(170, 170, 175, 0.4))

    // === TREES (round canopy, thick trunk, dithered) ===
    func drawStardewTree(_ cx: Int, _ ty: Int) {
        // Trunk (thick, 4px wide)
        canvas.fillRect(cx - 1, ty + 12, 1, 12, black)
        canvas.fillRect(cx + 4, ty + 12, 1, 12, black)
        canvas.fillRect(cx, ty + 12, 4, 12, trunkMid)
        canvas.fillRect(cx, ty + 12, 1, 12, trunkDark)
        canvas.fillRect(cx + 3, ty + 12, 1, 12, trunkDark)
        canvas.fillRect(cx, ty + 23, 4, 1, black) // trunk bottom

        // Round canopy with dithered shadow
        // Main circle outline (black, radius ~9)
        let ccx = cx + 2, ccy = ty + 6
        let r = 9
        for dy in -r...r {
            for dx in -r...r {
                let dist = dx*dx + dy*dy
                if dist <= r*r {
                    let px = ccx + dx
                    let py = ccy + dy
                    if dist > (r-1)*(r-1) {
                        canvas.pixel(px, py, black) // outline
                    } else if dx < -2 {
                        // Left side: dithered shadow
                        canvas.ditherRect(px, py, 1, 1, leafDark, leafMid)
                    } else if dx > 3 {
                        // Right side: lighter
                        canvas.pixel(px, py, leafLight)
                    } else {
                        canvas.pixel(px, py, leafMid)
                    }
                }
            }
        }
        // Highlight spots
        canvas.pixel(ccx + 1, ccy - 3, leafLight)
        canvas.pixel(ccx + 2, ccy - 2, leafLight)
    }

    drawStardewTree(8, 38)
    drawStardewTree(38, 34)
    drawStardewTree(112, 40)

    // === CHARACTER (stocky, 32x32 at bottom center) ===
    let charX = 55, charY = 72

    // Shadow on ground
    canvas.ditherRect(charX + 2, charY + 30, 12, 2, rgba(0,0,0,0.25), grassMid)

    // Feet/shoes (brown)
    canvas.fillRect(charX + 4, charY + 27, 4, 3, black)
    canvas.fillRect(charX + 5, charY + 28, 2, 2, pantsBrown)
    canvas.fillRect(charX + 10, charY + 27, 4, 3, black)
    canvas.fillRect(charX + 11, charY + 28, 2, 2, pantsBrown)

    // Legs/pants
    canvas.fillRect(charX + 4, charY + 22, 4, 5, black) // outline
    canvas.fillRect(charX + 10, charY + 22, 4, 5, black)
    canvas.fillRect(charX + 5, charY + 22, 2, 5, pantsBrown)
    canvas.fillRect(charX + 11, charY + 22, 2, 5, pantsBrown)
    // dithered shade on left leg
    canvas.ditherRect(charX + 5, charY + 24, 1, 3, pantsShade, pantsBrown)

    // Body/shirt (stocky torso)
    canvas.fillRect(charX + 3, charY + 12, 12, 10, black) // outline
    canvas.fillRect(charX + 4, charY + 13, 10, 9, shirtGreen)
    canvas.ditherRect(charX + 4, charY + 13, 3, 9, shirtShade, shirtGreen) // shadow side
    // Belt
    canvas.fillRect(charX + 4, charY + 21, 10, 1, rgb(98, 72, 42))

    // Arms
    canvas.fillRect(charX + 1, charY + 13, 3, 8, black)
    canvas.fillRect(charX + 2, charY + 14, 1, 6, shirtGreen)
    canvas.fillRect(charX + 2, charY + 19, 1, 2, skinTone) // hand
    canvas.fillRect(charX + 14, charY + 13, 3, 8, black)
    canvas.fillRect(charX + 15, charY + 14, 1, 6, shirtGreen)
    canvas.fillRect(charX + 15, charY + 19, 1, 2, skinTone)

    // Head (big for stocky proportions)
    canvas.fillRect(charX + 3, charY + 2, 12, 11, black) // outline
    canvas.fillRect(charX + 4, charY + 3, 10, 9, skinTone)
    // Shaded side of face
    canvas.fillRect(charX + 4, charY + 3, 2, 9, skinShade)
    // Hair on top
    canvas.fillRect(charX + 3, charY + 1, 12, 4, black) // hair outline
    canvas.fillRect(charX + 4, charY + 2, 10, 3, hairBrown)
    // Eyes (big, expressive)
    canvas.fillRect(charX + 6, charY + 6, 2, 2, black)
    canvas.fillRect(charX + 10, charY + 6, 2, 2, black)
    canvas.pixel(charX + 6, charY + 6, rgb(255, 255, 255)) // eye highlight
    canvas.pixel(charX + 10, charY + 6, rgb(255, 255, 255))
    // Nose dot
    canvas.pixel(charX + 8, charY + 8, rgb(198, 156, 122))
    // Small mouth
    canvas.pixel(charX + 8, charY + 10, rgb(178, 118, 98))
    canvas.pixel(charX + 9, charY + 10, rgb(178, 118, 98))

    // Hat (straw hat)
    canvas.fillRect(charX + 1, charY + 0, 16, 3, black)
    canvas.fillRect(charX + 2, charY + 1, 14, 1, rgb(198, 178, 108))
    canvas.fillRect(charX + 4, charY + 0, 10, 1, rgb(188, 168, 98))

    // === LABEL ===
    // Simple pixel text "A" in corner
    let labelData: [[Int]] = [
        [0,0,1,1,0,0],
        [0,1,0,0,1,0],
        [1,0,0,0,0,1],
        [1,1,1,1,1,1],
        [1,0,0,0,0,1],
        [1,0,0,0,0,1],
    ]
    for (row, line) in labelData.enumerated() {
        for (col, val) in line.enumerated() {
            if val == 1 {
                canvas.pixel(3 + col, 3 + row, black)
            }
        }
    }

    let path = "/Users/alex/Desktop/DayQuest/mockups/style_a_stardew.png"
    if canvas.save(to: path) {
        print("Style A saved: \(path)")
    }
}

// MARK: - Style B: "Chibi Watercolor"
// 48x48 sprites, colored outlines, smooth gradients, soft pastels

func generateStyleB() {
    let canvas = PixelCanvas(width: 128, height: 128, scale: 4)

    // Palette - soft, pastel-warm
    let skyTop = rgb(198, 218, 248)
    let skyBot = rgb(228, 218, 238)       // lavender horizon
    let grassLight = rgb(148, 208, 158)   // mint green
    let grassMid = rgb(128, 188, 138)     // soft green
    let grassDark = rgb(108, 168, 118)    // deeper green
    let flowerPink = rgb(248, 188, 198)   // pink flowers
    let flowerYellow = rgb(248, 238, 168) // butter yellow flowers
    let flowerLav = rgb(208, 188, 228)    // lavender flowers

    let skinPeach = rgb(248, 218, 198)    // peach skin
    let skinShade = rgb(238, 198, 178)    // skin shadow
    let skinOutline = rgb(208, 168, 148)  // colored outline (dark peach)
    let hairGold = rgb(238, 208, 148)     // golden hair
    let hairOutline = rgb(198, 168, 108)  // hair outline
    let dressLav = rgb(208, 178, 228)     // lavender dress
    let dressShade = rgb(178, 148, 198)   // dress shadow
    let dressOutline = rgb(158, 128, 178) // dress outline
    let shoesPink = rgb(228, 168, 178)    // shoes
    let shoesOutline = rgb(198, 138, 148)

    let roofPink = rgb(248, 188, 188)     // candy pink roof
    let roofShade = rgb(228, 168, 168)
    let roofOutline = rgb(208, 148, 148)
    let wallCream = rgb(248, 238, 228)    // cream walls
    let wallShade = rgb(238, 228, 218)
    let wallOutline = rgb(208, 198, 188)
    let windowMint = rgb(188, 228, 218)   // mint window
    let windowShine = rgb(218, 248, 238)
    let doorLav = rgb(188, 168, 208)      // lavender door
    let doorOutline = rgb(158, 138, 178)

    let trunkBrown = rgb(178, 148, 128)   // soft brown trunk
    let trunkOutline = rgb(148, 118, 98)
    let leafSoft = rgb(158, 208, 168)     // puffy leaf green
    let leafLight = rgb(188, 228, 188)
    let leafShade = rgb(128, 178, 138)
    let leafOutline = rgb(108, 158, 118)

    // --- Sky gradient (soft peach to lavender) ---
    for y in 0..<45 {
        let t = CGFloat(y) / 45.0
        let r = Int(CGFloat(198) + t * CGFloat(228 - 198))
        let g = Int(CGFloat(218) + t * CGFloat(218 - 218))
        let b = Int(CGFloat(248) + t * CGFloat(238 - 248))
        for x in 0..<128 {
            canvas.pixel(x, y, rgb(r, g, b))
        }
    }

    // Soft clouds
    func softCloud(_ cx: Int, _ cy: Int, _ w: Int) {
        let cloudW = rgb(255, 252, 248)
        let cloudS = rgb(238, 232, 228)
        for dy in -3...3 {
            for dx in (-w/2)...(w/2) {
                let dist = (dx*dx)/(w*w/4) + (dy*dy)/9
                if dist <= 1 {
                    canvas.pixel(cx+dx, cy+dy, dy > 1 ? cloudS : cloudW)
                }
            }
        }
    }
    softCloud(30, 12, 20)
    softCloud(90, 8, 16)
    softCloud(60, 18, 14)

    // --- Rolling grass with gentle color waves ---
    for y in 45..<128 {
        for x in 0..<128 {
            let wave = sin(Double(x) * 0.08 + Double(y) * 0.05) * 0.5 + 0.5
            if wave < 0.33 {
                canvas.pixel(x, y, grassDark)
            } else if wave < 0.66 {
                canvas.pixel(x, y, grassMid)
            } else {
                canvas.pixel(x, y, grassLight)
            }
        }
    }

    // Scattered flowers
    let flowers: [(Int, Int, NSColor)] = [
        (8, 58, flowerPink), (22, 75, flowerYellow), (12, 88, flowerLav),
        (35, 62, flowerPink), (42, 95, flowerYellow), (88, 55, flowerLav),
        (95, 78, flowerPink), (108, 65, flowerYellow), (115, 88, flowerLav),
        (15, 105, flowerPink), (105, 110, flowerYellow), (50, 118, flowerLav),
        (75, 52, flowerPink), (120, 100, flowerYellow),
    ]
    for (fx, fy, fc) in flowers {
        canvas.pixel(fx, fy, fc)
        canvas.pixel(fx+1, fy, fc)
        canvas.pixel(fx, fy-1, fc)
        canvas.pixel(fx+1, fy-1, fc)
        // Stem
        canvas.pixel(fx, fy+1, grassDark)
    }

    // Soft path (rolling, wider, gentle colors)
    for y in 70..<128 {
        let wobble = Int(sin(Double(y) * 0.1) * 6)
        let cx = 60 + wobble
        let pathW = (y > 100) ? 16 : 12
        for x in (cx - pathW/2)...(cx + pathW/2) {
            let edge = abs(x - cx)
            let t = CGFloat(edge) / CGFloat(pathW/2)
            if t > 0.85 {
                // Soft edge blend
                canvas.pixel(x, y, rgb(188, 208, 178))
            } else {
                let r = Int(228 - t * 20)
                let g = Int(218 - t * 20)
                let b = Int(188 - t * 20)
                canvas.pixel(x, y, rgb(r, g, b))
            }
        }
    }

    // === BUILDING (rounded cottage with candy roof) ===
    let bx = 72, by = 36

    // Rounded roof with colored outline (no black!)
    for row in 0..<12 {
        let halfW = min(18, 8 + row)
        for col in (18 - halfW)...(18 + halfW) {
            let px = bx + col
            let py = by + row
            if col == 18 - halfW || col == 18 + halfW {
                canvas.pixel(px, py, roofOutline)
            } else if row == 0 && col > 18 - 4 && col < 18 + 4 {
                canvas.pixel(px, py, roofOutline)
            } else {
                // Smooth gradient: darker at top, lighter lower
                let t = CGFloat(row) / 12.0
                if col < 18 - 4 {
                    canvas.pixel(px, py, roofShade)
                } else if col > 18 + 4 {
                    canvas.pixel(px, py, roofPink)
                } else {
                    let blend = t > 0.5 ? roofPink : roofShade
                    canvas.pixel(px, py, blend)
                }
            }
        }
    }

    // Walls (rounded bottom corners)
    for y in 0..<20 {
        for x in 0..<36 {
            let py = by + 12 + y
            let px = bx + x
            // Round bottom corners
            let isCornerBL = y >= 17 && x < 3 && (20 - y + x < 3)
            let isCornerBR = y >= 17 && x > 32 && (20 - y + (35 - x) < 3)
            if isCornerBL || isCornerBR { continue }

            if x == 0 || x == 35 || y == 19 {
                canvas.pixel(px, py, wallOutline)
            } else if x < 4 {
                canvas.pixel(px, py, wallShade)
            } else {
                canvas.pixel(px, py, wallCream)
            }
        }
    }

    // Round window (left)
    let wlx = bx + 7, wly = by + 17
    for dy in -3...3 {
        for dx in -3...3 {
            if dx*dx + dy*dy <= 9 {
                if dx*dx + dy*dy > 6 {
                    canvas.pixel(wlx+dx, wly+dy, wallOutline)
                } else {
                    canvas.pixel(wlx+dx, wly+dy, windowMint)
                    if dx < 0 && dy < 0 { canvas.pixel(wlx+dx, wly+dy, windowShine) }
                }
            }
        }
    }

    // Round window (right)
    let wrx = bx + 27, wry = by + 17
    for dy in -3...3 {
        for dx in -3...3 {
            if dx*dx + dy*dy <= 9 {
                if dx*dx + dy*dy > 6 {
                    canvas.pixel(wrx+dx, wry+dy, wallOutline)
                } else {
                    canvas.pixel(wrx+dx, wry+dy, windowMint)
                    if dx < 0 && dy < 0 { canvas.pixel(wrx+dx, wry+dy, windowShine) }
                }
            }
        }
    }

    // Arched door
    canvas.fillRect(bx + 14, by + 22, 8, 10, doorOutline)
    canvas.fillRect(bx + 15, by + 23, 6, 9, doorLav)
    // Arch top
    for dx in 0..<6 {
        let dy = Int(sqrt(max(0, 9.0 - pow(Double(dx) - 2.5, 2))))
        for row in 0..<dy {
            canvas.pixel(bx + 15 + dx, by + 23 - row, doorLav)
        }
    }
    canvas.pixel(bx + 19, by + 27, rgb(228, 208, 168)) // knob

    // Window boxes with flowers
    for wx in [bx + 5, bx + 25] {
        canvas.fillRect(wx, by + 21, 6, 2, trunkBrown)
        // Tiny flowers in box
        canvas.pixel(wx + 1, by + 20, flowerPink)
        canvas.pixel(wx + 3, by + 20, flowerYellow)
        canvas.pixel(wx + 5, by + 20, flowerLav)
        canvas.pixel(wx + 2, by + 19, flowerPink)
        canvas.pixel(wx + 4, by + 19, flowerYellow)
    }

    // === TREES (puffy cloud-like canopy) ===
    func drawChibiTree(_ cx: Int, _ ty: Int) {
        // Thin trunk (colored outline)
        canvas.fillRect(cx - 1, ty + 10, 1, 14, trunkOutline)
        canvas.fillRect(cx + 2, ty + 10, 1, 14, trunkOutline)
        canvas.fillRect(cx, ty + 10, 2, 14, trunkBrown)

        // Cloud-like puffy canopy (multiple overlapping circles)
        let puffs: [(Int, Int, Int)] = [
            (cx, ty + 4, 6), (cx - 4, ty + 6, 5), (cx + 4, ty + 6, 5),
            (cx - 2, ty + 2, 5), (cx + 2, ty + 2, 5), (cx, ty + 7, 5),
        ]
        for (px, py, r) in puffs {
            for dy in -r...r {
                for dx in -r...r {
                    if dx*dx + dy*dy <= r*r {
                        let ppx = px + dx
                        let ppy = py + dy
                        if dx*dx + dy*dy > (r-1)*(r-1) {
                            canvas.pixel(ppx, ppy, leafOutline)
                        } else if dy < -1 {
                            canvas.pixel(ppx, ppy, leafLight)
                        } else if dx < -1 {
                            canvas.pixel(ppx, ppy, leafShade)
                        } else {
                            canvas.pixel(ppx, ppy, leafSoft)
                        }
                    }
                }
            }
        }
    }

    drawChibiTree(10, 38)
    drawChibiTree(40, 32)
    drawChibiTree(115, 36)

    // === CHARACTER (extreme chibi, head = 60% of body, 48x48 conceptually) ===
    // Placed at bottom center, scaled to fit scene
    let cx = 50, cy = 70

    // Ground shadow (soft oval)
    for dy in -1...1 {
        for dx in -6...6 {
            if dx*dx + dy*dy*36 < 40 {
                canvas.pixel(cx + 8 + dx, cy + 28 + dy, rgba(108, 158, 118, 0.4))
            }
        }
    }

    // Tiny feet
    canvas.fillRect(cx + 4, cy + 25, 4, 3, shoesOutline)
    canvas.fillRect(cx + 5, cy + 26, 2, 2, shoesPink)
    canvas.fillRect(cx + 10, cy + 25, 4, 3, shoesOutline)
    canvas.fillRect(cx + 11, cy + 26, 2, 2, shoesPink)

    // Tiny body (round, small)
    for dy in 0..<8 {
        let halfW = dy < 2 ? 4 + dy : (dy > 5 ? 8 - (dy - 5) : 6)
        for dx in -halfW...halfW {
            let px = cx + 8 + dx
            let py = cy + 17 + dy
            if abs(dx) == halfW || dy == 0 || dy == 7 {
                canvas.pixel(px, py, dressOutline)
            } else if dx < -2 {
                canvas.pixel(px, py, dressShade)
            } else {
                canvas.pixel(px, py, dressLav)
            }
        }
    }

    // Tiny hands
    canvas.pixel(cx + 1, cy + 20, skinPeach)
    canvas.pixel(cx + 15, cy + 20, skinPeach)

    // Tiny arms
    canvas.fillRect(cx + 1, cy + 18, 2, 3, dressOutline)
    canvas.fillRect(cx + 2, cy + 18, 1, 2, dressLav)
    canvas.fillRect(cx + 14, cy + 18, 2, 3, dressOutline)
    canvas.fillRect(cx + 14, cy + 18, 1, 2, dressLav)

    // HUGE head (chibi: head = 60% of total height)
    let hx = cx + 8, hy = cy + 8
    let hr = 9
    for dy in -hr...hr {
        for dx in -hr...hr {
            if dx*dx + dy*dy <= hr*hr {
                let px = hx + dx
                let py = hy + dy
                if dx*dx + dy*dy > (hr-1)*(hr-1) {
                    canvas.pixel(px, py, skinOutline)
                } else if dx < -4 {
                    canvas.pixel(px, py, skinShade)
                } else {
                    canvas.pixel(px, py, skinPeach)
                }
            }
        }
    }

    // Hair (golden, flowing over head)
    for dy in -hr...(hr-4) {
        for dx in -(hr+1)...(hr+1) {
            if dx*dx + dy*dy <= (hr+1)*(hr+1) && dy < -1 {
                canvas.pixel(hx + dx, hy + dy, hairGold)
                if dx*dx + dy*dy > hr*hr {
                    canvas.pixel(hx + dx, hy + dy, hairOutline)
                }
            }
        }
    }
    // Side hair strands
    canvas.fillRect(hx - hr, hy - 2, 2, 6, hairOutline)
    canvas.fillRect(hx - hr + 1, hy - 1, 1, 4, hairGold)
    canvas.fillRect(hx + hr - 1, hy - 2, 2, 6, hairOutline)
    canvas.fillRect(hx + hr - 1, hy - 1, 1, 4, hairGold)

    // Huge eyes with highlight dots
    // Left eye
    canvas.fillRect(hx - 4, hy + 1, 3, 4, rgb(88, 68, 48))
    canvas.pixel(hx - 4, hy + 1, rgb(255, 255, 255)) // highlight
    canvas.pixel(hx - 3, hy + 2, rgb(128, 108, 88))  // iris detail
    // Right eye
    canvas.fillRect(hx + 2, hy + 1, 3, 4, rgb(88, 68, 48))
    canvas.pixel(hx + 2, hy + 1, rgb(255, 255, 255))
    canvas.pixel(hx + 3, hy + 2, rgb(128, 108, 88))

    // Blush marks
    canvas.pixel(hx - 5, hy + 4, rgb(248, 188, 188))
    canvas.pixel(hx - 4, hy + 4, rgb(248, 188, 188))
    canvas.pixel(hx + 4, hy + 4, rgb(248, 188, 188))
    canvas.pixel(hx + 5, hy + 4, rgb(248, 188, 188))

    // Tiny mouth
    canvas.pixel(hx, hy + 5, rgb(228, 158, 148))

    // Label "B"
    let labelB: [[Int]] = [
        [1,1,1,1,0],
        [1,0,0,0,1],
        [1,1,1,1,0],
        [1,0,0,0,1],
        [1,0,0,0,1],
        [1,1,1,1,0],
    ]
    for (row, line) in labelB.enumerated() {
        for (col, val) in line.enumerated() {
            if val == 1 { canvas.pixel(3 + col, 3 + row, dressOutline) }
        }
    }

    let path = "/Users/alex/Desktop/DayQuest/mockups/style_b_chibi.png"
    if canvas.save(to: path) {
        print("Style B saved: \(path)")
    }
}

// MARK: - Style C: "Crisp Modern Pixel"
// 32x48 sprites, colored outlines, saturated vibrant, clean no-dither

func generateStyleC() {
    let canvas = PixelCanvas(width: 128, height: 128, scale: 4)

    // Palette - vibrant, saturated, high contrast
    let skyDeep = rgb(28, 48, 98)         // deep blue sky (dusk feel)
    let skyMid = rgb(58, 88, 148)
    let skyLight = rgb(88, 128, 188)
    let skyHorizon = rgb(228, 148, 108)   // warm amber horizon

    let grassVibrant = rgb(48, 148, 78)   // rich green
    let grassDark = rgb(28, 118, 58)      // darker green
    let grassAccent = rgb(68, 168, 98)    // bright accent

    let pathWarm = rgb(198, 158, 108)     // warm amber path
    let pathDark = rgb(168, 128, 78)
    let pathLight = rgb(228, 188, 138)

    let charOutline = rgb(38, 28, 58)     // dark purple outline
    let skinWarm = rgb(238, 198, 168)     // warm skin
    let skinShade = rgb(208, 168, 138)
    let scarfRed = rgb(218, 68, 58)       // rich crimson scarf
    let scarfDark = rgb(178, 48, 38)
    let jacketBlue = rgb(48, 98, 178)     // electric blue jacket
    let jacketDark = rgb(28, 68, 138)
    let jacketLight = rgb(78, 128, 208)
    let pantsGray = rgb(68, 68, 78)       // dark pants
    let pantsDark = rgb(48, 48, 58)
    let bootsAmber = rgb(168, 118, 68)    // warm boots
    let bootsDark = rgb(128, 88, 48)
    let hairDark = rgb(38, 28, 48)        // near-black hair
    let hairShine = rgb(68, 58, 88)       // subtle shine
    let bagBrown = rgb(148, 98, 58)       // bag/accessory

    let buildOutline = rgb(38, 48, 68)    // building outline
    let wallClean = rgb(228, 228, 238)    // clean white wall
    let wallShade = rgb(198, 198, 208)
    let roofBlue = rgb(58, 108, 178)      // bright accent roof
    let roofDark = rgb(38, 78, 138)
    let roofLight = rgb(88, 138, 208)
    let windowAmber = rgb(248, 208, 128)  // warm amber lit window
    let windowBright = rgb(255, 238, 178)
    let doorCrimson = rgb(188, 58, 48)    // crimson door
    let doorDark = rgb(148, 38, 28)

    let trunkClean = rgb(108, 78, 58)     // clean trunk
    let trunkOutline = rgb(68, 48, 38)
    let leafBright = rgb(48, 158, 88)     // bright stylized leaf
    let leafDark = rgb(28, 118, 58)       // darker leaf
    let leafOutline = rgb(18, 88, 48)     // leaf outline

    // --- Sky gradient (deep dusk blue to amber horizon) ---
    for y in 0..<42 {
        let t = CGFloat(y) / 42.0
        let r: Int, g: Int, b: Int
        if t < 0.6 {
            let tt = t / 0.6
            r = Int(CGFloat(28) + tt * CGFloat(58 - 28))
            g = Int(CGFloat(48) + tt * CGFloat(88 - 48))
            b = Int(CGFloat(98) + tt * CGFloat(148 - 98))
        } else {
            let tt = (t - 0.6) / 0.4
            r = Int(CGFloat(58) + tt * CGFloat(228 - 58))
            g = Int(CGFloat(88) + tt * CGFloat(148 - 88))
            b = Int(CGFloat(148) + tt * CGFloat(108 - 148))
        }
        for x in 0..<128 {
            canvas.pixel(x, y, rgb(r, g, b))
        }
    }

    // Stars in sky
    let stars = [(12,5),(28,3),(45,8),(68,4),(85,7),(102,2),(118,6),(35,15),(78,12),(95,18)]
    for (sx, sy) in stars {
        canvas.pixel(sx, sy, rgb(255, 255, 228))
    }

    // --- Ground (clean color blocks) ---
    for y in 42..<128 {
        for x in 0..<128 {
            // Clean alternating stripes with slight variation
            let stripe = (x + y * 3) % 13
            if stripe < 5 {
                canvas.pixel(x, y, grassDark)
            } else if stripe < 9 {
                canvas.pixel(x, y, grassVibrant)
            } else {
                canvas.pixel(x, y, grassAccent)
            }
        }
    }

    // Detail flowers (clean, small)
    let detailFlowers: [(Int, Int, NSColor)] = [
        (10, 55, rgb(248, 188, 88)), (25, 72, rgb(248, 108, 88)),
        (88, 52, rgb(248, 188, 88)), (105, 68, rgb(248, 108, 88)),
        (15, 95, rgb(248, 188, 88)), (110, 100, rgb(248, 108, 88)),
        (45, 110, rgb(248, 188, 88)), (78, 48, rgb(248, 108, 88)),
    ]
    for (fx, fy, fc) in detailFlowers {
        canvas.pixel(fx, fy, fc)
        canvas.pixel(fx + 1, fy, fc)
    }

    // Clean path
    for y in 65..<128 {
        let wobble = Int(sin(Double(y) * 0.12) * 5)
        let pcx = 62 + wobble
        let pathW = (y > 100) ? 14 : 10
        for x in (pcx - pathW/2)...(pcx + pathW/2) {
            let edge = abs(x - pcx)
            if edge >= pathW/2 - 1 {
                canvas.pixel(x, y, pathDark) // clean edge
            } else if edge >= pathW/2 - 2 {
                canvas.pixel(x, y, pathWarm)
            } else {
                canvas.pixel(x, y, pathLight)
            }
        }
    }

    // === BUILDING (clean geometric, modern cozy, Celeste-style) ===
    let bx = 70, by = 30

    // Geometric roof - clean angular trapezoid
    for row in 0..<10 {
        let inset = max(0, row - 2)
        let left = bx - 2 + inset
        let right = bx + 36 - inset
        for x in left...right {
            let py = by + row
            if x == left || x == right || row == 0 {
                canvas.pixel(x, py, buildOutline)
            } else {
                // Two-tone roof
                if x < bx + 17 {
                    canvas.pixel(x, py, roofDark)
                } else {
                    canvas.pixel(x, py, roofBlue)
                }
                // Bright accent stripe
                if row == 3 {
                    canvas.pixel(x, py, roofLight)
                }
            }
        }
    }

    // Clean geometric walls
    canvas.fillRect(bx, by + 10, 34, 24, buildOutline)
    canvas.fillRect(bx + 1, by + 11, 32, 22, wallClean)
    // Shade on left
    canvas.fillRect(bx + 1, by + 11, 5, 22, wallShade)

    // Large geometric window (left) - amber lit
    canvas.fillRect(bx + 5, by + 14, 10, 8, buildOutline)
    canvas.fillRect(bx + 6, by + 15, 8, 6, windowAmber)
    canvas.fillRect(bx + 6, by + 15, 3, 2, windowBright)
    // Clean cross dividers
    canvas.fillRect(bx + 10, by + 15, 1, 6, buildOutline)
    canvas.fillRect(bx + 6, by + 18, 8, 1, buildOutline)

    // Large geometric window (right)
    canvas.fillRect(bx + 21, by + 14, 10, 8, buildOutline)
    canvas.fillRect(bx + 22, by + 15, 8, 6, windowAmber)
    canvas.fillRect(bx + 22, by + 15, 3, 2, windowBright)
    canvas.fillRect(bx + 26, by + 15, 1, 6, buildOutline)
    canvas.fillRect(bx + 22, by + 18, 8, 1, buildOutline)

    // Crimson door with clean geometric frame
    canvas.fillRect(bx + 13, by + 24, 8, 10, buildOutline)
    canvas.fillRect(bx + 14, by + 25, 6, 9, doorCrimson)
    canvas.fillRect(bx + 14, by + 25, 2, 9, doorDark) // shadow side
    canvas.pixel(bx + 18, by + 29, rgb(248, 208, 128)) // brass knob
    // Accent stripe above door
    canvas.fillRect(bx + 12, by + 23, 10, 1, roofBlue)

    // Small accent flag/banner on roof
    canvas.fillRect(bx + 17, by + 3, 1, 7, buildOutline)
    canvas.fillRect(bx + 18, by + 3, 4, 3, scarfRed)
    canvas.fillRect(bx + 18, by + 5, 3, 1, scarfDark)

    // === TREES (stylized angular canopy, clean 2-tone) ===
    func drawModernTree(_ tx: Int, _ ty: Int) {
        // Clean trunk
        canvas.fillRect(tx, ty + 14, 1, 12, trunkOutline)
        canvas.fillRect(tx + 3, ty + 14, 1, 12, trunkOutline)
        canvas.fillRect(tx + 1, ty + 14, 2, 12, trunkClean)
        canvas.fillRect(tx, ty + 25, 4, 1, trunkOutline)

        // Angular/diamond-shaped canopy (stylized)
        let ccx = tx + 2, ccy = ty + 6
        // Diamond shape with angular edges
        for row in 0..<14 {
            let halfW: Int
            if row < 7 {
                halfW = 2 + row
            } else {
                halfW = 2 + (13 - row)
            }
            for dx in -halfW...halfW {
                let px = ccx + dx
                let py = ty + row
                if abs(dx) == halfW || row == 0 || row == 13 {
                    canvas.pixel(px, py, leafOutline)
                } else if dx < 0 {
                    canvas.pixel(px, py, leafDark)
                } else {
                    canvas.pixel(px, py, leafBright)
                }
            }
        }
    }

    drawModernTree(8, 34)
    drawModernTree(40, 30)
    drawModernTree(114, 32)

    // === CHARACTER (slightly elongated chibi, 32x48 concept, expressive) ===
    let chx = 52, chy = 62

    // Shadow
    for dx in -5...5 {
        for dy in 0...1 {
            if abs(dx) < 5 - dy {
                canvas.pixel(chx + 8 + dx, chy + 34 + dy, rgba(20, 40, 20, 0.3))
            }
        }
    }

    // Boots (warm amber)
    canvas.fillRect(chx + 3, chy + 29, 5, 5, charOutline)
    canvas.fillRect(chx + 4, chy + 30, 3, 3, bootsAmber)
    canvas.fillRect(chx + 4, chy + 30, 1, 3, bootsDark)
    canvas.fillRect(chx + 10, chy + 29, 5, 5, charOutline)
    canvas.fillRect(chx + 11, chy + 30, 3, 3, bootsAmber)
    canvas.fillRect(chx + 11, chy + 30, 1, 3, bootsDark)

    // Legs (dark pants, slim)
    canvas.fillRect(chx + 4, chy + 23, 4, 6, charOutline)
    canvas.fillRect(chx + 5, chy + 24, 2, 5, pantsGray)
    canvas.fillRect(chx + 5, chy + 24, 1, 5, pantsDark)
    canvas.fillRect(chx + 10, chy + 23, 4, 6, charOutline)
    canvas.fillRect(chx + 11, chy + 24, 2, 5, pantsGray)
    canvas.fillRect(chx + 11, chy + 24, 1, 5, pantsDark)

    // Body (electric blue jacket, fitted)
    canvas.fillRect(chx + 2, chy + 13, 14, 10, charOutline)
    canvas.fillRect(chx + 3, chy + 14, 12, 9, jacketBlue)
    canvas.fillRect(chx + 3, chy + 14, 3, 9, jacketDark)    // shadow side
    canvas.fillRect(chx + 12, chy + 14, 3, 9, jacketLight)  // highlight side
    // Jacket detail line
    canvas.fillRect(chx + 9, chy + 14, 1, 8, jacketDark)    // center seam

    // Arms
    canvas.fillRect(chx, chy + 14, 3, 9, charOutline)
    canvas.fillRect(chx + 1, chy + 15, 1, 7, jacketBlue)
    canvas.pixel(chx + 1, chy + 21, skinWarm) // hand
    canvas.fillRect(chx + 15, chy + 14, 3, 9, charOutline)
    canvas.fillRect(chx + 16, chy + 15, 1, 7, jacketBlue)
    canvas.pixel(chx + 16, chy + 21, skinWarm)

    // Bag/satchel on side
    canvas.fillRect(chx + 15, chy + 16, 3, 5, charOutline)
    canvas.fillRect(chx + 15, chy + 17, 2, 3, bagBrown)
    canvas.pixel(chx + 16, chy + 18, rgb(198, 148, 88)) // bag clasp

    // Scarf (crimson, flowing)
    canvas.fillRect(chx + 5, chy + 12, 8, 3, charOutline)
    canvas.fillRect(chx + 6, chy + 12, 6, 2, scarfRed)
    canvas.fillRect(chx + 6, chy + 12, 2, 2, scarfDark) // shadow fold
    // Scarf tail
    canvas.fillRect(chx + 14, chy + 12, 4, 2, charOutline)
    canvas.fillRect(chx + 14, chy + 12, 3, 1, scarfRed)
    canvas.fillRect(chx + 15, chy + 13, 2, 1, scarfRed)

    // Head (elongated chibi, head = 40% of body)
    let hhx = chx + 9, hhy = chy + 5
    let headR = 7
    for dy in -headR...headR {
        for dx in -(headR+1)...(headR+1) {
            let distSq = dx*dx + (dy * (headR+1)/headR) * (dy * (headR+1)/headR)
            if distSq <= (headR+1)*(headR+1) {
                let px = hhx + dx
                let py = hhy + dy
                if distSq > headR*headR {
                    canvas.pixel(px, py, charOutline)
                } else if dx < -3 {
                    canvas.pixel(px, py, skinShade)
                } else {
                    canvas.pixel(px, py, skinWarm)
                }
            }
        }
    }

    // Hair (dark, messy, stylized spikes)
    for dy in -headR...(-1) {
        for dx in -(headR+2)...(headR+2) {
            let inHead = dx*dx + (dy * (headR+1)/headR) * (dy * (headR+1)/headR) <= (headR+2)*(headR+2)
            if inHead {
                canvas.pixel(hhx + dx, hhy + dy, hairDark)
            }
        }
    }
    // Spiky hair tufts
    canvas.pixel(hhx - 4, hhy - headR - 1, hairDark)
    canvas.pixel(hhx - 2, hhy - headR - 2, hairDark)
    canvas.pixel(hhx, hhy - headR - 1, hairDark)
    canvas.pixel(hhx + 2, hhy - headR - 2, hairDark)
    canvas.pixel(hhx + 4, hhy - headR - 1, hairDark)
    // Hair shine
    canvas.pixel(hhx + 1, hhy - 4, hairShine)
    canvas.pixel(hhx + 2, hhy - 3, hairShine)
    canvas.pixel(hhx + 3, hhy - 4, hairShine)

    // Eyes (expressive, 2 highlights each)
    // Left eye
    canvas.fillRect(hhx - 4, hhy + 1, 3, 3, charOutline)
    canvas.pixel(hhx - 4, hhy + 1, rgb(255, 255, 255))  // highlight 1
    canvas.pixel(hhx - 3, hhy + 2, rgb(200, 200, 220))  // highlight 2
    // Right eye
    canvas.fillRect(hhx + 2, hhy + 1, 3, 3, charOutline)
    canvas.pixel(hhx + 2, hhy + 1, rgb(255, 255, 255))
    canvas.pixel(hhx + 3, hhy + 2, rgb(200, 200, 220))

    // Expressive eyebrows
    canvas.fillRect(hhx - 5, hhy, 4, 1, charOutline)
    canvas.fillRect(hhx + 2, hhy, 4, 1, charOutline)

    // Small determined mouth
    canvas.pixel(hhx - 1, hhy + 4, rgb(198, 128, 108))
    canvas.pixel(hhx, hhy + 4, rgb(198, 128, 108))
    canvas.pixel(hhx + 1, hhy + 4, rgb(198, 128, 108))

    // Label "C"
    let labelC: [[Int]] = [
        [0,1,1,1,1],
        [1,0,0,0,0],
        [1,0,0,0,0],
        [1,0,0,0,0],
        [1,0,0,0,0],
        [0,1,1,1,1],
    ]
    for (row, line) in labelC.enumerated() {
        for (col, val) in line.enumerated() {
            if val == 1 { canvas.pixel(3 + col, 3 + row, roofBlue) }
        }
    }

    let path = "/Users/alex/Desktop/DayQuest/mockups/style_c_modern.png"
    if canvas.save(to: path) {
        print("Style C saved: \(path)")
    }
}

// MARK: - Main

print("Generating DayQuest art style mockups...")
print("========================================")
generateStyleA()
generateStyleB()
generateStyleC()
print("========================================")
print("All mockups generated!")
print("")
print("Files:")
print("  /Users/alex/Desktop/DayQuest/mockups/style_a_stardew.png")
print("  /Users/alex/Desktop/DayQuest/mockups/style_b_chibi.png")
print("  /Users/alex/Desktop/DayQuest/mockups/style_c_modern.png")
