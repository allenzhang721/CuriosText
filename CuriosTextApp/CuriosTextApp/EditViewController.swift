//
//  EditViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/23/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, CanvasViewDataSource, CanvasViewDelegate, UICollectionViewDataSource, LineFlowLayoutDelegate {
    
    @IBOutlet weak var scrollBarCollectionView: UICollectionView!
    var canvasView: CanvasView!
    
    @IBOutlet weak var seletectorsView: CTASelectorCollectionView!
    
<<<<<<< b97d14f3a42dd4e55b3f5f286f46bf3c0b1fb541
    let page = EditorFactory.generateRandomPage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        
    }
    
    func setup() {
        
        // canvas
        canvasView = EditorFactory.canvasBy(page)
        canvasView.frame.origin.y = 64
        canvasView.center.x = CGRectGetMidX(view.bounds)
        
        canvasView.backgroundColor = UIColor.lightGrayColor()
        
        canvasView.dataSource = self
        canvasView.delegate = self
        
        // scrollBarCollectView
        let flowLayout = CTALineFlowLayout()
        flowLayout.delegate = self
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: 320 / 4, height: CGRectGetHeight(scrollBarCollectionView.bounds))
        scrollBarCollectionView.setCollectionViewLayout(flowLayout, animated: false)
        scrollBarCollectionView.dataSource = self
        scrollBarCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        // gesture
        let tap = UITapGestureRecognizer(target: canvasView, action: "tap:")
        self.view.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        self.view.addGestureRecognizer(pan)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: "rotation:")
        self.view.addGestureRecognizer(rotation)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: "pinch:")
        self.view.addGestureRecognizer(pinch)
        
        self.view.layer.addSublayer(canvasView.layer)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        canvasView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        self.scrollBarCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 5, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
    }

    var selContainerView: ContainerView?
    var selCotainerVM: ContainerVMProtocol?
    var beginPosition: CGPoint!
    func pan(sender: UIPanGestureRecognizer) {
        
        guard let selContainerView = selContainerView, let selContainer = selCotainerVM else {
            return
        }
        
        let translation = sender.translationInView(self.view)
        
        switch sender.state {
        case .Began:
            beginPosition = CGPoint(x: selContainer.position.x, y: selContainer.position.y)
            
        case .Changed:
            let nextPosition = CGPoint(x: beginPosition.x + translation.x, y: beginPosition.y + translation.y)
            selContainerView.layer.position = nextPosition
            
        case .Ended:
            let nextPosition = CGPoint(x: beginPosition.x + translation.x, y: beginPosition.y + translation.y)
            selContainer.position = (Double(nextPosition.x), Double(nextPosition.y))
        default:
            ()
        }
=======
   private var tabViewController: CTATabViewController!
   private var canvasViewController: CTACanvasViewController!
   private var selectorViewController: CTASelectorsViewController!
   private var selectedIndexPath: NSIndexPath?
    
   private var container: ContainerVMProtocol? {
        guard let selectedIndexPath = selectedIndexPath else {
            return nil
        }
        return page.containerVMs[selectedIndexPath.item]
    }
    
    private var tabItems: [CTATabItem]? {
        
        guard let container = container else {
            return nil
        }
        
        switch container.type {
        case .Text:
            return CTATabItemFactory.shareInstance.textTabItems
            
        default:
            return [CTATabItem]()
        }
    }

   private let page = EditorFactory.generateRandomPage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
>>>>>>> Mod - 'Container' - calculate layout infomation
    }
    
    var beganRadian: CGFloat = 0.0
    func rotation(sender: UIRotationGestureRecognizer) {
        
        guard let selContainerView = selContainerView, let selContainer = selCotainerVM else {
            return
        }
        
        let rotRadian = sender.rotation
        
        switch sender.state {
        case .Began:
            beganRadian = CGFloat(selContainer.radius)
            
<<<<<<< 1066c8aed1e5fa25c540372da6f0f9d962a1f0ab
        case .Changed:
            let nextRotation = beganRadian + rotRadian
            selContainerView.transform = CGAffineTransformMakeRotation(nextRotation)
=======
        case let vc as CTATabViewController:
            tabViewController = vc
            tabViewController.delegate = self
            tabViewController.dataSource = self
>>>>>>> Add - 'RotatorSelector'
            
<<<<<<< b97d14f3a42dd4e55b3f5f286f46bf3c0b1fb541
        case .Ended:
            let nextRotation = beganRadian + rotRadian
            selContainer.radius = Double(nextRotation)
            
        default:
            ()
        }
    }
    
    var beginScale: CGFloat = 1.0
    func pinch(sender: UIPinchGestureRecognizer) {
        
        guard let selContainerView = selContainerView, let selContainer = selCotainerVM as? TextContainerVMProtocol else {
            return
        }
        
        let scale = sender.scale
        
        switch sender.state {
        case .Began:
            beginScale = selContainer.textElement.fontScale
            
        case .Changed:
            let nextfontSize = beginScale * scale
            let r = selContainer.textElement.textResultWithScale(
                nextfontSize,
                constraintSzie: CGSize(width: 320, height: 568 * 2))
            
            selContainerView.bounds.size = r.1
            selContainerView.updateContents(r.3, contentSize: r.2.size, drawInsets: r.0)
            
        case .Ended:
            let nextfontSize = beginScale * scale
            let size = selContainerView.bounds.size
            selContainer.size = (Double(size.width), Double(size.height))
            selContainer.textElement.fontScale = nextfontSize
            
=======
        case let vc as CTASelectorsViewController:
            selectorViewController = vc
            selectorViewController.dataSource = self
            selectorViewController.delegate = self
            
        case let vc as CTACanvasViewController:
            canvasViewController = vc
            canvasViewController.dataSource = self
            canvasViewController.delegate = self

>>>>>>> Mod - 'Container' - calculate layout infomation
        default:
            ()
        }
    }
