//
//  main.swift
//  TvLightSegments
//
//  Created by Bruno Macabeus Aquino on 24/04/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import Cartography

/**
 Protocol for the class that will be notified when the segment's focus is changed
 */
public protocol TvLightSegmentsDisplay {
    /**
     Method called when a item is changed
     
     - parameter segmentItem: segment currenlty focused
     */
    func didChangeSegment(_ segmentItem: TvLightSegmentsItem)
}

/**
 Protocol for the class to can be added in the segment
 */
public protocol TvLightSegmentsItem {
    /**
     Text that will show in segment
     */
    func tvLightSegmentsName() -> String
}

/**
 Struct about a transition animation between the segments' focus
 */
public struct TransitionConfig {
    let transitionStart: (TvLightSegmentsDisplay) -> (() -> Void)
    let transitionStartTime: TimeInterval
    let transitionEnd: (TvLightSegmentsDisplay) -> (() -> Void)
    let transitionEndTime: TimeInterval
    
    public init(transitionStart: @escaping (TvLightSegmentsDisplay) -> (() -> Void), transitionStartTime: TimeInterval, transitionEnd: @escaping (TvLightSegmentsDisplay) -> (() -> Void), transitionEndTime: TimeInterval) {
        
        self.transitionStart = transitionStart
        self.transitionStartTime = transitionStartTime
        self.transitionEnd = transitionEnd
        self.transitionEndTime = transitionEndTime
    }
}

public class TvLightSegments: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var segmentsItems: [TvLightSegmentsItem] = []
    var viewDisplay: TvLightSegmentsDisplay?
    
    var selectedIndex = IndexPath()
    var shouldSelectEspecificTab = false
    
    public var transitionConfig: TransitionConfig?
    
    public var labelColorNotSelected = #colorLiteral(red: 0.4235294118, green: 0.4470588235, blue: 0.5607843137, alpha: 1)
    public var labelColorSelected = #colorLiteral(red: 0.5529411765, green: 0.4, blue: 0.7411764706, alpha: 1)
    public var viewFooterColorSelected = #colorLiteral(red: 0.5529411765, green: 0.4, blue: 0.7411764706, alpha: 1)
    public var viewFooterColorNotSelected = #colorLiteral(red: 0.4235294118, green: 0.4470588235, blue: 0.5607843137, alpha: 1)
    
    /**
     Initialize a TvLightSegments.
     
     - parameter viewDisplay: object that will be notified when a segment's focus is changed
     */
    public func setup(viewDisplay: TvLightSegmentsDisplay) {
        
        // setup UICollectionView
        self.delegate = self
        self.dataSource = self
        self.collectionViewLayout = TvLightSegmentsLayout(delegate: self)
        self.register(UINib(nibName: "CellSegment", bundle: Bundle(for: TvLightSegments.self)), forCellWithReuseIdentifier: "CellSegment")
        
        // bottom bar
        let viewLargeFooter = UIView()
        viewLargeFooter.backgroundColor = viewFooterColorNotSelected
        
        self.superview!.addSubview(viewLargeFooter)
        self.superview!.sendSubview(toBack: viewLargeFooter)
        self.backgroundColor = UIColor(white: 1, alpha: 0)
        
        constrain(self, viewLargeFooter) { tvLightSegments, largeFooter in
            largeFooter.left == tvLightSegments.left + 14
            largeFooter.right == tvLightSegments.right
            
            largeFooter.height == 5
            largeFooter.top == tvLightSegments.top + 50
        }
        
        // TvLightSegments
        self.viewDisplay = viewDisplay
    }
    
    /**
     Set/update the segments
     
     - parameter segmentsItems: array with the new segments
     */
    public func set(segmentsItems: [TvLightSegmentsItem]) {
        
        self.segmentsItems = segmentsItems
        
        UIView.animate(withDuration: 0, animations: {
            self.performBatchUpdates({
                self.reloadSections(IndexSet(integer: 0))
            }, completion: { _ -> Void in
                
                if segmentsItems.count > 0 {
                    self.viewDisplay!.didChangeSegment(segmentsItems[0])
                    self.selectedIndex = IndexPath(row: 0, section: 0)
                }
            })
        })
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentsItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSegment", for: indexPath) as! CellSegment
        
        let currentSegment = segmentsItems[indexPath.item]
        
        cell.delegate = self
        cell.segmentItem = currentSegment
        cell.display = viewDisplay!
        cell.transitionConfig = transitionConfig
        
        // set label
        cell.labelSegmentName.text = currentSegment.tvLightSegmentsName()
        cell.labelSegmentName.sizeToFit()
        
        // colors
        cell.viewFooter.backgroundColor = viewFooterColorNotSelected
        cell.labelSegmentName.textColor = labelColorNotSelected
        cell.labelColorSelected = labelColorSelected
        cell.labelColorNotSelected = labelColorNotSelected
        cell.viewFooterColorSelected = viewFooterColorSelected
        cell.viewFooterColorNotSelected = viewFooterColorNotSelected
        
        // shadow
        cell.viewFooter.layer.shadowColor = UIColor.white.cgColor
        cell.viewFooter.layer.shadowOpacity = 0
        
        // constrains
        cell.viewFooter.removeConstraints(cell.viewFooter.constraints)
        constrain(cell.labelSegmentName, cell.viewFooter) { label, footerCenter in
            label.top == label.superview!.topMargin
            label.left == label.superview!.leftMargin + 15
            label.right == label.superview!.rightMargin + 15
            
            footerCenter.top == label.bottom + 5
            footerCenter.width == cell.labelSegmentName.frame.width
            footerCenter.left == label.left
            
            footerCenter.height == 5
        }
        
        //
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        
        if context.previouslyFocusedIndexPath != nil && context.nextFocusedIndexPath == nil {
            shouldSelectEspecificTab = true
        } else {
            shouldSelectEspecificTab = false
        }
        if context.nextFocusedIndexPath != nil {
            if context.previouslyFocusedIndexPath != nil {
                selectedIndex = context.nextFocusedIndexPath!
            }
        }
        
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        
        if shouldSelectEspecificTab && indexPath.row != selectedIndex.row {
            return false
        }
        return true
    }
}

extension TvLightSegments: TvLightSegmentsLayoutDelegate {
    public func getSegmentsTextSize() -> [CGSize] {
        return segmentsItems.map { $0.tvLightSegmentsName().labelFrameSize() }
    }
}

extension TvLightSegments: CellSegmentDelegate {
    func cellIsCurrentFocused(_ cell: UICollectionViewCell) -> Bool {
        return indexPath(for: cell) == selectedIndex
    }
}

extension String {
    func labelFrameSize() -> CGSize {
        let labelFak = UILabel()
        labelFak.text = self
        labelFak.sizeToFit()
        
        return CGSize(width: labelFak.frame.size.width + 20, height: labelFak.frame.size.height)
    }
}
