//
//  CTAAddBarProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/29.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

func setAddBarView(barView:CTAAddBarView, view:UIView){
    barView.translatesAutoresizingMaskIntoConstraints = false
    barView.heightAnchor.constraintEqualToConstant(40).active = true
    barView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 0.8).active = true
    barView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
    barView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
}

protocol CTAAddBarProtocol{
    func initAddBarView(parentView:UIView?)
    func addBarViewClick(sender: UIPanGestureRecognizer)
    func showEditView()
}

extension CTAAddBarProtocol where Self: UIViewController{
    func initAddBarView(parentView:UIView?){
        
        let barView = CTAAddBarView(frame: CGRect.zero)
        if parentView == nil {
            self.view.addSubview(barView)
            setAddBarView(barView, view: self.view)
        }else {
            parentView!.addSubview(barView)
            setAddBarView(barView, view: parentView!)
        }
        let addBarTap = UITapGestureRecognizer(target: self, action: "addBarViewClick:")
        barView.addGestureRecognizer(addBarTap)
    }
    
    func showEditView(){
        let page = EditorFactory.generateRandomPage()
        //        let doc = CTADocument(fileURL: <#T##NSURL#>, page: page)
        let documentURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileUrl = CTADocumentManager.generateDocumentURL(documentURL)
        CTADocumentManager.createNewDocumentAt(fileUrl, page: page) { (success) -> Void in
            
            if success {
                CTADocumentManager.openDocument(fileUrl, completedBlock: { (success) -> Void in
                    
                    if let openDocument = CTADocumentManager.openedDocument {
                        
                        let editVC = UIStoryboard(name: "Editor", bundle: nil).instantiateViewControllerWithIdentifier("EditViewController") as! EditViewController
                        editVC.document = openDocument
                        
                        self.presentViewController(editVC, animated: false, completion: { () -> Void in
                            
                            
                        })
                    }
                })
            }
        }
    }
}