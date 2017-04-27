//
//  ViewDetails.swift
//  Example
//
//  Created by Bruno Macabeus Aquino on 24/04/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import TvLightSegments

class ViewDetails: UIViewController, TvLightSegmentsDisplay {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var textDetails: UITextView!
    @IBOutlet weak var image: UIImageView!
    
    // Oh! A segments' focus was changed! Then, execute this method ⚡️
    func didChangeSegment(_ segmentItem: TvLightSegmentsItem) {
        let pokemon = segmentItem as! Pokemon
        
        name.text = pokemon.name
        textDetails.text = pokemon.desc
        image.image = pokemon.image
    }
    
}
