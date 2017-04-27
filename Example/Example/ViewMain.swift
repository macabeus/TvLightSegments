//
//  ViewController.swift
//  Example
//
//  Created by Bruno Macabeus Aquino on 24/04/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit
import TvLightSegments

// Subscribert the TvLightSegmentsItem protocol, to Pokemon's object can be used in TvLightSegments
class Pokemon: TvLightSegmentsItem {
    
    let name: String
    let desc: String
    let image: UIImage
    
    init(name: String, desc: String, image: UIImage) {
        self.name = name
        self.desc = desc
        self.image = image
    }
    
    func tvLightSegmentsName() -> String {
        return name
    }
}

class ViewMain: UIViewController {
    
    @IBOutlet weak var segments: TvLightSegments!
    @IBOutlet weak var container: UIView!
    var containerViewDetails: ViewDetails?
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // You can change the colors 🎨
        // Hey! Change the colors *before* the setup(viewDisplay:) method!!!
        /*
        segments.labelColorSelected = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        segments.labelColorNotSelected = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        segments.viewFooterColorSelected = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        segments.viewFooterColorNotSelected = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
         */
        
        // Set a transition animation when a segment's focus is changes 🎬
        // Hey! If you prefer, you can comment this section AND "...view.alpha = 0" in prepare(for segue:)
        segments.transitionConfig = TransitionConfig(
            transitionStart: { display in
                return { (display as! UIViewController).view!.alpha = 0 }
        },
            transitionStartTime: 0.5,
            transitionEnd: { display in
                return { (display as! UIViewController).view!.alpha = 1 }
        },
            transitionEndTime: 0.5
        )
        
        // Initialize the TvLightSegments 🚀
        segments.setup(viewDisplay: self.containerViewDetails!)
        
        // Set the segments in TvLightSegments 🦑
        segments.set(segmentsItems: [ // text and image by http://pokemon.wikia.com/wiki
            Pokemon(
                name: "Pikachu",
                desc: "Pikachu are small, chubby, and incredibly cute mouse-like Pokémon. They are almost completely covered by yellow fur. They have long yellow ears that are tipped with black. A Pikachu's back has two brown stripes, and its large tail is notable for being shaped like a lightning bolt.",
                image: #imageLiteral(resourceName: "pikachu")
            ),
            Pokemon(
                name: "Charmander",
                desc: "Charmander is a small, bipedal, dinosaur-like Pokémon. Most of its body is colored orange, while its underbelly is a light-yellow color. Charmander, like its evolved forms, has a flame that constantly burns on the end of its tail.",
                image: #imageLiteral(resourceName: "charmander")
            ),
            Pokemon(
                name: "Bulbasaur",
                desc: "Bulbasaur resembles a small, squatting dinosaur that walks on four legs, but bears three claws on each of its feet and has no tail. It also has large, red eyes and very sharp teeth. Its skin is a light, turquoise color with dark, green spots.",
                image: #imageLiteral(resourceName: "bulbasaur")
            ),
            Pokemon(
                name: "Butterfree",
                desc: "Butterfree is an insect-like Pokémon appearing as a large butterfly. Butterfree has a large purple body with light blue limbs and a nose with very small fangs. Its eyes are quite large in proportion to its head and are a red color.",
                image: #imageLiteral(resourceName: "butterfree")
            )
        ])
        
        // Not much important 💬
        addGradientToBackground()
        
        // Please, see the ViewDetails.swift 😜
    }
    
    func addGradientToBackground() {
        self.view.backgroundColor = .white
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = #colorLiteral(red: 0.3294117647, green: 0.2117647059, blue: 0.3882352941, alpha: 1).cgColor
        let color2 = #colorLiteral(red: 0.2823529412, green: 0.1921568627, blue: 0.3490196078, alpha: 1).cgColor
        let color3 = #colorLiteral(red: 0.2705882353, green: 0.1921568627, blue: 0.3450980392, alpha: 1).cgColor
        let color4 = #colorLiteral(red: 0.1411764706, green: 0.1529411765, blue: 0.2549019608, alpha: 1).cgColor
        gradientLayer.colors = [color1, color2, color3, color4]
        
        gradientLayer.startPoint = CGPoint(x: 0.35, y: 0.25)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.6)
        gradientLayer.zPosition = -1
        
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueDetails" {
            self.containerViewDetails = (segue.destination as! ViewDetails)
            self.containerViewDetails!.view.alpha = 0
        }
    }
}
