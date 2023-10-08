//
//  SegmentedControlDelegate.swift
//  Segment
//
//  Created by Constantine Thalasinos on 2/25/23.
//

import Foundation


internal protocol SegmentedControlDelegate: AnyObject{
    
    func moveCollectionView(toCellIndex index: Int)
    
    var collectionViewWidth: CGFloat { get }
    
    var collectionViewXOffset: CGFloat { get }
    
}
