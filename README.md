# GTSegmentedCollectionView

A dependency-free Swift package for iOS inspired by Twitter/X and TikTok’s home screens. 

A horizontal paging UICollectionView linked to a custom Segmented Control, where each CollectionView Cell contains an embedded UIViewController that corresponds to a Segment in the Segmented Control. Pressing a Segment scrolls the CollectionView to the corresponding ViewController Cell, and paging the CollectionView updates the Segmented Control accordingly.


https://github.com/GusThal/GTSegmentedCollectionView/assets/25615604/ee7514be-3fb3-4851-bf6e-de8a4bccc651


## Features
- Infinite number of segments
- customize the height and width of the Segmented Control's selector view, and position it on either the top or bottom.
- customize the background color and text color of both selected and deselected segments.
- customize the text alignment and font of the Segmented Control's labels.
- customize the thickness and color of the border separating the Segmented Control from the CollectionView.
- Built in default configuration for easy setup.

## Requirements
- iOS 16+
- Swift 5.9+

## Installation

In your Xcode project, simply select File > Add Package Dependency, and enter the URL of this repository. 

For more info on adding packages to Xcode, check out Apple's official [documentation.](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

## Usage

simply subclass GTSegmentedCollectionViewController, and call `public func setSegments(segments: [Segment])` in viewDidLoad() and supply an array containing your Segments. Segment is a simply typealias: `public typealias Segment = (title: String, viewController: UIViewController)`

You can optionally set `public var segmentedControlConfiguration: GTSegmentedControlConfiguration`.

If the configuration is not set, the default configuration will be used: 
```
    static let defaultConfiguration: GTSegmentedControlConfiguration = GTSegmentedControlConfiguration(selectorColor: .systemBlue, selectorHeight: 1.0, selectorViewPosition: .bottom, selectedBackgroundColor: .systemBackground, selectedTextColor: .label, deselectedBackgroundColor: .systemBackground, deselectedTextColor: .gray, textAlignment: .center, font: UIFont.systemFont(ofSize: 14), segmentBorderWidth: 0.5, segmentBorderColor: .lightGray)
    
```

Here's how the screen grab above was created. (the TableViewController just creates 100 rows containing the string passed via the constructor): 

```
import GTSegmentedCollectionView

class ViewController: GTSegmentedCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "GTSegmentedCollectionView"
        
        setSegments(segments: [Segment(title: "For You", viewController: TableViewController(string: "For You")), Segment(title: "Following", viewController: TableViewController(string: "Following")), Segment(title: "Trending", viewController: TableViewController(string: "Trending")), Segment(title: "Hockey", viewController: TableViewController(string: "Hockey")), Segment(title: "Football", viewController: TableViewController(string: "Football")), Segment(title: "Soccer", viewController: TableViewController(string: "Soccer")), Segment(title: "Music", viewController: TableViewController(string: "Music"))])
        
        
        segmentedControlConfiguration = GTSegmentedControlConfiguration(selectorColor: .systemBlue, selectorHeight: 2.0, selectorViewPosition: .bottom, selectedBackgroundColor: .systemBackground, selectedTextColor: .label, deselectedBackgroundColor: .systemBackground, deselectedTextColor: .gray, textAlignment: .center, font: UIFont.systemFont(ofSize: 14), segmentBorderWidth: 0.5, segmentBorderColor: .gray)

    }

}
```
