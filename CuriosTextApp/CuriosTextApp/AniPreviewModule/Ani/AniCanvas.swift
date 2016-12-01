//
//  AniCanvas.swift
//  PopApp
//
//  Created by Emiaostein on 4/3/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

enum AniCanvasAccessResult {
    case success(Int, Container)
    case failture
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
    
    func accessContainerBy(_ ID: String) -> AniCanvasAccessResult {
        if let i = (canvas.containers.index{$0.identifier == ID}) {
            return AniCanvasAccessResult.success(i, canvas.containers[i])
        } else {
            return AniCanvasAccessResult.failture
        }
    }
    
    func aniCanvasByAnimationAt(_ index: Int) -> AniCanvas {
        
        let filtedCanvas = canvas.canvasWithAnimationAt(index)
        let nextAniCanvas = AniCanvas(canvas: filtedCanvas)
        return nextAniCanvas
    }
    
    func aniCanvasByAnimationWith(_ AniID: String) -> AniCanvas {
        guard let index = (canvas.animations.index{ $0.ID == AniID }) else {
            return self
        }
        
        let filtedCanvas = canvas.canvasWithAnimationAt(index)
        let nextAniCanvas = AniCanvas(canvas: filtedCanvas)
        return nextAniCanvas
    }
}

extension Canvas {
    
    fileprivate func canvasWithAnimationAt(_ index: Int) -> Canvas {
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
        let preAnimations = animations[0..<index].reversed()
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
        
        let canvas = Canvas(width: width, height: height, containers: validContainers, animations: [animation], backgroundColor: backgroundColor)
        
        return canvas
    }
    
}

extension AniCanvas: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return containers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: canvasItemIdentifier, for: indexPath)
                as! ContainerCell
            
//                        cell.backgroundColor = UIColor.redColor()
            cell.dataSource = containers[indexPath.item]
            cell.delegate = containers[indexPath.item]
            
            return cell
    }
}

extension AniCanvas: CanvasLayoutDataSource {
    
    func layerAttributesForItemAtIndexPath(_ indexPath: IndexPath) -> Layerable? {
        if indexPath.item < containers.count {
            return containers[indexPath.item]
        } else {
            return nil
        }
    }
}

extension AniCanvas: AniPlayCanvasViewDataSource {
    
    func animationsForAniPlayCanvasView(_ view: AniPlayCanvasView) -> [Animation]? {
        
        return canvas.animations
    }
    func containerItemForAniPlayCanvasView(_ view: AniPlayCanvasView, containerID: String) -> AniCanvasAccessResult {
        return accessContainerBy(containerID)
    }
}
