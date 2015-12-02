// Coursera: Introduction To Swift Programming
// Assignment: InstaFilter Processor
// Student: Christine Tham

import UIKit

// Create the image processor
// Encapsulate your chosen Filter parameters and/or formulas in a struct/class definition.
// Create and test an ImageProcessor class/struct to manage an arbitrary number Filter instances to apply to an image. It should allow you to specify the order of application for the Filters.

class ImageFilter {
    let name: String
    var parameter: Float
    var filter: (inout rgbaImage: RGBAImage, parameter: Float) -> Bool
    
    init(name: String, parameter: Float, filter: (inout rgbaImage: RGBAImage, parameter: Float) -> Bool) {
        self.name = name
        self.parameter = parameter
        self.filter = filter
    }
}

class ImageProcessor {
    var filterArray: [ImageFilter] = []
    var nfilters = 0
    
    // add a filter instance to end of sequence
    func addFilter(filter: ImageFilter) {
        filterArray.append(filter)
        nfilters++
    }
    
    // change sequence of filters to apply - takes an index of sequence numbers starting with 0
    // note can also be used to delete filter from sequence by omitting the index of item(s) to be deleted
    func sortFilters(index: [Int]) {
        var newArray: [ImageFilter] = []
        
        nfilters = 0
        for i in index {
            if i < filterArray.count {
                newArray.append(filterArray[i])
                nfilters++
            }
        }
        filterArray = newArray
    }
    
    // returns a filter instance given name
    func getFilterByName(name: String) -> ImageFilter? {
        for f in filterArray {
            if f.name == name {
                return f
            }
        }
        return nil
    }
    
    // apply a specific filter in class by searching for name
    func applyFilterByName(inout rgbaImage: RGBAImage, name: String) {
        let f = getFilterByName(name)!
        
        f.filter(rgbaImage: &rgbaImage, parameter: f.parameter)
    }
    
    // apply all filters in sequence
    func applyAllFilters(inout rgbaImage: RGBAImage) {
        for f in filterArray {
            f.filter(rgbaImage: &rgbaImage, parameter: f.parameter)
        }
    }
}

// STEP 4: Create predefined filters
// Create five reasonable default Filter configurations (e.g. "50% Brightness”, “2x Contrast”), and provide an interface to access instances of such defaults by name. (e.g. could be custom subclasses of a Filter class, or static instances of Filter available in your ImageProcessor interface, or a Dictionary of Filter instances). There is no requirement to do this in a specific manner, but it’s good to think about the different ways you could go about it.

// Change brightness (parameter between -1.0 and 1.0)
func brightnessFilter(inout rgbaImage: RGBAImage, parameter: Float) -> Bool {
    for y in 0 ..< rgbaImage.height {
        for x in 0 ..< rgbaImage.width {
            let index = y * rgbaImage.width + x
            
            var pixel = rgbaImage.pixels[index]
            
            pixel.red = UInt8(max(0, min(255, Float(pixel.red) + parameter * 256)))
            pixel.green = UInt8(max(0, min(255, Float(pixel.green) + parameter * 256)))
            pixel.blue = UInt8(max(0, min(255, Float(pixel.blue) + parameter * 256)))
            
            rgbaImage.pixels[index] = pixel
        }
    }
    return true
}

// Change contraast (parameter a percentage ie. 25% is 0.25)
func contrastFilter(inout rgbaImage: RGBAImage, parameter: Float) -> Bool {
    for y in 0 ..< rgbaImage.height {
        for x in 0 ..< rgbaImage.width {
            let index = y * rgbaImage.width + x
            
            var pixel = rgbaImage.pixels[index]
            
            pixel.red = UInt8(max(0, min(255, (Float(pixel.red) - 128) * (1 + parameter) + 128)))
            pixel.green = UInt8(max(0, min(255, (Float(pixel.green) - 128) * (1 + parameter) + 128)))
            pixel.blue = UInt8(max(0, min(255, (Float(pixel.blue) - 128) * (1 + parameter) + 128)))
            
            rgbaImage.pixels[index] = pixel
        }
    }
    return true
}

// Retain only red values (parameter is ignored)
func redFilter(inout rgbaImage: RGBAImage, parameter: Float) -> Bool {
    for y in 0 ..< rgbaImage.height {
        for x in 0 ..< rgbaImage.width {
            let index = y * rgbaImage.width + x
            
            var pixel = rgbaImage.pixels[index]
            
            pixel.green = 0
            pixel.blue = 0
            rgbaImage.pixels[index] = pixel
        }
    }
    return true
}

