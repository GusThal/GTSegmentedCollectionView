//
//  SegmentedControlCollectionViewLayout.swift
//  Segment
//
//  Created by Constantine Thalasinos on 2/11/23.
//

import UIKit

internal class SegmentedControlCollectionViewLayout: UICollectionViewFlowLayout {
    
    weak var delegate: SegmentedControlCollectionViewLayoutDelegate?
    
    
    override func prepare() {
        
        guard let collectionView = collectionView else { return}
        
        self.itemSize = delegate!.collectionViewGetCellSize(collectionView)
        
        self.scrollDirection = .horizontal
        
        self.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        //self.minimumInteritemSpacing = 0
        
        self.sectionInsetReference = .fromSafeArea
        
        //spacing between cells
        minimumLineSpacing = 0
        
    }
    

}

internal protocol SegmentedControlCollectionViewLayoutDelegate: AnyObject{
    
    func collectionViewGetCellSize(_ collectionView: UICollectionView) -> CGSize
    

}
