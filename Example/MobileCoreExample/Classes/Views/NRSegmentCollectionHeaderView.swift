//
//  FTSegmentCollectionHeaderView.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 13/10/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

let kRecentUpdateString = "Recent Update"
let kTopViews = "Top Views"

class FTSegmentCollectionHeaderView: UIView {
    var segmentedControl: UISegmentedControl? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSegmentView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSegmentView()
    }

    func setupSegmentView(_ items: [Any] = [ kRecentUpdateString, kTopViews ]) {

        // Remove previous segment
        segmentedControl?.removeSubviews()

        segmentedControl = UISegmentedControl(items: items) { (segment) in
            ftLog(segment)
        }

        self.theme = ThemeStyle.defaultStyle
        segmentedControl?.theme = ThemeStyle.defaultStyle

        if let segment = segmentedControl {
            self.pin(view: segment, edgeOffsets: UIEdgeInsets(10))
        }
    }
}