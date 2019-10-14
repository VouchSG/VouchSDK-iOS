//
//  ProductImageDetailViewController.swift
//  GITSProductDetail
//
//  Created by IDUA on 8/15/17.
//  Copyright © 2017 GITS Indonesia. All rights reserved.
//  Updated by Ajie Arganata on 10 Apr 2018
//

import UIKit
import SDWebImage

struct PhotoViewerModel {
    var url: String?
    var image: UIImage?
}

/// This is a Photo Viewer Page Controller
class PhotoViewerVC: BaseVC {
    @IBOutlet var pagingScrollView: PagingScrollView!
    @IBOutlet var scrollPageLabel: UILabel!
    
    @IBOutlet var closeImage: UIImageView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var pageLabel: UILabel!
    
    var pageIndex : Int = 0
    var pageSize : Int = 0

    var images: [PhotoViewerModel] = []
    var isWithPage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        pagingScrollView.frame = self.view.bounds
        pagingScrollView.delegate = self
        pagingScrollView.dataSource = self
        pagingScrollView.backgroundColor = UIColor.black
        if !isWithPage {
            self.scrollPageLabel.isHidden = true
            self.pageLabel.isHidden = true
        }
        pagingScrollView.reloadData()
        scrollPageLabel.text = "\(pagingScrollView.currentPageIndex + 1) / \(pagingScrollView.totalPage)"
        self.closeImage.image = self.closeImage.image?.maskWithColor(color: .white)
    }
    
    @IBAction func clickCloseAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PhotoViewerVC {
    func configureData(with data: [String: Any?]) {
        self.isWithPage = data["isWithPage"] as? Bool ?? true
        if let img = data["images"] as? [String?] {
            self.images = img.map { obj in
                PhotoViewerModel(url: obj, image: nil)
            }
        } else if let img = data["images"] as? [UIImage?] {
            self.images = img.map { obj in
                PhotoViewerModel(url: nil, image: obj)
            }
        }
        self.pageSize = images.count
        self.pageIndex = data["currentSelected"] as? Int ?? 0
    }
}

extension PhotoViewerVC: PagingScrollViewDelegate, PagingScrollViewDataSource {
    func pagingScrollView(_ pagingScrollView:PagingScrollView, willChangedCurrentPage currentPageIndex:NSInteger) {
        print("current page will be changed to \(currentPageIndex).")
    }
    
    func pagingScrollView(_ pagingScrollView:PagingScrollView, didChangedCurrentPage currentPageIndex:NSInteger) {
        print("current page did changed to \(currentPageIndex).")
        
        scrollPageLabel.text = "\(pagingScrollView.currentPageIndex + 1) / \(pagingScrollView.totalPage)"
    }
    
    func pagingScrollView(_ pagingScrollView:PagingScrollView, layoutSubview view:UIView) {
        print("paging control call layoutsubviews.")
    }
    
    func pagingScrollView(_ pagingScrollView:PagingScrollView, recycledView view:UIView?, viewForIndex index:NSInteger) -> UIView {
        guard view == nil else { return view! }
        
        let zoomingView = ZoomingScrollView(frame: self.view.bounds)
        zoomingView.backgroundColor = UIColor.black
        zoomingView.singleTapEvent = {
            print("single tapped...")
            
            if self.closeImage.isHidden {
                self.closeImage.isHidden = false
            } else {
                self.closeImage.isHidden = true
            }
            if self.closeButton.isEnabled {
                self.closeButton.isEnabled = false
            } else {
                self.closeButton.isEnabled = true
            }
            if self.pageLabel.isHidden {
                if self.isWithPage {
                    self.pageLabel.isHidden = false
                }
            } else {
                self.pageLabel.isHidden = true
            }
        }
        
        zoomingView.doubleTapEvent = {
            print("double tapped...")
        }
        
        zoomingView.pinchTapEvent = {
            print("pinched...")
        }
        
        return zoomingView
    }
    
    func pagingScrollView(_ pagingScrollView:PagingScrollView, prepareShowPageView view:UIView, viewForIndex index:NSInteger) {
        guard let zoomingView = view as? ZoomingScrollView else { return }
        guard let zoomContentView = zoomingView.targetView as? ZoomContentView else { return }
        
        print(images[index])
        zoomContentView.clipsToBounds = true
        zoomContentView.layoutSubviews()
        if let url = images[index].url {
            zoomContentView.sd_setImage(with: URL(string: url)) { (img, err, cache, url) in
                zoomContentView.layoutSubviews()
                if err == nil {
                    zoomContentView.image = img
                } else {
                    zoomContentView.image = nil
                }
                // just call this methods after set image for resizing.
                zoomingView.prepareAfterCompleted()
                zoomingView.setMaxMinZoomScalesForCurrentBounds()
            }
        } else {
            zoomContentView.image = images[index].image
            zoomingView.prepareAfterCompleted()
            zoomingView.setMaxMinZoomScalesForCurrentBounds()
        }
    }
    
    func startIndexOfPageWith(pagingScrollView:PagingScrollView) -> NSInteger {
        return pageIndex
    }
    
    func numberOfPageWith(pagingScrollView:PagingScrollView) -> NSInteger {
        return pageSize
    }
}


extension PhotoViewerVC {
    /** Vouch SDK Bundle
     * This is a variable to get photo viewer bundle
     */
    public static var bundleVouch: Bundle {
        let podBundle = Bundle(for: PhotoViewerVC.self)
        let bundleURL = podBundle.url(forResource: Constant.VOUCH_SDK, withExtension: Constant.BUNDLE)
        if bundleURL == nil {
            return podBundle
        } else{
            return Bundle(url: bundleURL!)!
        }
    }
    
    public static func openPhotoViewerViewController(from controller: UIViewController, data: [String: Any?]) {
        let storyboard = UIStoryboard(name: Constant.PHOTO_VIEWER_STORYBOARD, bundle: PhotoViewerVC.bundleVouch)
        let vc = storyboard.instantiateInitialViewController()! as! PhotoViewerVC
        vc.configureData(with: data)
        controller.present(vc, animated: true, completion: nil)
    }
}
