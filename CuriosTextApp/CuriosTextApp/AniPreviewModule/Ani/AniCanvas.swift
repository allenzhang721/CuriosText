//
//  AniCanvas.swift
//  PopApp
//
//  Created by Emiaostein on 4/3/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

enum AniCanvasAccessResult {
    case Success(Int, Container)
    case Failture
}

class AniCanvas: NSObject {
    let canvas: Canvas
    let containers: [AniContainer]
    var size: CGSize { return CGSize(width: CGFloat(canvas.width), height: CGFloat(canvas.height)) }
    
    init(canvas: Canvas) {
        var cs = [AniContainer]()
        for c in canvas.containers {
            let container = AniContainer(container: c)
            cs.append(container)
        }
        self.containers = cs
        self.canvas = canvas
    }
    
    func accessContainerBy(ID: String) -> AniCanvasAccessResult {
        if let i = (canvas.containers.indexOf{$0.identifier == ID}) {
            return AniCanvasAccessResult.Success(i, canvas.containers[i])
        } else {
            return AniCanvasAccessResult.Failture
        }
    }
    
    func aniCanvasByAnimationAt(index: Int) -> AniCanvas {
        
        let filtedCanvas = canvas.canvasWithAnimationAt(index)
        let nextAniCanvas = AniCanvas(canvas: filtedCanvas)
        return nextAniCanvas
    }
    
    func aniCanvasByAnimationWith(AniID: String) -> AniCanvas {
        guard let index = (canvas.animations.indexOf{ $0.ID == AniID }) else {
            return self
        }
        
        let filtedCanvas = canvas.canvasWithAnimationAt(index)
        let nextAniCanvas = AniCanvas(canvas: filtedCanvas)
        return nextAniCanvas
    }
}

extension Canvas {
    
    private func canvasWithAnimationAt(index: Int) -> Canvas {
        guard animations.count > 0 && 0 <= index && index < animations.count else {
            print("The Animation Index is Invalid.")
            return self
        }
        let n = animations.count
        let animation = animations[index]
        let aniTargetID = animation.targetID
        // find not display containerID
        var notDisplayContainerID = [String]()
        
        // 0..<Index Animations
        let preAnimations = animations[0..<index].reverse()
        var firstTargetIDs = [String]()
        var firstTargetAnis = [Animation]()
        for ani in preAnimations {
            if ani.targetID != aniTargetID && !firstTargetIDs.contains(ani.targetID) {
                firstTargetIDs.append(ani.targetID)
                firstTargetAnis.append(ani)
            }
        }
        
        let notDisplayAtEndAnis = firstTargetAnis.filter {
            if let type = CTAAnimationType(rawValue: $0.descriptor.type) {
                return !type.displayAtEnd()
            } else {
                return true
            }
        }
        notDisplayContainerID += notDisplayAtEndAnis.map { $0.targetID }
        
        // Index..<n Animations
        let afterAnimations = animations[index..<n]
        var aftfirstTargetIDs = [String]()
        var aftfirstTargetAnis = [Animation]()
        for ani in afterAnimations {
            if ani.targetID != aniTargetID && !aftfirstTargetIDs.contains(ani.targetID) {
                aftfirstTargetIDs.append(ani.targetID)
                aftfirstTargetAnis.append(ani)
            }
        }
        
        let notDisplayAtBeganAnis = aftfirstTargetAnis.filter {if let type = CTAAnimationType(rawValue: $0.descriptor.type) {
            return !type.displayAtBegan()
        } else {
            return true
            }}
        
        notDisplayContainerID += notDisplayAtBeganAnis.map { $0.targetID }
        
        let validContainers = containers.filter{ !notDisplayContainerID.contains($0.identifier) }
        
        let canvas = Canvas(width: width, height: height, containers: validContainers, animations: [animation])
        
        return canvas
    }
    
}

extension AniCanvas: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return containers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(canvasItemIdentifier, forIndexPath: indexPath)
                as! ContainerCell
            
            //            cell.backgroundColor = UIColor.yellowColor()
            cell.dataSource = containers[indexPath.item]
            cell.delegate = containers[indexPath.item]
            
            return cell
    }
}

extension AniCanvas: CanvasLayoutDataSource {
    
    func layerAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> Layerable? {
        if indexPath.item < containers.count {
            return containers[indexPath.item]
        } else {
            return nil
        }
    }
}

extension AniCanvas: AniPlayCanvasViewDataSource {
    
    func animationsForAniPlayCanvasView(view: AniPlayCanvasView) -> [Animation]? {
        
        return canvas.animations
    }
    func containerItemForAniPlayCanvasView(view: AniPlayCanvasView, containerID: String) -> AniCanvasAccessResult {
        return accessContainerBy(containerID)
    }
}