// Retain only green values (parameter is ignored)
func greenFilter(inout rgbaImage: RGBAImage, parameter: Float) -> Bool {
    for y in 0 ..< rgbaImage.height {
        for x in 0 ..< rgbaImage.width {
            let index = y * rgbaImage.width + x
            
            var pixel = rgbaImage.pixels[index]
            
            pixel.red = 0
            pixel.blue = 0
            rgbaImage.pixels[index] = pixel
        }
    }
    return true
}

// Retain only blue values (parameter is ignored)
func blueFilter(inout rgbaImage: RGBAImage, parameter: Float) -> Bool {
    for y in 0 ..< rgbaImage.height {
        for x in 0 ..< rgbaImage.width {
            let index = y * rgbaImage.width + x
            
            var pixel = rgbaImage.pixels[index]
            
            pixel.red = 0
            pixel.green = 0
            rgbaImage.pixels[index] = pixel
        }
    }
    return true
}

// Retain only yellow values (parameter is ignored)
func yellowFilter(inout rgbaImage: RGBAImage, parameter: Float) -> Bool {
    for y in 0 ..< rgbaImage.height {
        for x in 0 ..< rgbaImage.width {
            let index = y * rgbaImage.width + x
            
            var pixel = rgbaImage.pixels[index]
            
            pixel.red = min(pixel.red, pixel.green)
            pixel.green = pixel.red
            pixel.blue = 0
            rgbaImage.pixels[index] = pixel
        }
    }
    return true
}

// Retain only purple values (parameter is ignored)
func purpleFilter(inout rgbaImage: RGBAImage, parameter: Float) -> Bool {
    for y in 0 ..< rgbaImage.height {
        for x in 0 ..< rgbaImage.width {
            let index = y * rgbaImage.width + x
            
            var pixel = rgbaImage.pixels[index]
            
            pixel.red = min(pixel.red, pixel.blue)
            pixel.blue = pixel.red
            pixel.green = 0
            rgbaImage.pixels[index] = pixel
        }
    }
    return true
}


var predefinedFilters = ImageProcessor()

func loadPredefinedFilters() {
    // add predefined Brightness filter instances
    predefinedFilters.addFilter(ImageFilter(name: "Brightness 10%", parameter: Float(0.10), filter: brightnessFilter))
    predefinedFilters.addFilter(ImageFilter(name: "Brightness 25%", parameter: Float(0.25), filter: brightnessFilter))
    predefinedFilters.addFilter(ImageFilter(name: "Brightness 50%", parameter: Float(0.50), filter: brightnessFilter))
    predefinedFilters.addFilter(ImageFilter(name: "Brightness -10%", parameter: Float(-0.10), filter: brightnessFilter))
    predefinedFilters.addFilter(ImageFilter(name: "Brightness -25%", parameter: Float(-0.25), filter: brightnessFilter))
    predefinedFilters.addFilter(ImageFilter(name: "Brightness -50%", parameter: Float(-0.50), filter: brightnessFilter))
    
    // add predefined Contrast filter instances
    predefinedFilters.addFilter(ImageFilter(name: "Contrast 10%", parameter: Float(0.10), filter: contrastFilter))
    predefinedFilters.addFilter(ImageFilter(name: "Contrast 25%", parameter: Float(0.25), filter: contrastFilter))
    predefinedFilters.addFilter(ImageFilter(name: "Contrast 50%", parameter: Float(0.50), filter: contrastFilter))
    predefinedFilters.addFilter(ImageFilter(name: "Contrast -10%", parameter: Float(-0.10), filter: contrastFilter))
    predefinedFilters.addFilter(ImageFilter(name: "Contrast -25%", parameter: Float(-0.25), filter: contrastFilter))
    predefinedFilters.addFilter(ImageFilter(name: "Contrast -50%", parameter: Float(-0.50), filter: contrastFilter))
    
    // add colour filter instances
    predefinedFilters.addFilter(ImageFilter(name: "red", parameter: 0.0, filter: redFilter))
    predefinedFilters.addFilter(ImageFilter(name: "green", parameter: 0.0, filter: greenFilter))
    predefinedFilters.addFilter(ImageFilter(name: "blue", parameter: 0.0, filter: blueFilter))
    predefinedFilters.addFilter(ImageFilter(name: "yellow", parameter: 0.0, filter: yellowFilter))
    predefinedFilters.addFilter(ImageFilter(name: "purple", parameter: 0.0, filter: purpleFilter))

}
