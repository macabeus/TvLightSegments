//
//  Cell.swift
//  TvLightSegments
//
//  Created by Bruno Macabeus Aquino on 23/04/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

protocol CellSegmentDelegate {
    func cellIsCurrentFocused(_ cell: UICollectionViewCell) -> Bool
}

class CellSegment: UICollectionViewCell {
    
    @IBOutlet weak var labelSegmentName: UILabel!
    @IBOutlet weak var viewFooter: UIView!
    
    var delegate: CellSegmentDelegate?
    var segmentItem: TvLightSegmentsItem?
    var display: TvLightSegmentsDisplay?
    var transitionConfig: TransitionConfig?
    
    var labelColorSelected: UIColor?
    var labelColorNotSelected: UIColor?
    var viewFooterColorSelected: UIColor?
    var viewFooterColorNotSelected: UIColor?
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if self === context.previouslyFocusedItem {
            
            if ((context.nextFocusedItem as? CellSegment) != nil) {
                coordinator.addCoordinatedAnimations({
                    self.changeToNotSelected()
                }, completion: nil)
            } else {
                coordinator.addCoordinatedAnimations({
                    self.changeToSelected()
                }, completion: nil)
            }
        
        } else if self === context.nextFocusedItem {
            coordinator.addCoordinatedAnimations({
                self.changeToFocused()
            }, completion: nil)
            
            if context.previouslyFocusedItem != nil && (context.previouslyFocusedItem as? CellSegment) == nil {
                return
            }
            
            if let transitionConfig = transitionConfig {
                UIView.animate(
                    withDuration: transitionConfig.transitionStartTime,
                    animations: transitionConfig.transitionStart(display!),
                    completion: { _ in
                        if self.delegate!.cellIsCurrentFocused(self) { // avoid race condition
                            self.display!.didChangeSegment(self.segmentItem!)
                        }
                        
                        UIView.animate(
                            withDuration: transitionConfig.transitionEndTime,
                            animations: transitionConfig.transitionEnd(self.display!),
                            completion: nil
                        )
                    }
                )
                
            } else {
                self.display!.didChangeSegment(self.segmentItem!)
            }
        }
    }
    
    func changeToNotSelected() {
        self.viewFooter.backgroundColor = viewFooterColorNotSelected!
        self.labelSegmentName.textColor = labelColorNotSelected!
        self.viewFooter.layer.shadowOpacity = 0
    }
    
    func changeToSelected() {
        self.viewFooter.backgroundColor = viewFooterColorSelected!
        self.labelSegmentName.textColor = labelColorSelected!
        self.viewFooter.layer.shadowOpacity = 0
    }
    
    func changeToFocused() {
        self.viewFooter.backgroundColor = viewFooterColorSelected!
        self.labelSegmentName.textColor = labelColorSelected!
        self.viewFooter.layer.shadowOpacity = 1
    }
}
