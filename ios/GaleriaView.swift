import UIKit
import ExpoModulesCore
import ImageViewer_swift
import SDWebImage

class GaleriaView: ExpoView {
    func getChildImageView() -> UIImageView? {
        guard let reactSubviews = self.reactSubviews() else { return nil }

        for reactSubview in reactSubviews {
            for subview in reactSubview.subviews {
                if let imageView = subview as? UIImageView {
                    return imageView
                }
            }
        }
        
        return nil
    }

    override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
        super.insertReactSubview(subview, at: atIndex)
        setupImageView()
    }
    
    var theme: String? { didSet { setupImageView() } }

    var urls: [String]? { didSet { setupImageView() } }

    var initialIndex: Int? { didSet { setupImageView() } }

    func setupImageView() {
        var viewerTheme: ImageViewerTheme = .dark
        if let theme = self.theme {
            viewerTheme = Theme(rawValue: theme)?.toImageViewerTheme() ?? .dark
        }
        
        guard let childImage = getChildImageView() else {
            return
        }
        
        if let urls = self.urls, let initialIndex = self.initialIndex {
            let urlObjects = urls.compactMap { URL(string: $0) }
            childImage.setupImageViewer(urls: urlObjects, initialIndex: initialIndex, options: [.theme(viewerTheme)])
        } else {
            if let img = childImage.image {
                print("child image from expo! \(img)")
                childImage.setupImageViewer(images: [img], options: [.theme(viewerTheme)])
            } else {
                print("missing image from expo...\(childImage)")
            }
        }
        
    }

    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
    }
}


enum Theme: String, Enumerable {
  case dark
  case light
  
  func toImageViewerTheme() -> ImageViewerTheme {
    switch self {
        case .dark:
            return .dark
        case .light:
            return .light
    }
  }
}
