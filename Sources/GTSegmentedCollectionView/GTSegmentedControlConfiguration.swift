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
    
    
    
    
    enum BarPosition{
        case top, bottom
    }
    
}
