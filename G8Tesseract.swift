//
//  G8Tesseract.swift
//  InSight
//
//  
//


/*

To use this module you'll need to complete the following:
 
1. Install the TesseractOCRiOS framework in your project. You can do this using CocoaPods by adding `pod 'TesseractOCRiOS'` to your Podfile and running `pod install`.

2. Download the appropriate language data files from the Tesseract GitHub page and add them to your project. For English, you would download the `eng.traineddata` file.

3. Use the `G8Tesseract` class to perform OCR on your image.
*/



/*
import Foundation
import TesseractOCR

func recognizeText(in image: UIImage) {
    let tesseract = G8Tesseract(language: "eng")
    tesseract?.image = image
    tesseract?.recognize()

    let recognizedText = tesseract?.recognizedText
    print(recognizedText ?? "")
}


let image = // Your map image
recognizeText(in: image)
let roomNumbers = extractRoomNumbers(from: recognizedText)
print(roomNumbers)
*/
