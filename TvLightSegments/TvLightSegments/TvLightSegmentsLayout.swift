//
//  TvLightSegmentsLayout.swift
//  TvLightSegments
//
//  Created by Bruno Macabeus Aquino on 18/07/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

public protocol TvLightSegmentsLayoutDelegate {
    func getSegmentsTextSize() -> [CGSize]
}

public class TvLightSegmentsLayout: UICollectionViewLayout {
    
    public var delegate: TvLightSegmentsLayoutDelegate
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat {
        return collectionView!.bounds.height
    }
    
    private var contentWidth: CGFloat {
        return delegate.getSegmentsTextSize().reduce(0) { $0 + $1.width }
    }
    
    ////
    // init
    required public init(delegate: TvLightSegmentsLayoutDelegate) {
        self.delegate = delegate
        
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ////
    override public func prepare() {
        
        if cache.isEmpty {
            var xOffset: CGFloat = 0.0
            var indexPathItem = 0
            
            for labelSize in delegate.getSegmentsTextSize() {
                let frame = CGRect(
                    x: xOffset,
                    y: 0,
                    width: labelSize.width,
                    height: collectionView!.bounds.height
                )
                
                xOffset += labelSize.width
                
                let indexPath = IndexPath(item: indexPathItem, section: 0)
                indexPathItem += 1
                
                let insetFrame = frame.insetBy(dx: 0, dy: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                
                cache.append(attributes)
            }
        }
    }
    
    ////
    // return the size of the collectionview
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    ////
    // return cache to draw the cells at collectionview
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cache[indexPath.item]
    }
}
