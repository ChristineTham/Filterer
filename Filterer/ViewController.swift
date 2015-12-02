//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var filteredImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    var originalImage: UIImage?
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var filterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        originalImage = imageView.image!
        filteredImage = imageView.image!
        loadPredefinedFilters()
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
        originalImage = imageView.image!
        filteredImage = imageView.image!
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
            imageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
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
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
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

    // 1. When a user taps a filter button, the image view should update with the filtered image.
    
    // · Use the RGBAImage class from the course 1 project to get access to the pixels contained in a UIImage object.
    
    // · Employ your filter code from course 1 to filter the selected image.
    
    @IBAction func onRed(sender: UIButton) {
        var rgbaImage = RGBAImage(image: imageView.image!)
        
        predefinedFilters.applyFilterByName(&rgbaImage!, name: "red")
        filteredImage = rgbaImage!.toUIImage()
        imageView.image = filteredImage
    }
    
    @IBAction func onGreen(sender: UIButton) {
        var rgbaImage = RGBAImage(image: imageView.image!)
        
        predefinedFilters.applyFilterByName(&rgbaImage!, name: "green")
        filteredImage = rgbaImage!.toUIImage()
        imageView.image = filteredImage
    }
    
    @IBAction func onBlue(sender: UIButton) {
        var rgbaImage = RGBAImage(image: imageView.image!)
        
        predefinedFilters.applyFilterByName(&rgbaImage!, name: "blue")
        filteredImage = rgbaImage!.toUIImage()
        imageView.image = filteredImage
    }
    
    @IBAction func onYellow(sender: UIButton) {
        var rgbaImage = RGBAImage(image: imageView.image!)
        
        predefinedFilters.applyFilterByName(&rgbaImage!, name: "yellow")
        filteredImage = rgbaImage!.toUIImage()
        imageView.image = filteredImage
    }
    
    @IBAction func onPurple(sender: UIButton) {
        var rgbaImage = RGBAImage(image: imageView.image!)
        
        predefinedFilters.applyFilterByName(&rgbaImage!, name: "purple")
        filteredImage = rgbaImage!.toUIImage()
        imageView.image = filteredImage
    }
    
    // 2. When a user taps the compare button, the image view should show the original image. When they tap the button again, show the filtered image.
    @IBAction func onCompare(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            imageView.image = filteredImage!
        } else {
            sender.selected = true
            imageView.image = originalImage
        }
    }
}

