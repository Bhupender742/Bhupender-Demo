//
//  Constants.swift
//  Upstox
//
//  Created by Lucifer on 25/12/24.
//

import Foundation

enum Constants {
    enum HeightConstant {
        static let expandedBottomViewHeight: CGFloat = 180
        static let shrinkedBottomViewHeight: CGFloat = 56
        static let expandedBottomTableViewHeight: CGFloat = 120
    }
    
    enum ImageName {
        static let upTriangleArrow = "arrowtriangle.up.fill"
        static let downTriangleArrow = "arrowtriangle.down.fill"
        static let backArrow = "arrowshape.turn.up.backward"
    }
    
    enum FontConstant {
        static let commonFontHeight: CGFloat = 16
    }
    
    enum CustomStringFormats {
        static let rupeeSign = "\u{20B9}"
        static let formattedValueString = "%.2f"
    }
}
