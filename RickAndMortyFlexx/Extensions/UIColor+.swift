//
//  UIColor+.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 08.04.2021.
//

import UIKit

extension UIColor {
	
	convenience init?(hex: String) {
		let r, g, b, a: CGFloat
		if hex.hasPrefix("#") {
			let start = hex.index(hex.startIndex, offsetBy: 1)
			let hexColor = String(hex[start...])
			
			if hexColor.count == 8 {
				let scanner = Scanner(string: hexColor)
				var hexNumber: UInt64 = 0
				if scanner.scanHexInt64(&hexNumber) {
					r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
					g = CGFloat((hexNumber &  0x00ff0000) >> 16) / 255
					b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
					a = CGFloat((hexNumber & 0x000000ff)) / 255
					self.init(red: r, green: g, blue: b, alpha: a)
					return
				}
			}
		}
		return nil
	}
	
	static var rmRandomColors: [UIColor] {
		[.rmBrown, .rmLightYellow, .rmLeafGrean]
	}
	static let rmPurple = UIColor(hex: "#36003aFF")!
	static let rmGreen = UIColor(hex: "#8BCF21FF")!
	static let rmDarkGreen = UIColor(hex: "#2F9331FF")!
	static let rmCyan = UIColor(hex: "#A6EEE6FF")!
	static let rmYellow = UIColor(hex: "#82491EFF")!
	static let rmBrown = UIColor(hex: "#82491EFF")!
	static let rmLightYellow = UIColor(hex: "#E5D29FFF")!
	static let rmDarkBlue = UIColor(hex: "#24325FFF")!
	static let rmBlue = UIColor(hex: "#69C8ECFF")!
	static let rmOrange = UIColor(hex: "#E89242FF")!
	static let rmLightPurple = UIColor(hex: "#C5A1FFFF")!
	static let rmLightRed = UIColor(hex: "#FF7373FF")!
	static let rmLeafGrean = UIColor(hex: "#177972FF")!
	static let rmPaleGreen = UIColor(hex: "#EFF1E4FF")!
}


extension UIImage {
	var averageColor: UIColor? {
		guard let inputImage = CIImage(image: self) else { return nil }
		let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
		
		guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
		guard let outputImage = filter.outputImage else { return nil }
		
		var bitmap = [UInt8](repeating: 0, count: 4)
		let context = CIContext(options: [.workingColorSpace: kCFNull!])
		context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
		
		return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
	}
}


extension UIColor {
	
	// Check if the color is light or dark, as defined by the injected lightness threshold.
	// Some people report that 0.7 is best. I suggest to find out for yourself.
	// A nil value is returned if the lightness couldn't be determined.
	func isLight(threshold: Float = 0.5) -> Bool? {
		let originalCGColor = self.cgColor
		
		// Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
		// If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
		let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
		guard let components = RGBCGColor?.components else {
			return nil
		}
		guard components.count >= 3 else {
			return nil
		}
		
		let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
		return (brightness > threshold)
	}
}
