//
//  CTASelectorsViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTASelectorsViewControllerDataSource: class {
    func selectorsViewControllerContainer(_ viewcontroller: CTASelectorsViewController) -> ContainerVMProtocol?
    func selectorsViewControllerAnimation(_ ViewController: CTASelectorsViewController) -> CTAAnimationBinder?
    func selectorsViewController(_ viewController: CTASelectorsViewController, needChangedFromSelectorType type: CTAContainerFeatureType) -> CTAContainerFeatureType
    func selectorsViewControllerFilter(_ ViewController: CTASelectorsViewController) -> Int
}

protocol CTASelectorable: class {
    
}

protocol CTASelectorScaleable: CTASelectorable {
    func templateDidChanged(_ pageData: Data?, origin: Bool)
    func filterDidChanged(_ filterName: String)
    func scaleDidChanged(_ scale: CGFloat)
    func alphaDidChanged(_ alpha: CGFloat)
    func radianDidChanged(_ radian: CGFloat)
    func fontDidChanged(_ fontFamily: String, fontName: String)
    func alignmentDidChanged(_ alignment: NSTextAlignment)
    func shadowAndStrokeDidChanged(_ needShadow: Bool, needStroke: Bool)
    func spacingDidChanged(_ lineSpacing: CGFloat, textSpacing: CGFloat)
    func colorDidChanged(_ item: CTAColorItem)
    func animationDurationDidChanged(_ t: CGFloat)
    func animationDelayDidChanged(_ t: CGFloat)
    func animationWillBeDeleted(_ completedBlock:(() -> ())?)
    func animationWillBeInserted(_ a: CTAAnimationName, completedBlock:(() -> ())?)
    func animationWillChanged(_ a: CTAAnimationName)
    func animationWillPlay()
}

typealias CTASelectorViewControllerDelegate = CTASelectorScaleable

final class CTASelectorsViewController: UIViewController, UICollectionViewDataSource {
    
    var snapImage: UIImage?
    var preImage: UIImage?
    fileprivate var animation: Bool = false
    weak var filterManager: FilterManager?
    weak var dataSource: CTASelectorsViewControllerDataSource?
    weak var delegate: CTASelectorViewControllerDelegate?
    fileprivate(set) var currentType: CTAContainerFeatureType = .Templates
    fileprivate var container: ContainerVMProtocol? {
        return dataSource?.selectorsViewControllerContainer(self)
    }
    fileprivate var count: Int {
        return (container == nil) ? 0 : 1
    }
    fileprivate var action: String {
        switch currentType {
            
        case .Templates: return "templateDidChanged:"
        case .Filters: return "filterDidChanged:"
        case .Size: return "scaleChanged:"
        case .Rotator: return "radianChanged:"
        case .Fonts: return "indexPathOfFontsChanged:"
        case .Aligments: return "aligmentsChanged:"
        case .ShadowAndStroke: return "shadowAndStrokeChanged:"
        case .TextSpacing: return "textSpacingChanged:"
        case .Colors: return "colorChanged:"
        case .Animation: return "animationChanged:"
        case .Alpha: return "alphaChanged:"
        case .Empty: return ""
        }
    }

    @IBOutlet weak var collectionview: UICollectionView!
    
    deinit {
        debug_print("\(#file) deinit", context: deinitContext)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CTAStyleKit.commonBackgroundColor
        collectionview.layer.masksToBounds = false
    }
    
    func updateSnapshotImage(_ image: UIImage?) {
        snapImage = image
            DispatchQueue.main.async { [weak self, weak snapImage] in
                guard let sf = self else {return}
                let index = IndexPath(item: 0, section: 0)
                if let cell = sf.collectionview.cellForItem(at: index) as? CTASelectorTemplatesCell {
                    cell.templateList?.updateCurrentOriginImage(image)
                }
        }
    }
    
    func updatePreImage(_ image: UIImage?) {
        preImage = image
        DispatchQueue.main.async { [weak self, weak preImage] in
            guard let sf = self else {return}
            let index = IndexPath(item: 0, section: 0)
            if let cell = sf.collectionview.cellForItem(at: index) as? CTASelectorFiltersCell {
                cell.update(preImage)
            } else {
                sf.filterManager?.cleanImage()
            }
        }
    }
    
