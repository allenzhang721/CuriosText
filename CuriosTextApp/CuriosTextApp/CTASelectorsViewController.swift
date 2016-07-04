//
//  CTASelectorsViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTASelectorsViewControllerDataSource: class {
    func selectorsViewControllerContainer(viewcontroller: CTASelectorsViewController) -> ContainerVMProtocol?
    func selectorsViewControllerAnimation(ViewController: CTASelectorsViewController) -> CTAAnimationBinder?
    func selectorsViewController(viewController: CTASelectorsViewController, needChangedFromSelectorType type: CTAContainerFeatureType) -> CTAContainerFeatureType
}

protocol CTASelectorable: class {
    
}

protocol CTASelectorScaleable: CTASelectorable {
    func templateDidChanged(pageData: NSData?, origin: Bool)
    func filterDidChanged(filterName: String)
    func scaleDidChanged(scale: CGFloat)
    func radianDidChanged(radian: CGFloat)
    func fontDidChanged(fontFamily: String, fontName: String)
    func alignmentDidChanged(alignment: NSTextAlignment)
    func spacingDidChanged(lineSpacing: CGFloat, textSpacing: CGFloat)
    func colorDidChanged(item: CTAColorItem)
    func animationDurationDidChanged(t: CGFloat)
    func animationDelayDidChanged(t: CGFloat)
    func animationWillBeDeleted(completedBlock:(() -> ())?)
    func animationWillBeInserted(a: CTAAnimationName, completedBlock:(() -> ())?)
    func animationWillChanged(a: CTAAnimationName)
    func animationWillPlay()
}

typealias CTASelectorViewControllerDelegate = protocol<CTASelectorScaleable>

final class CTASelectorsViewController: UIViewController, UICollectionViewDataSource {
    
    var snapImage: UIImage?
    var preImage: UIImage?
    private var animation: Bool = false
    weak var filterManager: FilterManager?
    weak var dataSource: CTASelectorsViewControllerDataSource?
    weak var delegate: CTASelectorViewControllerDelegate?
    private(set) var currentType: CTAContainerFeatureType = .Templates
    private var container: ContainerVMProtocol? {
        return dataSource?.selectorsViewControllerContainer(self)
    }
    private var count: Int {
        return (container == nil) ? 0 : 1
    }
    private var action: String {
        switch currentType {
            
        case .Templates: return "templateDidChanged:"
        case .Filters: return "filterDidChanged:"
        case .Size: return "scaleChanged:"
        case .Rotator: return "radianChanged:"
        case .Fonts: return "indexPathOfFontsChanged:"
        case .Aligments: return "aligmentsChanged:"
        case .TextSpacing: return "textSpacingChanged:"
        case .Colors: return "colorChanged:"
        case .Animation: return "animationChanged:"
        case .Empty: return ""
        }
    }

    @IBOutlet weak var collectionview: UICollectionView!
    
    deinit {
        print("\(#file) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CTAStyleKit.commonBackgroundColor
        collectionview.layer.masksToBounds = false
    }
    
    func updateSnapshotImage(image: UIImage?) {
        snapImage = image
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                guard let sf = self else {return}
                let index = NSIndexPath(forItem: 0, inSection: 0)
                if let cell = sf.collectionview.cellForItemAtIndexPath(index) as? CTASelectorTemplatesCell {
                    cell.templateList?.updateCurrentOriginImage(image)
                }
        }
    }
    
