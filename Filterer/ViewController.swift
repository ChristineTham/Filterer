//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var originalImage: UIImage?
    var filteredImage: UIImage?
    var currentFilter: ImageFilter? = nil

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet var overlayView: UIView!
 
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!

    @IBOutlet var filterSlider: UISlider!
    
    // let tapRec = UITapGestureRecognizer()
    
    func adjustFilterIcon(button: UIButton) {
        var rgbaImage = RGBAImage(image: button.currentImage!)
        
        predefinedFilters.applyFilterByName(&rgbaImage!, name: button.currentTitle!)
        button.setImage(rgbaImage!.toUIImage(), forState: .Normal)
    }

    // Disable the compare and edit button when a filter hasn’t been selected.
    // · If the user hasn’t selected a filter yet, then the image hasn’t changed, and the compare button isn’t useful. Disable the button when its function is not needed.
    func setImage(image: UIImage) {
        imageView.image = image
        originalImage = image
        compareButton.enabled = false
        compareButton.selected = false
        editButton.enabled = false
        editButton.selected = false
        currentFilter = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        overlayView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        overlayView.translatesAutoresizingMaskIntoConstraints = false

        filterSlider.translatesAutoresizingMaskIntoConstraints = false

        loadPredefinedFilters()
 
        // Use images instead of text for the filter buttons.
        // · Choose a small generic image that you can use as an icon for the filter buttons.
        // · For each filter button, replace the text with a filtered version of that icon so that the user can see what the effect looks like before they select it.
        // · You may not be able to fit as many filter buttons on the screen if you use images, that’s ok, just fit as many as you can.

        adjustFilterIcon(redButton)
        adjustFilterIcon(greenButton)
        adjustFilterIcon(blueButton)
        adjustFilterIcon(yellowButton)
        adjustFilterIcon(purpleButton)

        setImage(imageView.image!)
        
        // tapRec.addTarget(self, action: "onTap")
        // imageView.addGestureRecognizer(tapRec)
        imageView.userInteractionEnabled = true
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if editButton.selected {
            editButton.selected = false
            filterSlider.removeFromSuperview()
        }
        
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
        
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(50)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    
    // Cross-fade images when a user selects a new filter or uses the compare function.
    // · A smoother transition between images gives the app a more refined feel.
    // · During the cross-fade you will need to display two images at once. You’ll need to add a second UIImageView on top of the first one, and you can animate the alpha of the top view to show or hide the bottom view.
    // NOTE: I did not implement a second UIImageView but used the cross dissolve function alternative as discussed in Discussion Forum thread
    // https://www.coursera.org/learn/ios-app-development-basics/module/tqosy/discussions/UmU73pEtEeW70BJZtLVfGQ
    // The code to animate had two UIImageViews been used is commented out below

    func animateNewImage(image: UIImage) {
        /*
        transitionImage.image = image
        transitionImage.alpha = 0.0
        UIView.animateWithDuration(0.4, animations: {
            self.transitionImage.alpha = 1.0
            }) { completed in
                if completed == true {
                    self.transitionImage.alpha = 0.0
                }
        }
        imageView.image = image */
        UIView.transitionWithView(self.imageView,
            duration:0.4,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { self.imageView.image = image },
            completion: nil)
    }
    
    func applyFilterByName(filter: String) {
        var rgbaImage = RGBAImage(image: originalImage!)
        
        currentFilter = predefinedFilters.getFilterByName(filter)
        
        currentFilter!.filter(rgbaImage: &rgbaImage!, parameter: currentFilter!.parameter)
        filteredImage = rgbaImage!.toUIImage()
        animateNewImage(filteredImage!)

        compareButton.enabled = true
        compareButton.selected = false
        
        editButton.enabled = true
        editButton.selected = false
    }

    // When a user taps a filter button, the image view should update with the filtered image.
    // · Use the RGBAImage class from the course 1 project to get access to the pixels contained in a UIImage object.
    // · Employ your filter code from course 1 to filter the selected image.
    
    @IBAction func onRed(sender: UIButton) {
        applyFilterByName(sender.currentTitle!)
    }
    
    @IBAction func onGreen(sender: UIButton) {
        applyFilterByName(sender.currentTitle!)
    }
    
    @IBAction func onBlue(sender: UIButton) {
        applyFilterByName(sender.currentTitle!)
    }
    
    @IBAction func onYellow(sender: UIButton) {
        applyFilterByName(sender.currentTitle!)
    }
    
    @IBAction func onPurple(sender: UIButton) {
        applyFilterByName(sender.currentTitle!)
    }
    
    // Add an Edit button.
    // · Add an edit button next to the Filter button in the bottom toolbar. The function of this button is to allow the user to adjust the intensity of the currently applied filter (this button should be disabled until a filter has been selected.)
    // · When the user taps the edit button, hide the filter option list (if visible) and show a UISlider widget instead.
    
    @IBAction func onEdit(sender: UIButton) {
        if filterButton.selected {
            filterButton.selected = false
            secondaryMenu.removeFromSuperview()
        }
        
        if compareButton.selected {
            compareButton.selected = false
            imageView.image = filteredImage
            overlayView.removeFromSuperview()
        }
        
        if sender.selected {
            sender.selected = false
            
            UIView.animateWithDuration(0.4, animations: {
                self.filterSlider.alpha = 0
                }) { completed in
                    if completed == true {
                        self.filterSlider.removeFromSuperview()
                    }
            }
            
            // currentFilter!.parameter = 1.0
        } else {
            sender.selected = true
            
            filterSlider.value = currentFilter!.parameter
            
            view.addSubview(filterSlider)
            
            let bottomConstraint = filterSlider.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
            let leftConstraint = filterSlider.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
            let rightConstraint = filterSlider.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
            
            let heightConstraint = filterSlider.heightAnchor.constraintEqualToConstant(31)
            
            NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
            
            view.layoutIfNeeded()
            
            self.filterSlider.alpha = 0
            UIView.animateWithDuration(0.4) {
                self.filterSlider.alpha = 1.0
            }
        }
    }
    
    // · After the user adjusts the slider, the image should be updated with the new filter intensity.
    @IBAction func onFilterChange(sender: UISlider) {
        var rgbaImage = RGBAImage(image: originalImage!)
        
        if compareButton.selected {
            compareButton.selected = false
            imageView.image = filteredImage
            overlayView.removeFromSuperview()
        }
        
        currentFilter!.parameter = sender.value
        currentFilter!.filter(rgbaImage: &rgbaImage!, parameter: currentFilter!.parameter)
        imageView.image = rgbaImage!.toUIImage()
    }
    
    // When a user taps the compare button, the image view should show the original image. When they tap the button again, show the filtered image.
    @IBAction func onCompare(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            animateNewImage(filteredImage!)
            
            UIView.animateWithDuration(0.4, animations: {
                self.overlayView.alpha = 0
                }) { completed in
                    if completed == true {
                        self.overlayView.removeFromSuperview()
                    }
            }
       } else {
            sender.selected = true
            animateNewImage(originalImage!)

            // Make it more explicit that the user is looking at the original image.
            // · Add a small overlay view on top of the image view with the text “Original”. This should only be visible when the user is looking at the original image.

            view.addSubview(overlayView)
            
            let topConstraint = overlayView.topAnchor.constraintEqualToAnchor(imageView.topAnchor)
            let leftConstraint = overlayView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
            let rightConstraint = overlayView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
            
            let heightConstraint = overlayView.heightAnchor.constraintEqualToConstant(44)
            
            NSLayoutConstraint.activateConstraints([topConstraint, leftConstraint, rightConstraint, heightConstraint])
            
            view.layoutIfNeeded()
            
            self.overlayView.alpha = 0
            UIView.animateWithDuration(0.4) {
                self.overlayView.alpha = 1.0
            }
        }
    }
    
    // Make it easier to compare the original and filtered images.
    // · When the user touches the image, toggle between the filtered, and original images temporarily.
    // · When the user lifts their finger, toggle back.
    // func onTap(sender: UITapGestureRecognizer) {
    @IBAction func onImagePress(sender: UILongPressGestureRecognizer) {
        if currentFilter != nil {
            if sender.state == .Began {
                imageView.image = originalImage!
            }
            if sender.state == .Ended {
                imageView.image = filteredImage!
            }

        }
    }
}