    func changeToSelector(_ type: CTAContainerFeatureType) {
        guard let collectionview = collectionview, container != nil else {
            return
        }
        
        if let cell = collectionview.cellForItem(at: IndexPath(item: 0, section: 0)) as? CTASelectorCell {
            cell.dataSource = nil
            cell.removeAllTarget()
        }
        
        currentType = type
        let acount = collectionview.numberOfItems(inSection: 0)
        
        animation = true
        
        collectionview.performBatchUpdates({ () -> Void in
            
            collectionview.insertItems(at: [IndexPath(item: 0, section: 0)])
            
            if acount > 0 {
                collectionview.deleteItems(at: [IndexPath(item: 0, section: 0)])
            }
            
            }, completion: {[weak self] finished in
                
//                dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
                
                    self?.animation = false
//                    })
        })
    }
    
    func updateSelector() {
        guard let collectionview = collectionview else {
            return
        }
        
        if let cell = collectionview.cellForItem(at: IndexPath(item: 0, section: 0)) as? CTASelectorCell {
            cell.dataSource = nil
            cell.removeAllTarget()
        }
        
        currentType = dataSource?.selectorsViewController(self, needChangedFromSelectorType: currentType) ?? currentType
        
        let currentCount = collectionview.numberOfItems(inSection: 0)
        let nextCount = count
        
        animation = true
        
        collectionview.performBatchUpdates({[weak collectionview] () -> Void in
            
            if nextCount > 0 {
                collectionview?.insertItems(at: [IndexPath(item: 0, section: 0)])
            }
            
            if currentCount > 0 {
                collectionview?.deleteItems(at: [IndexPath(item: 0, section: 0)])
            }
            }, completion: {[weak self] finished in
                
//                dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
                
                    self?.animation = false
//                })
        })
        
    }
    
    func updateIfNeed() {
        
        if let container = container {
            
            switch collectionview.cellForItem(at: IndexPath(item: 0, section: 0)) {
                
            case let cell as CTASelectorSizeCell:
                cell.value = container.scale
                
            case let cell as CTASelectorRotatorCell:
                cell.radian = container.radius
            default:
                ()
            }
        }
    }
}

// MARK: - UIColletionViewDataSource
extension CTASelectorsViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Selector\(currentType.rawValue)Cell", for: indexPath) as! CTASelectorCell
        
        cell.dataSource = self
        
        if let cell = cell as? CTASelectorAnimationCell {
            cell.delegate = self
        }
        
        if let cell = cell as? CTASelectorTemplatesCell {
            cell.templateList?.originImage = snapImage
        }
        
        if let cell = cell as? CTASelectorFiltersCell {
            cell.filterManager = filterManager
            cell.image = preImage
        }
//
        cell.beganLoad()
        if action.characters.count > 0 {
            cell.addTarget(self, action: Selector(action), forControlEvents: .valueChanged)
        }
        cell.retriveBeganValue()
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CTASelectorsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? CTASelectorCell {
            cell.willBeDisplayed()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? CTASelectorCell {
            cell.didEndDiplayed()
        }
    }
}

// MARK: - SelectorDataSource
extension CTASelectorsViewController: CTASelectorDataSource {
    
    func selectorBeganAlpha(_ cell: CTASelectorCell) -> CGFloat {
        return container?.alphaValue ?? 1.0
    }
    
    // TODO: Scale began value need fix -- EMIAOSTEIN; 2016-01-13-18:52
    func selectorBeganScale(_ cell: CTASelectorCell) -> CGFloat {
        return container?.scale ?? 1.0
    }
    
    func selectorBeganRadian(_ cell: CTASelectorCell) -> CGFloat {
        return container?.radius ?? 0.0
    }
    
    func selectorBeganAlignment(_ cell: CTASelectorCell) -> NSTextAlignment {
        guard
            let container = container as? TextContainerVMProtocol,
            let textElement = container.textElement else {
            return .left
        }
         return textElement.alignment
    }
    
    func selectorBeganNeedShadowAndStroke(_ cell: CTASelectorCell) -> (Bool, Bool) {
        
        guard
            let container = container as? TextContainerVMProtocol,
            let textElement = container.textElement else {
                return (false, false)
        }
        return (textElement.needShadow, textElement.needStroke)
    }
    
    func selectorBeganSpacing(_ cell: CTASelectorCell) -> (CGFloat, CGFloat) {
        guard
            let container = container as? TextContainerVMProtocol,
            let textElement = container.textElement else {
            return (0, 0)
        }
        return (textElement.lineSpacing, textElement.textSpacing)
    }
    
    // TODO: Font,Color need began value -- EMIAOSTEIN; 2016-01-13-18:51
    func selectorBeganFontIndexPath(_ cell: CTASelectorCell) -> IndexPath? {
        
        guard
            let container = container as? TextContainerVMProtocol,
            let textElement = container.textElement else {
                return nil
        }
        
        let family = textElement.fontFamily
        let name = textElement.fontName
        let indexPath = CTAFontsManager.indexPathForFamily(family, fontName: name)
        return indexPath
    }
    
