

//
//  SegmentedControl.swift
//  Segment
//
//  Created by Constantine Thalasinos on 2/6/23.
//

import UIKit

internal class SegmentedControl: UIView {
    
    
    private var titles: [String] = []
    
    internal weak var delegate: SegmentedControlDelegate?
    
    private let cellReuseIdentifier = "reuseIdentifier"
    
    internal private(set) var selectedIndex = 0
    
    private var selectorView = UIView()
    
    private var selectorColor = GTSegmentedControlConfiguration.defaultConfiguration.selectorColor{
        didSet{
            selectorView.backgroundColor = selectorColor
        }
    }
    
    private var configuration = GTSegmentedControlConfiguration.defaultConfiguration
    
    internal private(set) var labelSize: CGSize = CGSize(width: 0.0, height: 0.0)
    
    private var selectorDrawn = false
    
    private lazy var selectorScrollView: UIScrollView = {
        
        let view = UIScrollView(frame: .zero)
        
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var borderView = UIView()
    
    
    private lazy var collectionView: UICollectionView = {

        let layout = SegmentedControlCollectionViewLayout()
        layout.delegate = self

        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.isUserInteractionEnabled = true
        view.showsHorizontalScrollIndicator = false
        
        view.isScrollEnabled = true
        
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        layoutViews()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if !selectorDrawn{
            configureSelectorView()
            selectorDrawn = true
        }
       
    }
    
    
    func setTitles(titles: [String], config: GTSegmentedControlConfiguration){
        self.titles = titles
  
        collectionView.reloadData()
        
    }
    
    private func setLabelSize(titles: [String], config: GTSegmentedControlConfiguration){
        
        labelSize = getLabelSize(titles: titles, config: config)
        collectionView.heightAnchor.constraint(equalToConstant: labelSize.height).isActive = true
        
    }
    
    internal func reloadLayout(){
        collectionView.collectionViewLayout.invalidateLayout()

        setLabelSize(titles: titles, config: configuration)
        
        let frame = selectorView.frame
        
        selectorView.frame = CGRect(x: frame.minX, y: frame.minY, width: labelSize.width, height: frame.height)
    }
    
     private func layoutViews() {
       
         self.translatesAutoresizingMaskIntoConstraints = false
         collectionView.register(SegmentedControlCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)

                
         self.addSubview(collectionView)
         
         NSLayoutConstraint.activate([collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                      collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
                                      collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
                                      collectionView.topAnchor.constraint(equalTo: self.topAnchor)])
         
    }
    
   
    
    
    private func configureSelectorView(){
    
        let width = labelSize.width

        
        addSubview(selectorScrollView)
        
        selectorScrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        selectorScrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        
        selectorView = UIView(frame: CGRect(x: 0 , y: 0 , width: width, height: configuration.selectorHeight))
       // selectorView.translatesAutoresizingMaskIntoConstraints = false
        selectorView.backgroundColor = selectorColor
        //selectorView.translatesAutoresizingMaskIntoConstraints = false
        
        selectorView.widthAnchor.constraint(equalToConstant: width).isActive = true
        selectorView.heightAnchor.constraint(equalToConstant: configuration.selectorHeight).isActive = true
      
        
        selectorScrollView.addSubview(selectorView)
        

        if configuration.selectorViewPosition == .top{
            selectorScrollView.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        }
        else{
            selectorScrollView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        }
        
        selectorScrollView.heightAnchor.constraint(equalToConstant: configuration.selectorHeight).isActive = true
        
    }
    
    internal func applyConfiguration(config: GTSegmentedControlConfiguration){
        
        configuration = config
        
        selectorColor = config.selectorColor
        
        collectionView.reloadData()
    }

}

extension SegmentedControl{
    
    
    private func toggleCellStates(oldIndex: Int, newIndex: Int){
        
        //change currently selected cell styling
        if let deselectedCell = collectionView.cellForItem(at: IndexPath(item: oldIndex, section: 0)) as? SegmentedControlCell{
            deselectedCell.applyConfiguration(isSelected: false, config: configuration)
        }
        
        
        //change newly selected cell styling
        if let selectedCell = collectionView.cellForItem(at: IndexPath(item: newIndex, section: 0)) as? SegmentedControlCell{
            selectedCell.applyConfiguration(isSelected: true, config: configuration)
        }
    }
    
    
    
    private func scrollCollectionView(toPosition point: CGFloat){
        let rect = CGRect(x: point, y: collectionView.contentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height)
        
        self.collectionView.scrollRectToVisible(rect, animated: true)
    }
    
    
    /*
     moves the segment in response to buttons being pressed
     */
    
