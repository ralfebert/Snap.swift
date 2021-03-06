import UIKit
import SpriteKit
import SceneKit

/**
 Adds a static image view on top of all SCNViews, GLKViews and SKViews for the given view hierarchy so these can be captured. Returns the created views.
 */
func addImagesForRenderedViews(_ view: UIView) -> [UIView] {

  func add(_ image: UIImage) -> [UIView] {
    let imageView = UIImageView(image: image)
    imageView.frame = view.bounds
    view.insertSubview(imageView, at: 0)
    return [imageView]
  }
  
  if let scnview = view as? SCNView {
    return add(scnview.snapshot())
  } else if let glview = view as? GLKView {
    return add(glview.snapshot)
  } else if let skview = view as? SKView {
    return add(UIImage(cgImage: skview.texture(from: skview.scene!)!.cgImage()))
  } else {
    return view.subviews.flatMap(addImagesForRenderedViews)
  }
}

extension UIView {
  /// Extract image data with the whole hierarchy from `UIView`
  func render() -> UIImage? {

    self.layoutIfNeeded()
    
    // SpriteKit refuses to draw its hierarchy: render an image of the spritekit view and add it to the view to be able to capture it
    let addedViews = addImagesForRenderedViews(self)
    defer { addedViews.forEach { $0.removeFromSuperview() } }
 
    defer {
      UIGraphicsEndImageContext()
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)

    guard let context = UIGraphicsGetCurrentContext() else {
        return nil
    }
    layer.render(in: context)
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}