    func selectorBeganColor(_ cell: CTASelectorCell) -> UIColor? {
        
        guard
            let container = container as? TextContainerVMProtocol,
            let textElement = container.textElement else {
                return nil
        }
        
        guard let color = SWColor(hexString: textElement.colorHex) else {
            return nil
        }
        
        return color
    }
    
    func selectorBeganAnimation(_ cell: CTASelectorCell) -> CTAAnimationBinder? {
        
        return dataSource?.selectorsViewControllerAnimation(self)
    }
    
    func selectorBeganFilter(_ cell: CTASelectorCell) -> Int {
        return dataSource?.selectorsViewControllerFilter(self) ?? 0
    }
}

// MARK: - Actions
extension CTASelectorsViewController {
    
    func alphaChanged(_ sender: CTASliderView) {
        let v = CGFloat(Int(sender.value * 100.0)) / 100.0
        delegate?.alphaDidChanged(v)
    }
    
    func templateDidChanged(_ info: [String: AnyObject]) {
        if let origin = info["origin"] as? Bool {
            if let data = info["data"] as? Data {
                delegate?.templateDidChanged(data, origin: origin)
            } else {
                delegate?.templateDidChanged(nil, origin: origin)
            }
        }
        
//        if let data = data, let apage = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? CTAPage {
//            apage.removeLastImageContainer()
//            
//        }
        
    }
    
    func filterDidChanged(_ name: String) {
        delegate?.filterDidChanged(name)
    }
    
    func scaleChanged(_ sender: CTASliderView) {
        let v = CGFloat(Int(sender.value * 100.0)) / 100.0
        delegate?.scaleDidChanged(v)
    }
    
    func radianChanged(_ sender: CTARotatorView) {
        let v = CGFloat(Int(sender.radian * 100.0)) / 100.0
        delegate?.radianDidChanged(v)
    }
    
    func indexPathOfFontsChanged(_ sender: CTAPickerView) {
        guard let indexPath = sender.selectedIndexPath, animation == false else {
            return
        }
        
        let r = CTAFontsManager.familyAndFontNameWith(indexPath)
        
        guard let family = r.0, let font = r.1 else {
            return
        }
        
        delegate?.fontDidChanged(family, fontName: font)
    }
    
    func aligmentsChanged(_ sender: CTASegmentControl) {
        delegate?.alignmentDidChanged(NSTextAlignment(rawValue: sender.selectedIndex)!)
    }
    
    func shadowAndStrokeChanged(_ result: [Bool]) { // needShadow, needStroke
        delegate?.shadowAndStrokeDidChanged(result[0] ?? false, needStroke: result[1] ?? false)
    }
    
    func textSpacingChanged(_ sender: CTATextSpacingView) {
        delegate?.spacingDidChanged(sender.spacing.0, textSpacing: sender.spacing.1)
    }
    
    func colorChanged(_ sender: CTAColorPickerNodeCollectionView) {
        
        guard let selectedColor = sender.selectedColor, animation == false else { return }
        let colorItem = CTAColorItem(color: selectedColor)
        delegate?.colorDidChanged(colorItem)
    }
    
    func animationChanged(_ sender: AnyObject) {
        
    }
}

extension CTASelectorsViewController: CTASelectorAnimationCellDelegate {
    
    func animationCellAnimationPlayWillBegan(_ cell: CTASelectorAnimationCell) {
        delegate?.animationWillPlay()
    }
    
    func animationCellWillDeleteAnimation(_ cell: CTASelectorAnimationCell, completedBlock:(() -> ())?) {
        delegate?.animationWillBeDeleted({ 
            completedBlock?()
        })
        
    }
    func animationCell(_ cell: CTASelectorAnimationCell, WillAppendAnimation ani: CTAAnimationName, completedBlock:(() -> ())?) {
        delegate?.animationWillBeInserted(ani, completedBlock: { 
            completedBlock?()
        })
        
    }
    func animationCell(_ cell: CTASelectorAnimationCell, didChangedToAniamtion ani: CTAAnimationName) {
        delegate?.animationWillChanged(ani)
    }
    
    func animationCell(_ cell: CTASelectorAnimationCell, durationDidChanged duration: CGFloat) {
        delegate?.animationDurationDidChanged(duration)
    }
    func animationCell(_ cell: CTASelectorAnimationCell, delayDidChanged delay: CGFloat) {
        delegate?.animationDelayDidChanged(delay)
    }
}
