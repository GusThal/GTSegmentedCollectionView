//
//  SegmentedCollectionViewController.swift
//  Segment
//
//  Created by Constantine Thalasinos on 2/6/23.
//

import UIKit

open class GTSegmentedCollectionViewController: UIViewController {
    
    public typealias Segment = (title: String, viewController: UIViewController)

    
    private var userScroll = false
    
    private var scrollOffset = CGPoint(x: 0, y: 0)
    
    private let segmentedControl =  SegmentedControl()
    
    private var segmentHeight: CGFloat = 0.0
    
    private var collectionViewHeight: CGFloat = 0.0
    
    private var borderView = UIView()
    
    private var borderDrawn = false
    
    public var segmentedControlConfiguration: GTSegmentedControlConfiguration = GTSegmentedControlConfiguration.defaultConfiguration{
        didSet{
            
            segmentedControl.applyConfiguration(config: segmentedControlConfiguration)
            drawBorderView(config: segmentedControlConfiguration)
            
            collectionView.reloadData()
        }
    }
    
    private var segmentTitles: [String] = []{
        didSet{
            segmentedControl.setTitles(titles: segmentTitles, config: segmentedControlConfiguration)
            
        }
    }
    
    
    private let cellReuseIdentifier = "reuseIdentifier"
    
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = CGFloat(0)
        layout.minimumLineSpacing = CGFloat(0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.showsHorizontalScrollIndicator = false
        
        view.isScrollEnabled = true
        
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    public func setSegments(segments: [Segment]){
        var titles = [String]()
        
        for segment in segments{
            titles.append(segment.title)
            addChild(segment.viewController)
            segment.viewController.didMove(toParent: self)
        }
        
        segmentTitles = titles
        
        collectionView.reloadData()
    }
    

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         
        segmentHeight = segmentedControl.labelSize.height + segmentedControlConfiguration.selectorHeight
        segmentedControl.heightAnchor.constraint(equalToConstant: segmentHeight).isActive = true
        
        if !borderDrawn{
            drawBorderView(config: segmentedControlConfiguration)
        }
        
        collectionView.reloadData()

    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        segmentedControl.reloadLayout()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.delegate = self
        
        view.addSubview(segmentedControl)
        
        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.register(SegmentedCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    private func drawBorderView(config: GTSegmentedControlConfiguration){
        borderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        borderView.backgroundColor = config.segmentBorderColor
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(borderView)
        
        NSLayoutConstraint.activate([
            borderView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            borderView.heightAnchor.constraint(equalToConstant: config.segmentBorderWidth),
            borderView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor)
        ])
        
        borderDrawn = true
    }

}
extension GTSegmentedCollectionViewController: UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return segmentTitles.count
        
    }
    

    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SegmentedCollectionViewCell
        
        
        cell.hostedView = children[indexPath.item].view
        
        
        return cell
        
    }
    
    
}

extension GTSegmentedCollectionViewController: UICollectionViewDelegate{
    
}

extension GTSegmentedCollectionViewController: UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let frame = self.view.window?.frame else { return CGSize(width: 0.0, height: 0.0) }
        
        collectionViewHeight = frame.height
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }
}

extension GTSegmentedCollectionViewController: SegmentedControlDelegate{
    
    internal var collectionViewXOffset: CGFloat {
        return collectionView.contentOffset.x
    }
    
    
    internal var collectionViewWidth: CGFloat {
        return collectionView.contentSize.width
    }
    
    internal func moveCollectionView(toCellIndex index: Int) {
        
        if index == 0{
            let frame = CGRect(x: 0, y: collectionView.contentOffset.y, width: collectionView.frame.width / CGFloat(segmentTitles.count), height: self.collectionView.frame.height)
            collectionView.scrollRectToVisible(frame, animated: true)
        }
        else{
            let frame = CGRect(x: collectionView.frame.maxX * CGFloat(index), y: collectionView.contentOffset.y, width: collectionView.frame.width, height: self.collectionView.frame.height)

            collectionView.scrollRectToVisible(frame, animated: true)
        }
        
    }
    
}

extension GTSegmentedCollectionViewController: UIScrollViewDelegate{
    
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollOffset = scrollView.contentOffset
        userScroll = true
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        if userScroll{
            
        }
        
        userScroll = false
        
    }
   
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let deltaX = abs(scrollOffset.x - scrollView.contentOffset.x)
        let deltaY = abs(scrollOffset.y - scrollView.contentOffset.y)
        
        
        if userScroll{
        
            if deltaX >= deltaY{
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollOffset.y)
                
                segmentedControl.moveSegment(toOffset: scrollView.contentOffset.x)
            }
            else{
                scrollView.contentOffset = CGPoint(x: scrollOffset.x, y: scrollView.contentOffset.y)
            }
            
        }
        
    }
}
