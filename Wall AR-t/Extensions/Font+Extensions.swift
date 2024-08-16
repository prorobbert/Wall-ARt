//
//  Font+Extensions.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 16/08/2024.
//

import SwiftUI

extension Font {

    enum FontName: String, CaseIterable {
        case outfitRegular = "Outfit-Regular"
        case outfitSemiBold = "Outfit-SemiBold"
    }

    static func custom(_ fontName: FontName, size: CGFloat) -> Font {
        return Font.custom(fontName.rawValue, size: size)
    }

    var monospacedDigitFont: Font {
        self.monospacedDigit()
    }
}
