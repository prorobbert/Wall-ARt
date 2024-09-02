//
//  AppFont.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 15/08/2024.
//

import SwiftUI

struct AppFont: ViewModifier {

    var fontStyle: FontStyle

    func body(content: Content) -> some View {
        content.font(font)
    }

    private var font: Font {
        let baseFont: Font
        if let name = fontName {
            baseFont = .custom(name, size: size)
        } else {
            baseFont = .system(size: size, weight: weight)
        }

        return baseFont
    }

    private var weight: Font.Weight {
        switch fontStyle {
        case .largeTitleEmpasized, .title1Empasized, .title2Empasized, .title3Empasized:
            return .bold
        case .headline, .bodyEmpasized, .calloutEmpasized, .subHeadlineEmpasized, .footnoteEmpasized, .caption1Empasized, .caption2Empasized:
            return .semibold
        case .largeTitle, .title1, .title2, .title3, .body, .callout, .subHeadline, .footnote, .caption1, .caption2:
            return .regular
        }
    }

    private var fontName: String? {
        switch fontStyle {
        case .largeTitleEmpasized, .title1Empasized, .title2Empasized, .title3Empasized:
            return "Outfit-Bold"
        case .headline, .bodyEmpasized, .calloutEmpasized, .subHeadlineEmpasized, .footnoteEmpasized, .caption1Empasized, .caption2Empasized:
            return "Outfit-SemiBold"
        case .largeTitle, .title1, .title2, .title3, .body, .callout, .subHeadline, .footnote, .caption1, .caption2:
            return "Outfit-Regular"
        }
    }

    private var size: CGFloat {
        switch fontStyle {
        case .largeTitle:
            34
        case .largeTitleEmpasized:
            34
        case .title1:
            28
        case .title1Empasized:
            28
        case .title2:
            22
        case .title2Empasized:
            22
        case .title3:
            20
        case .title3Empasized:
            20
        case .headline:
            17
        case .body:
            17
        case .bodyEmpasized:
            17
        case .callout:
            16
        case .calloutEmpasized:
            16
        case .subHeadline:
            15
        case .subHeadlineEmpasized:
            15
        case .footnote:
            13
        case .footnoteEmpasized:
            13
        case .caption1:
            12
        case .caption1Empasized:
            12
        case .caption2:
            11
        case .caption2Empasized:
            11
        }
    }
}
