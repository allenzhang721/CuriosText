//
//  AniContainer.swift
//  PopApp
//
//  Created by Emiaostein on 4/3/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

class AniContainer: NSObject {
    let container: Container
    let contents: [AniContent]
    let animations: [Int: AniDescriptor]
    var imageRetriver: ((String, (String, UIImage?) -> ()) -> ())?
    
    init(container: Container, animations: [Int: AniDescriptor] = [:]) {
        var cs = [AniContent]()
        for c in container.contents {
            let content = AniContent(content: c)
            cs.append(content)
        }
        self.contents = cs
        self.container = container
        self.animations = animations
    }
}

extension AniContainer: Layerable {
    var position: CGPoint { return CGPoint(x: container.positionX, y: container.positionY) }
    var size: CGSize { return CGSize(width: container.width, height: container.height) }
    var transform: CATransform3D { return CATransform3DMakeRotation(CGFloat(container.rotation) / 180.0 * CGFloat(M_PI), 0, 0, 1) }
}

extension AniContainer: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell {
            
            let source = contents[indexPath.item].content.source
            let cell: UICollectionViewCell
            switch source.sourceType {
            case .Text:
                
                let acell = collectionView.dequeueReusableCellWithReuseIdentifier(containerItemIdentifier + source.sourceType.rawValue, forIndexPath: indexPath) as! ContentTextCell
                acell.text = NSAttributedString(string: source.texts, attributes: source.attribute)
                cell = acell
                
            case .Image:
                let acell = collectionView.dequeueReusableCellWithReuseIdentifier(containerItemIdentifier + source.sourceType.rawValue, forIndexPath: indexPath) as! ContentImageCell
                if let retriver = imageRetriver {
                    let imageName = source.ImageName
                    let r = { (name: String, Image: UIImage?) in
                        if name == imageName {
                            dispatch_async(dispatch_get_main_queue(), { 
                                acell.image = Image
                            })
                        }
                    }
                    retriver(imageName, r)
                }
                
                cell = acell
            }

//            cell.backgroundColor = UIColor.yellowColor()
            return cell
    }
}

extension AniContainer: ContainerLayoutDataSource {
    
    func layerAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> Layerable? {
        if indexPath.item < contents.count {
            return contents[indexPath.item]
        } else {
            return nil
        }
    }
}

extension AniContainer: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
//        cell.backgroundColor = UIColor.lightGrayColor()
//        cell.contentView.backgroundColor = UIColor.lightGrayColor()
    }
}