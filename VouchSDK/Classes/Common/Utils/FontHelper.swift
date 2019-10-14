//
//  FontHelper.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 19/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

internal enum FontHelperEnum: String {
    case josefinsans = "JosefinSans"
    case montserrat = "Montserrat"
    case opensanscondensed = "OpenSansCondensed"
    case oswald = "Oswald"
    case playfairdisplay = "PlayfairDisplay"
    case roboto = "Roboto"
    case sanchez = "Sanchez"
    case spectral = "Spectral"
    case unknown = ""
    
    var boldFont: String {
        return self.rawValue + "-Bold"
    }
    var regularFont: String {
        return self.rawValue + "-Regular"
    }
}

internal class FontHelper: NSObject {
    static func font(fontEnum: FontHelperEnum, currentFont: UIFont)-> UIFont {
        let isBold = currentFont.fontName.lowercased().contains("bold")
        if fontEnum == .unknown {
            return currentFont
        } else {
            let fontName = fontEnum.rawValue + "-\(isBold ? "Bold" : "Regular")"
            let fontSize = currentFont.pointSize
            guard let newFont = UIFont(name: fontName, size: fontSize) else { return currentFont }
            return newFont
        }
    }
    
    // Lazy var instead of method so it's only ever called once per app session.
    public static var loadFonts: () -> Void = {
        let fontNames = [
            FontHelperEnum.josefinsans.regularFont,
            FontHelperEnum.josefinsans.boldFont,
            FontHelperEnum.montserrat.regularFont,
            FontHelperEnum.montserrat.boldFont,
            FontHelperEnum.opensanscondensed.regularFont,
            FontHelperEnum.opensanscondensed.boldFont,
            FontHelperEnum.oswald.regularFont,
            FontHelperEnum.oswald.boldFont,
            FontHelperEnum.playfairdisplay.regularFont,
            FontHelperEnum.playfairdisplay.boldFont,
            FontHelperEnum.roboto.regularFont,
            FontHelperEnum.roboto.boldFont,
            FontHelperEnum.sanchez.regularFont,
            FontHelperEnum.sanchez.boldFont,
            FontHelperEnum.spectral.regularFont,
            FontHelperEnum.spectral.boldFont
        ].map { $0 }
        for fontName in fontNames {
            loadFont(withName: fontName)
        }
        return {}
    }()
    
    private static func loadFont(withName fontName: String) {
        guard
            let bundleURL = Bundle(for: self).url(forResource: "VouchSDK", withExtension: "bundle"),
            let bundle = Bundle(url: bundleURL),
            let fontURL = bundle.url(forResource: fontName, withExtension: "ttf"),
            let fontData = try? Data(contentsOf: fontURL) as CFData,
            let provider = CGDataProvider(data: fontData),
            let font = CGFont(provider) else {
                return
        }
        CTFontManagerRegisterGraphicsFont(font, nil)
    }

}