<<<<<<< b97d14f3a42dd4e55b3f5f286f46bf3c0b1fb541
    
    @IBAction func reloadCavas(sender: AnyObject? = nil) {
        
        selContainerView = nil
        selCotainerVM = nil
        canvasView.reloadData()
    }
    
    @IBAction func add(sender: AnyObject) {
        
        let container = EditorFactory.generateTextContainer(320.0, pageHeigh: 320.0, text: "My name is Chen Xingyu", attributes: CTATextAttributes())
        
        page.append(container)
        reloadCavas()
=======
    
    @IBAction func reloadCavas(sender: AnyObject? = nil) {

    }
    
    @IBAction func add(sender: AnyObject) {

>>>>>>> Mod - 'Container' - calculate layout infomation
    }
    
    @IBAction func del(sender: AnyObject) {

    }
    
    
    // MARK: - Gestures
    private func addGestures() {
        
        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        canvasViewController.view.addGestureRecognizer(pan)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: "rotation:")
        canvasViewController.view.addGestureRecognizer(rotation)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: "pinch:")
        canvasViewController.view.addGestureRecognizer(pinch)
    }
    
    private var beganPosition: CGPoint!
    func pan(sender: UIPanGestureRecognizer) {
        
        guard let selectedIndexPath = selectedIndexPath, let container = container else {
            return
        }
        
        let translation = sender.translationInView(sender.view)
        
        switch sender.state {
        case .Began:
            beganPosition = container.center
        case .Changed:
            let nextPosition = CGPoint(x: beganPosition.x + translation.x, y: beganPosition.y + translation.y)
            container.center = nextPosition
            canvasViewController.updateAt(selectedIndexPath)
            
        case .Ended:
            ()
        default:
            ()
        }
    }
    
    private var beganRadian: CGFloat = 0
    func rotation(sender: UIRotationGestureRecognizer) {
        
        guard let selectedIndexPath = selectedIndexPath, let container = container else {
            return
        }
        
        let rotRadian = sender.rotation
        switch sender.state {
        case .Began:
            beganRadian = CGFloat(container.radius)
            
        case .Changed:
            let nextRotation = beganRadian + rotRadian
            container.radius = nextRotation
            canvasViewController.updateAt(selectedIndexPath)
            
        case .Ended:
            ()
            
        default:
            ()
        }
    }
    
    private var beganScale: CGFloat = 0
    private var oldScale: CGFloat = 0
    func pinch(sender: UIPinchGestureRecognizer) {
        
<<<<<<< b97d14f3a42dd4e55b3f5f286f46bf3c0b1fb541
        guard let selContainer = selCotainerVM as? CTAContainer,
            let index = (page.containerVMs.indexOf{$0.iD == selContainer.iD}) else {
                return
        }
        
        page.removeAt(index)
        reloadCavas()
    }
}



extension EditViewController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ScrollBarCell", forIndexPath: indexPath)
        
//        cell.backgroundColor = UIColor.lightGrayColor()
        return cell
    }
