//
//  SegmentedControlCell.swift
//  Segment
//
//  Created by Constantine Thalasinos on 2/6/23.
//

import UIKit

internal class SegmentedControlCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
 
        return label
        
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        
        
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     label.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                                    ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func applyConfiguration(isSelected: Bool, config: SegmentedControlConfiguration){
        
        if isSelected{
            label.textColor = config.selectedTextColor
            label.backgroundColor = config.selectedBackgroundColor
            
        }
        else{
            label.textColor = config.deselectedTextColor
            label.backgroundColor = config.deselectedBackgroundColor
        }
        
        label.font = config.font
        label.textAlignment = config.textAlignment
        
    }
    
}
