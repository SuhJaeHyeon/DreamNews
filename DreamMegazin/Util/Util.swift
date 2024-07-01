//
//  Util.swift
//  DreamMegazin
//
//  Created by martin on 6/26/24.
//

import Foundation
import SwiftUI
let MAIN_BACK_COLOR = Color(hex: 0xF2EBDF)
let MAIN_BACK_COLOR2 = Color(hex: 0x888C8A)
let MAIN_BACK_COLOR3 = Color(hex: 0x0F1D26)         // 버튼들 
let MAIN_BACK_COLOR4 = Color(hex: 0x010D26)
let MAIN_BACK_COLOR5 = Color(hex: 0x041340)


extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension Font {
    
    // Bold
    static let ChosunFont14: Font = .custom("ChosunilboNM", size: 14)
    static let ChosunFont20: Font = .custom("ChosunilboNM", size: 20)
    static let ChosunFont28: Font = .custom("ChosunilboNM", size: 28)
    static let HeroBold14: Font = HeroLightFont(14, bold: true)
    static let HeroBold20: Font = HeroLightFont(20, bold: true)
    static let HeroBold28: Font = HeroLightFont(28, bold: true)
    static let Hero14: Font = HeroLightFont(14, bold: false)
    static let Hero20: Font = HeroLightFont(20, bold: false)
    static let Hero28: Font = HeroLightFont(28, bold: false)
    static func ChosunFont(size:Int) -> Font{
        return .custom("ChosunilboNM", size: CGFloat(size))
    }
    static func HeroLightFont(_ size:Int, bold:Bool) -> Font{
        if bold {
            return .custom("HeirofLightOTFBold", size: CGFloat(size))
        } else {
            return .custom("HeirofLightOTFRegular", size: CGFloat(size))
        }
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func getLogsDirectory() -> URL {
    let logsDirectory = getDocumentsDirectory().appendingPathComponent("LOG")
    if !FileManager.default.fileExists(atPath: logsDirectory.path) {
        do {
            try FileManager.default.createDirectory(at: logsDirectory, withIntermediateDirectories: true, attributes: nil)
            print("LOG 폴더가 생성되었습니다.")
        } catch {
            print("LOG 폴더를 생성하는 데 실패했습니다: \(error.localizedDescription)")
        }
    }
    return logsDirectory
}
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}