    private func moveSegment(toIndex index: Int){
        
        let newPosition = index == 0 ? 0 : labelSize.width * CGFloat(index)
        
        UIView.animate(withDuration: 0.3) { [self] in
            self.selectorView.frame.origin.x = newPosition
            
            scrollCollectionView(toPosition: newPosition)
            
            
        }
    }
    
    /*
     called in response to the user scrolling the collection view
     */
    
    internal func moveSegment(toOffset offset: CGFloat){
        let ratio = collectionView.contentSize.width/delegate!.collectionViewWidth
        
        self.selectorView.frame.origin.x = offset * ratio
        
        scrollCollectionView(toPosition: selectorView.frame.origin.x)
        
        if let index = getNewSelectedIndex(){
            toggleCellStates(oldIndex: selectedIndex, newIndex: index)
            selectedIndex = index
            
            
        }
    }
    
    /*
     checks to see if the user scrolled fully to another segment.
     Called by moveSegment to offset
     */
    
    private func getNewSelectedIndex() -> Int?{
        
        let offset = delegate!.collectionViewXOffset
        
        let cellWidth = (delegate!.collectionViewWidth/CGFloat(titles.count))
        
        let currentCellStart = selectedIndex == 0 ? 0: cellWidth * CGFloat(selectedIndex)
        
        let currentCellHalf = (currentCellStart) + cellWidth / 2
            
            //for cases where the user is scrolling to the left
            if offset < currentCellStart{
                
                guard selectedIndex > 0 else { return nil }
                
                let previousIndex = selectedIndex - 1
                    
                let previousCellStart = previousIndex == 0 ? 0: cellWidth * CGFloat(previousIndex)
                    
                let previousHalfwayPoint = (previousCellStart) + cellWidth / 2
                    
                if offset <= previousHalfwayPoint{
                    return previousIndex
                }
                else{
                    return nil
                }
               
            }
            //otherwise, we're going right
            else if offset > currentCellStart{

                guard selectedIndex < titles.count - 1 else { return nil }
                
                let nextIndex = selectedIndex + 1
                    
                if offset > currentCellHalf{
                    return nextIndex
                }
                else{
                    return nil
                }
                
            }
            else{
                return nil
            }
    }
        
    
}

extension SegmentedControl: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        selectorScrollView.contentOffset = scrollView.contentOffset
    }
    
}

extension SegmentedControl: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SegmentedControlCell
        
        cell.label.text = titles[indexPath.item]
        
        let selected = selectedIndex == indexPath.item ? true : false
        
        cell.applyConfiguration(isSelected: selected, config: configuration)

        return cell
    }
    
    
}

extension SegmentedControl: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let index = indexPath.item
        
        if selectedIndex != index{
            
            moveSegment(toIndex: index)
            
            let oldIndex = selectedIndex
            
            selectedIndex = index
            
            toggleCellStates(oldIndex: oldIndex, newIndex: selectedIndex)
            
            delegate?.moveCollectionView(toCellIndex: selectedIndex)
            
        }
        
    }
}

extension SegmentedControl: SegmentedControlCollectionViewLayoutDelegate{
    func collectionViewGetCellSize(_ collectionView: UICollectionView) -> CGSize {
        
        setLabelSize(titles: titles, config: configuration)

        return labelSize
    }
    
    func getLabelSize(titles: [String], config: GTSegmentedControlConfiguration) -> CGSize{
        let font = config.font
        
        guard var screenWidth = collectionView.window?.frame.width else { return CGSize(width: 0.0, height: 0.0)}
        
//        screenWidth = screenWidth - (collectionView.layoutMargins.left * 2)
        
        var maxWidth = CGFloat(integerLiteral: 0)
        var maxHeight = CGFloat(integerLiteral: 0)
        
        for title in titles{
            let frame = estimatedFrame(forText: title, withFont: font)
            
            maxWidth = frame.width > maxWidth ? frame.width : maxWidth
            maxHeight = frame.height > maxHeight ? frame.height : maxHeight
        }
        
       
        
        let countAsFloat = CGFloat(integerLiteral: titles.count)
        
        let totalPixels = countAsFloat * maxWidth
        
        
        if totalPixels < screenWidth{
            maxWidth = maxWidth/totalPixels * screenWidth
        }

        //threw an extra 5% on the labels because some were being cut off.
//        maxWidth = maxWidth * CGFloat(1.05)
        
        return CGSize(width: maxWidth, height: maxHeight)
        
    }
    
    //https://stackoverflow.com/questions/53589870/dynamic-width-cell-in-uicollectionview
    func estimatedFrame(forText text: String, withFont font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
    
}
