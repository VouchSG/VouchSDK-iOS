//
//  BaseVC.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 03/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import UIKit
import Alamofire

open class BaseVC: UIViewController {
    private var refreshUIControl: UIRefreshControl?
    public var heightStatusNavBar: CGFloat = 0
    public var requestData: DataRequest?
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.heightStatusNavBar = (UIApplication.shared.statusBarFrame.size.height)  + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    open func configColorBar(colorBar: UIColor?, colorTitle: UIColor?, colorBarButton: UIColor?, alpha: CGFloat = 1, isTranslucent: Bool = false) {
        self.navigationController?.navigationBar.setBackgroundImage(alpha == 1 ? nil : UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = alpha == 1 ? nil : UIImage()
        self.navigationController?.navigationBar.tintColor = colorBarButton
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
        self.navigationController?.navigationBar.barTintColor = colorBar?.withAlphaComponent(alpha)
        self.navigationController?.navigationBar.backgroundColor = colorBar?.withAlphaComponent(alpha)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: colorTitle ?? UIColor.black
        ]
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = alpha == 1 ? UIColor.clear : colorBar?.withAlphaComponent(alpha)
    }
    
    @objc open func becomeActive() {}
}

extension BaseVC {
    open func initRefresh(on view: UIScrollView) {
        self.refreshUIControl = UIRefreshControl()
        self.refreshUIControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        view.refreshControl = refreshUIControl
    }
    
    open func removeRefresh(from view: UIScrollView) {
        self.refreshUIControl?.endRefreshing()
        self.refreshUIControl?.removeTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        view.refreshControl = nil
        self.refreshUIControl = nil
    }
    
    @objc open func refresh() {}
}
