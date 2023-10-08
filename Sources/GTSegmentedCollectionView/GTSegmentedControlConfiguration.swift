//
//  SegmentedControlConfiguration.swift
//  Segment
//
//  Created by Constantine Thalasinos on 2/18/23.
//

import Foundation
import UIKit

public struct GTSegmentedControlConfiguration{
    var selectorColor: UIColor
    var selectorHeight: CGFloat
    var selectorViewPosition: BarPosition
    
    var selectedBackgroundColor: UIColor
    var selectedTextColor: UIColor
    
    var deselectedBackgroundColor: UIColor
    var deselectedTextColor: UIColor
    
    var textAlignment: NSTextAlignment
    var font: UIFont
    
    var segmentBorderWidth: CGFloat
    var segmentBorderColor: UIColor?
    
    static let defaultConfiguration: GTSegmentedControlConfiguration = GTSegmentedControlConfiguration(selectorColor: .systemBlue, selectorHeight: 1.0, selectorViewPosition: .bottom, selectedBackgroundColor: .systemBackground, selectedTextColor: .label, deselectedBackgroundColor: .systemBackground, deselectedTextColor: .gray, textAlignment: .center, font: UIFont.systemFont(ofSize: 14), segmentBorderWidth: 0.5, segmentBorderColor: .lightGray)
    
    public init(selectorColor: UIColor, selectorHeight: CGFloat, selectorViewPosition: BarPosition, selectedBackgroundColor: UIColor, selectedTextColor: UIColor, deselectedBackgroundColor: UIColor, deselectedTextColor: UIColor, textAlignment: NSTextAlignment, font: UIFont, segmentBorderWidth: CGFloat, segmentBorderColor: UIColor? = nil) {
        self.selectorColor = selectorColor
        self.selectorHeight = selectorHeight
        self.selectorViewPosition = selectorViewPosition
        self.selectedBackgroundColor = selectedBackgroundColor
        self.selectedTextColor = selectedTextColor
        self.deselectedBackgroundColor = deselectedBackgroundColor
        self.deselectedTextColor = deselectedTextColor
        self.textAlignment = textAlignment
        self.font = font
        self.segmentBorderWidth = segmentBorderWidth
        self.segmentBorderColor = segmentBorderColor
    }
    
    
    public enum BarPosition{
        case top, bottom
    }
    
}