    func updatePreImage(image: UIImage?) {
        preImage = image
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let sf = self else {return}
            let index = NSIndexPath(forItem: 0, inSection: 0)
            if let cell = sf.collectionview.cellForItemAtIndexPath(index) as? CTASelectorFiltersCell {
                cell.update(image)
            }
        }
    }
    
    func changeToSelector(type: CTAContainerFeatureType) {
        guard let collectionview = collectionview where container != nil else {
            return
        }
        
        if let cell = collectionview.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? CTASelectorCell {
            cell.dataSource = nil
            cell.removeAllTarget()
        }
        
        currentType = type
        let acount = collectionview.numberOfItemsInSection(0)
        
        animation = true
        
        collectionview.performBatchUpdates({ () -> Void in
            
            collectionview.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            
            if acount > 0 {
                collectionview.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
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
        
        if let cell = collectionview.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? CTASelectorCell {
            cell.dataSource = nil
            cell.removeAllTarget()
        }
        
        currentType = dataSource?.selectorsViewController(self, needChangedFromSelectorType: currentType) ?? currentType
        
        let currentCount = collectionview.numberOfItemsInSection(0)
        let nextCount = count
        
        animation = true
        
        collectionview.performBatchUpdates({ () -> Void in
            
            if nextCount > 0 {
                collectionview.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            }
            
            if currentCount > 0 {
                collectionview.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            }
            }, completion: {[weak self] finished in
                
//                dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
                
                    self?.animation = false
//                })
        })
        
    }
    
    func updateIfNeed() {
        
        if let container = container {
            
            switch collectionview.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) {
                
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Selector\(currentType.rawValue)Cell", forIndexPath: indexPath) as! CTASelectorCell
        
        cell.dataSource = self
        
        if let cell = cell as? CTASelectorAnimationCell {
            cell.delegate = self
        }
        
        if let cell = cell as? CTASelectorTemplatesCell {
            cell.templateList?.originImage = snapImage
        }
        
        if let cell = cell as? CTASelectorFiltersCell {
            cell.filterManager = filterManager
            cell.image = snapImage
        }
        
        cell.beganLoad()
        if action.characters.count > 0 {
            cell.addTarget(self, action: Selector(action), forControlEvents: .ValueChanged)
        }
        cell.retriveBeganValue()
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CTASelectorsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = cell as? CTASelectorCell {
            cell.willBeDisplayed()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = cell as? CTASelectorCell {
            cell.didEndDiplayed()
        }
    }
}

// MARK: - SelectorDataSource
extension CTASelectorsViewController: CTASelectorDataSource {
    
    // TODO: Scale began value need fix -- EMIAOSTEIN; 2016-01-13-18:52
    func selectorBeganScale(cell: CTASelectorCell) -> CGFloat {
        return container?.scale ?? 1.0
    }
    
    func selectorBeganRadian(cell: CTASelectorCell) -> CGFloat {
        return container?.radius ?? 0.0
    }
    
    func selectorBeganAlignment(cell: CTASelectorCell) -> NSTextAlignment {
        guard
            let container = container as? TextContainerVMProtocol,
            let textElement = container.textElement else {
            return .Left
        }
         return textElement.alignment
    }
    
    func selectorBeganSpacing(cell: CTASelectorCell) -> (CGFloat, CGFloat) {
        guard
            let container = container as? TextContainerVMProtocol,
            let textElement = container.textElement else {
            return (0, 0)
        }
        return (textElement.lineSpacing, textElement.textSpacing)
    }
    
    // TODO: Font,Color need began value -- EMIAOSTEIN; 2016-01-13-18:51
    func selectorBeganFontIndexPath(cell: CTASelectorCell) -> NSIndexPath? {
        
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
    
    func selectorBeganColor(cell: CTASelectorCell) -> UIColor? {
        
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
    
    func selectorBeganAnimation(cell: CTASelectorCell) -> CTAAnimationBinder? {
        
        return dataSource?.selectorsViewControllerAnimation(self)
    }
}

// MARK: - Actions
extension CTASelectorsViewController {
    
    func templateDidChanged(info: [String: AnyObject]) {
        if let origin = info["origin"] as? Bool {
            if let data = info["data"] as? NSData {
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
    
    func filterDidChanged(name: String) {
        delegate?.filterDidChanged(name)
    }
    
    func scaleChanged(sender: CTASliderView) {
        let v = CGFloat(Int(sender.value * 100.0)) / 100.0
        delegate?.scaleDidChanged(v)
    }
    
    func radianChanged(sender: CTARotatorView) {
        let v = CGFloat(Int(sender.radian * 100.0)) / 100.0
        delegate?.radianDidChanged(v)
    }
    
    func indexPathOfFontsChanged(sender: CTAPickerView) {
        guard let indexPath = sender.selectedIndexPath where animation == false else {
            return
        }
        
        let r = CTAFontsManager.familyAndFontNameWith(indexPath)
        
        guard let family = r.0, let font = r.1 else {
            return
        }
        
        delegate?.fontDidChanged(family, fontName: font)
    }
    
    func aligmentsChanged(sender: CTASegmentControl) {
        delegate?.alignmentDidChanged(NSTextAlignment(rawValue: sender.selectedIndex)!)
    }
    
    func textSpacingChanged(sender: CTATextSpacingView) {
        delegate?.spacingDidChanged(sender.spacing.0, textSpacing: sender.spacing.1)
    }
    
    func colorChanged(sender: CTAColorPickerNodeCollectionView) {
        
        guard let selectedColor = sender.selectedColor where animation == false else { return }
        let colorItem = CTAColorItem(color: selectedColor)
        delegate?.colorDidChanged(colorItem)
    }
    
    func animationChanged(sender: AnyObject) {
        
    }
}

extension CTASelectorsViewController: CTASelectorAnimationCellDelegate {
    
    func animationCellAnimationPlayWillBegan(cell: CTASelectorAnimationCell) {
        delegate?.animationWillPlay()
    }
    
    func animationCellWillDeleteAnimation(cell: CTASelectorAnimationCell, completedBlock:(() -> ())?) {
        delegate?.animationWillBeDeleted({ 
            completedBlock?()
        })
        
    }
    func animationCell(cell: CTASelectorAnimationCell, WillAppendAnimation ani: CTAAnimationName, completedBlock:(() -> ())?) {
        delegate?.animationWillBeInserted(ani, completedBlock: { 
            completedBlock?()
        })
        
    }
    func animationCell(cell: CTASelectorAnimationCell, didChangedToAniamtion ani: CTAAnimationName) {
        delegate?.animationWillChanged(ani)
    }
    
    func animationCell(cell: CTASelectorAnimationCell, durationDidChanged duration: CGFloat) {
        delegate?.animationDurationDidChanged(duration)
    }
    func animationCell(cell: CTASelectorAnimationCell, delayDidChanged delay: CGFloat) {
        delegate?.animationDelayDidChanged(delay)
    }
}
