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
}

protocol CTASelectorable: class {
    
}

protocol CTASelectorScaleable: CTASelectorable {
    func scaleDidChanged(scale: CGFloat)
    func radianDidChanged(radian: CGFloat)
    func fontDidChanged(fontFamily: String, fontName: String)
    func alignmentDidChanged(alignment: NSTextAlignment)
    func spacingDidChanged(lineSpacing: CGFloat, textSpacing: CGFloat)
    func colorDidChanged(item: CTAColorItem)
}

typealias CTASelectorViewControllerDelegate = protocol<CTASelectorScaleable>

final class CTASelectorsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var dataSource: CTASelectorsViewControllerDataSource?
    var delegate: CTASelectorViewControllerDelegate?
    private var began: Bool = false
    private var currentType: CTASelectorType = .Fonts
    private var container: ContainerVMProtocol? {
        return dataSource?.selectorsViewControllerContainer(self)
    }
    private var count: Int {
        return (container == nil) ? 0 : 1
    }
    private var action: String {
        switch currentType {
        case .Size: return "scaleChanged:"
        case .Rotator: return "radianChanged:"
        case .Fonts: return "indexPathOfFontsChanged:"
        case .Aligments: return "aligmentsChanged:"
        case .TextSpacing: return "textSpacingChanged:"
        case .Colors: return "indexPathOfColorChanged:"
        }
    }

    @IBOutlet weak var collectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeToSelector(type: CTASelectorType) {
        guard let collectionview = collectionview where container != nil else {
            return
        }
        
        if let cell = collectionview.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? CTASelectorCell {
            cell.dataSource = nil
            cell.removeAllTarget()
        }
        
        currentType = type
        let acount = collectionview.numberOfItemsInSection(0)
        
        collectionview.performBatchUpdates({ () -> Void in
            
            collectionview.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            
            if acount > 0 {
                collectionview.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            }
            
            }, completion: nil)
    }
    
    func updateSelector() {
        guard let collectionview = collectionview else {
            return
        }
        
        if let cell = collectionview.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? CTASelectorCell {
            cell.dataSource = nil
            cell.removeAllTarget()
        }
        
        let currentCount = collectionview.numberOfItemsInSection(0)
        let nextCount = count
        
        collectionview.performBatchUpdates({ () -> Void in
            
            if nextCount > 0 {
                collectionview.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            }
            
            if currentCount > 0 {
                collectionview.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            }
            }, completion: nil)
    }
    
    func updateIfNeed() {
        
        if let container = container {
            
            switch collectionview.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) {
                
            case let cell as CTASelectorSizeCell:
                cell.sizeView.updateValue(container.scale)
                
            case let cell as CTASelectorRotatorCell:
                cell.view.radian = container.radius
            default:
                ()
            }
        }
    }
    
}

extension CTASelectorsViewController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Selector\(currentType.rawValue)Cell", forIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? CTASelectorCell else {
            return
        }
        cell.dataSource = self
        cell.retriveBeganValue()
        cell.addTarget(self, action: Selector(action), forControlEvents: .ValueChanged)
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
    
//    func selectorBeganIndexPath(cell: CTASelectorCell) -> NSIndexPath {
//        return NSIndexPath(forItem: 0, inSection: 0)
//    }
    
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
}

// MARK: - Actions
extension CTASelectorsViewController {
    func scaleChanged(sender: CTAScrollTuneView) {
        let v = CGFloat(Int(sender.value * 100.0)) / 100.0
        delegate?.scaleDidChanged(v)
    }
    
    func radianChanged(sender: CTARotatorView) {
        let v = CGFloat(Int(sender.radian * 100.0)) / 100.0
        delegate?.radianDidChanged(v)
    }
    
    func indexPathOfFontsChanged(sender: CTAPickerView) {
        guard let indexPath = sender.selectedIndexPath else {
            return
        }
        
        let family = UIFont.familyNames()[indexPath.section]
        let fontName = UIFont.fontNamesForFamilyName(family)
        
        let name: String
        if fontName.count > 0 && fontName.count >= indexPath.item {
            name = fontName[indexPath.item]
        } else {
            name = ""
        }
        
        delegate?.fontDidChanged(family, fontName: name)
    }
    
    func aligmentsChanged(sender: CTASegmentControl) {
        delegate?.alignmentDidChanged(NSTextAlignment(rawValue: sender.selectedIndex)!)
    }
    
    func textSpacingChanged(sender: CTATextSpacingView) {
        delegate?.spacingDidChanged(sender.spacing.0, textSpacing: sender.spacing.1)
        
    }
    
    func indexPathOfColorChanged(sender: CTAPickerView) {
        guard
            let selectedIndexPath = sender.selectedIndexPath,
            let colorItem = CTAColorsManger.colorAtIndexPath(selectedIndexPath) else {
            return
        }
        
        delegate?.colorDidChanged(colorItem)
    }
}
