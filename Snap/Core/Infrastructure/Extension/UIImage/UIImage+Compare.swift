import UIKit
import CoreGraphics

enum CompareError: Error {
  case invalidReferenceImage
  case invalidImageSize
  case notEqualSize(referenceSize: CGSize, comparedSize: CGSize)
  case notEquals
  case notEqualMetadata
}

extension UIImage {
  /// Compare two images using different approaches (size, metadata, bytes)
  /// - Warning: This methods throws **CompareError**
  func compare(with image: UIImage) throws {
    guard let cgImage = cgImage else { throw CompareError.invalidReferenceImage }
    let referenceImageSize = CGSize(width: cgImage.width, height: cgImage.height)
    let imageSize = CGSize(width: image.cgImage!.width, height: image.cgImage!.height)
    
    let imagesAreTheSameSize = referenceImageSize == imageSize
    guard imagesAreTheSameSize else {
      throw CompareError.notEqualSize(referenceSize: size, comparedSize: image.size)
    }

    let imagesHaveZeroSize = (size != .zero) && (image.size != .zero)
    guard imagesHaveZeroSize else {
      throw CompareError.invalidImageSize
    }
  
    guard let referenceImageContext = context(for: self),
      let imageContext = context(for: image) else {
      fatalError("👾 Cannot create image context")
    }
 
    referenceImageContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: Int(referenceImageSize.width), height: Int(referenceImageContext.height)))
    imageContext.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: Int(imageSize.width), height: Int(imageSize.height)))
    
    try compareMetadata(from: referenceImageContext, matches: imageContext)

    let minBytesPerRow = min(cgImage.bytesPerRow, image.cgImage!.bytesPerRow)
    let referenceImageSizeBytes = Int(referenceImageSize.height) * minBytesPerRow

    var differentPixels = 0
    var differenceSum = 0

    // workaround: compare with tolerance
    let referenceData = referenceImageContext.data!
    let imageData = imageContext.data!
    for byteOffset in 0..<referenceImageSizeBytes {
        let referenceBytes = referenceData.load(fromByteOffset: byteOffset, as: UInt8.self)
        let imageBytes = imageData.load(fromByteOffset: byteOffset, as: UInt8.self)
        if referenceBytes != imageBytes {
            let diff = abs(Int(referenceBytes) - Int(imageBytes))
            if diff > 3 {
                differentPixels += 1
                differenceSum += diff
            }
        }
    }

    if differentPixels > 15 {
        throw CompareError.notEquals
    }


    // TODO: image normalization removed: let imagesAreEqual = normalizedImage! == image.normalizedImage! && equals == 0
  }
  
  private func compareMetadata(from context1: CGContext, matches context2: CGContext) throws {
    let haveEqualWidth = (context1.width == context2.width)
    let haveEqualHeight = (context1.height == context2.height)
    let haveEqualBitsPerComponent = (context1.bitsPerComponent == context2.bitsPerComponent)
    let haveEqualBytesPerRow = (context1.bytesPerRow == context2.bytesPerRow)
    let haveEqualColorSpace = (context1.colorSpace == context2.colorSpace)
    let imagesHaveEqualMetadata = haveEqualWidth && haveEqualHeight &&
      haveEqualBitsPerComponent && haveEqualBytesPerRow && haveEqualColorSpace
    
    guard imagesHaveEqualMetadata else {
      throw CompareError.notEqualMetadata
    }
  }
}
