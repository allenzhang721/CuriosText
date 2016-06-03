//
//  CTAPhotoPreviewView.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/29/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

class CTAPhotoPreviewView: UIView {
    
    var didChangedHandler: ((Bool) -> ())?
    
    var templateImage: UIImage?
    
    private var scaleMax: Bool = true
    
    var image: UIImage? {
        get { return imageView.image }
        set { loadImage(newValue) }
    }
    
    var imgDisplayRect: CGRect {
        return imageDisplayRect()
    }
    
    var ignoreRect: CGRect {
        return CGRect(x: 0, y: bounds.maxY - 44.0, width: bounds.width, height: 44.0)
    }
    let templateImageView = UIImageView()
    private let imageView = UIImageView()
    private let scrollView = UIScrollView()
    private var tap: UITapGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

// MARK: - Styles
extension CTAPhotoPreviewView {
    private func setup() {
        setupViews()
        setupStyle()
        setupGesture()
    }
    
    func setupViews() {
        addSubview(scrollView)
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 0).active = true
        scrollView.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: 0).active = true
        scrollView.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: 0).active = true
        scrollView.topAnchor.constraintEqualToAnchor(topAnchor, constant: 0).active = true
        scrollView.delegate = self
        
        scrollView.addSubview(imageView)
        
        addSubview(templateImageView)
        templateImageView.translatesAutoresizingMaskIntoConstraints = false
        templateImageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 0).active = true
        templateImageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: 0).active = true
        templateImageView.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: 0).active = true
        templateImageView.topAnchor.constraintEqualToAnchor(topAnchor, constant: 0).active = true
        templateImageView.image = templateImage
    }
    
    func setupStyle() {
        backgroundColor = UIColor.whiteColor()
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func setupGesture() {
        tap = UITapGestureRecognizer(target: self, action: #selector(CTAPhotoPreviewView.tap(_:)))
        tap.delegate = self
        tap.numberOfTapsRequired = 2
        addGestureRecognizer(tap)
    }
    
    func status1Style() {
        
    }
}

// MARK: - Actions
extension CTAPhotoPreviewView {
    
    func tap(sender: UITapGestureRecognizer) {
        changeScale()
    }
}


// MARK: - Logics
extension CTAPhotoPreviewView {
    
    private func loadImage(image: UIImage?) {
        if let image = image {loadRealImage(image)} else {loadEmptyImage()}
        
//        updateImgViewPosition()
    }
    
    private func loadRealImage(image: UIImage) {
        let imgSize = image.size
        let size = scrollView.bounds.size
        let minScale = min(size.width / imgSize.width, size.height / imgSize.height)
        let maxScale = max(size.width / imgSize.width, size.height / imgSize.height)
        
        imageView.image = image
        imageView.bounds.size = imgSize
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = maxScale
        
        scrollView.setZoomScale(scaleMax ? maxScale : minScale, animated: false)
    }
    
    private func loadEmptyImage() {
        imageView.image = nil
        imageView.bounds.size = CGSize.zero
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
    }
    
    private func updateImgViewPosition() {
        let contentSize = scrollView.contentSize
        let boundSize = scrollView.bounds.size
        let centerX = (contentSize.width - boundSize.width) / 2.0
        let centerY = (contentSize.height - boundSize.height) / 2.0
        imageView.frame.origin = CGPoint.zero
        scrollView.contentOffset = CGPoint(x: centerX, y: centerY)
//        imageView.center = CGPoint(x: centerX, y: centerY)
    }
    
    private func imageDisplayRect() -> CGRect {
        if imageView.image == nil {
            return CGRect.zero
        }
        
        let offset = scrollView.contentOffset
        let scaledSize = scrollView.contentSize
        let boundsSize = scrollView.bounds.size
        let scale = scrollView.zoomScale
        
        let scaledX = offset.x
        let scaledY = offset.y
        let scaledW = min(scaledSize.width, boundsSize.width)
        let scaledH = min(scaledSize.height, boundsSize.height)
        
        let x = scaledX / scale
        let y = scaledY / scale
        let w = scaledW / scale
        let h = scaledH / scale
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    func changeScale() {
        let minScale = scrollView.minimumZoomScale
        let maxScale = scrollView.maximumZoomScale
        let curScale = scrollView.zoomScale
        
        let nextScale = curScale > minScale ? minScale : maxScale
        scaleMax = nextScale == maxScale ? true : false
        
        scrollView.setZoomScale(nextScale, animated: true)
        
        didChangedHandler?(nextScale == maxScale)
    }
    
//    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
//        let aignoreRect = ignoreRect
//        if CGRectContainsPoint(aignoreRect, point) {
//            return false
//        } else {
//            return true
//        }
//    }
}

// MARK: - Delegate 
extension CTAPhotoPreviewView: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateImgViewPosition()
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
    }
}

extension CTAPhotoPreviewView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == tap {
            let location = gestureRecognizer.locationInView(self)
            if CGRectContainsPoint(ignoreRect, location) {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
        
    }
}