=======
        guard let selectedIndexPath = selectedIndexPath, let container = container else {
            return
        }
        
        let scale = sender.scale
        switch sender.state {
        case .Began:
            beganScale = container.scale
            oldScale = container.scale
            
        case .Changed:
            let nextScale = scale * beganScale
            
            if fabs(nextScale * 100.0 - oldScale * 100.0) > 0.1 {
                let ascale = floor(nextScale * 100) / 100.0
                let canvasSize = canvasViewController.view.bounds.size
                container.updateWithScale(ascale, constraintSzie: CGSize(width: canvasSize.width, height: canvasSize.height * 2))
                
                canvasViewController.updateAt(selectedIndexPath, updateContents: true)
            }
            
        case .Ended:
            ()
        default:
            ()
        }
    }
}


// MARK: - CTATabViewController
extension EditViewController: CTATabViewControllerDataSource {
   // MARK: - DataSource
    
<<<<<<< 1066c8aed1e5fa25c540372da6f0f9d962a1f0ab
>>>>>>> Mod - 'Container' - calculate layout infomation
=======
    func tableViewControllerNumberOfItems(viewController: CTATabViewController) -> Int {
        
        guard let items = tabItems else {
            return 0
        }
        
        return items.count
    }
>>>>>>> Add - 'RotatorSelector'
    
    func tableViewController(viewController: CTATabViewController, tabItemAtIndexPath indexPath: NSIndexPath) -> CTATabItem {
        
        guard let items = tabItems else {
            return CTATabItem()
        }
        
        return items[indexPath.item]
    }
    
    // MARK: - Delegate
    
    func didChangeTo(collectionView: UICollectionView, itemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        guard let items = tabItems, let selectorItem = items[indexPath.item].userInfo as? CTASelectorTabItem else {
            return
        }

<<<<<<< 1066c8aed1e5fa25c540372da6f0f9d962a1f0ab
        seletectorsView.changeTo(.Size)
=======
        selectorViewController.changeToSelector(selectorItem.type)
>>>>>>> Add - 'RotatorSelector'
    }
    
}


<<<<<<< 1066c8aed1e5fa25c540372da6f0f9d962a1f0ab
// MARK: - CanvasDataSource, CanvasDelegate
extension EditViewController {
=======
// MARK: - CTACanvasViewController
extension EditViewController: CanvasViewControllerDataSource, CanvasViewControllerDelegate {
    // MARK: - DataSource
>>>>>>> Add - 'RotatorSelector'
    
    func numberOfcontainerInCanvasView(canvas: CanvasView) -> Int {
        
        return page.containerVMs.count
    }
    
    func canvasView(canvas: CanvasView, containerAtIndex index: Int) -> ContainerView {
        
        let containerView = EditorFactory.containerBy(page.containerVMs[index])
        return containerView
    }
    
    func canvasView(canvas: CanvasView, didSelectedContainerAtIndex index: Int) {
        
        selContainerView = canvas.containerViewAt(index)
        selCotainerVM = page.containerByID(selContainerView!.iD)
    }
    
    
    // MARK: - Delegate
    
    func canvasViewController(viewCOntroller: CTACanvasViewController, didSelectedIndexPath indexPath: NSIndexPath) {
        
        selectedIndexPath = indexPath
        tabViewController.collectionView.reloadData()
        selectorViewController.updateSelector()
    }
}

// MARK: - CTASelectorsViewController

extension EditViewController: CTASelectorsViewControllerDataSource, CTASelectorViewControllerDelegate {
    
    // MARK: - DataSource
    func selectorsViewControllerContainer(viewcontroller: CTASelectorsViewController) -> ContainerVMProtocol? {
        
        return container
    }
    
    // MARK: - Delegate
    
    func scaleDidChanged(scale: CGFloat) {
        
        guard let selectedIndexPath = selectedIndexPath, let container = container else {
            return
        }
        
        let canvasSize = canvasViewController.view.bounds.size
        container.updateWithScale(scale, constraintSzie: CGSize(width: canvasSize.width, height: canvasSize.height * 2))
        
        canvasViewController.updateAt(selectedIndexPath, updateContents: true)
    }
    
    func radianDidChanged(radian: CGFloat) {
        
        guard let selectedIndexPath = selectedIndexPath, let container = container else {
            return
        }
        
        container.radius = radian
        canvasViewController.updateAt(selectedIndexPath, updateContents: false)
    }
}
