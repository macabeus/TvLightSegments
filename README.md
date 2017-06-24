[![Version](https://img.shields.io/cocoapods/v/TvLightSegments.svg?style=flat)](http://cocoapods.org/pods/TvLightSegments)
[![License](https://img.shields.io/cocoapods/l/TvLightSegments.svg?style=flat)](http://cocoapods.org/pods/TvLightSegments)
[![Platform](https://img.shields.io/cocoapods/p/TvLightSegments.svg?style=flat)](http://cocoapods.org/pods/TvLightSegments)

# TvLightSegments
💜  Clean, simple and beautiful segment bar for your AppleTv app

![](http://i.imgur.com/DxUjToP.png)

You can download this repository and see this example app.

# How to use

## Install
In `Podfile` add
```
pod 'TvLightSegments'
```

and use `pod install`.

## Setup

Create a new CollectionView and set `TvLightSegments` as a custom class
![](http://i.imgur.com/98hwCVl.png)

You need create create a class that subscriber `TvLightSegmentsDisplay`. When a segment's focus change, this class notified.
```swift
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

```

Also, you need create a class that subscriber `TvLightSegmentsItem`. The objects of this class will be the segments.

```swift
class Pokemon: TvLightSegmentsItem {
    
    let name: String
    let desc: String
    
    init(name: String, desc: String) {
        self.name = name
        self.desc = desc
    }
    
    // Text that will show in segment
    func tvLightSegmentsName() -> String {
        return name
    }
}
```

Now, in `ViewController`, we need setup the TvLightSegments, with the `setup(viewDisplay:)`:

```swift
class ViewMain: UIViewController {
    @IBOutlet weak var segments: TvLightSegments!
    ...
    
    override func viewDidLoad() {
        // The parameter need be a TvLightSegmentsDisplay
        segments.setup(viewDisplay: self.containerViewDetails!)
```

Then, set the segments, with the `set(segmentsItems:)`:

```swift
class ViewMain: UIViewController {
    ...
    
    override func viewDidLoad() {
        ...
        
        // The parameter need be a [TvLightSegmentsItem]
        segments.set(segmentsItems: [
            Pokemon(
                name: "Pikachu",
                desc: "Pikachu are small, chubby..."
            ),
            Pokemon(
                name: "Charmander",
                desc: "Charmander is a small, bipedal..."
            ),
            Pokemon(
                name: "Bulbasaur",
                desc: "Bulbasaur resembles a small..."
            )
        ])
```

Awesome! Now, our TvLightSegments work! 😆

## Optional configs

### Colors
You can change the colors.

Hey! Change the colors **before** the `setup(viewDisplay:)` method!!

```swift
segments.labelColorSelected = UIColor.red
segments.labelColorNotSelected = UIColor.blue
segments.viewFooterColorSelected = UIColor.green
segments.viewFooterColorNotSelected = UIColor.black
```

### Transition
Set a transition animation when a segment's focus is changes.

Hey! Set the transitions **before** the `set(segmentsItems:)` method!!

```swift
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
```

# TODO
- [ ] Infinite list, with scroll bar

**Maintainer**:

> [macabeus](http://macalogs.com.br/) &nbsp;&middot;&nbsp;
> GitHub [@macabeus](https://github.com/macabeus)
