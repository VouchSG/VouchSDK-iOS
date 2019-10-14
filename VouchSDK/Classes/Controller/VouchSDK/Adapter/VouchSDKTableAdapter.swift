//
//  VouchSDKTableAdapter.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 27/08/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import UIKit

internal class VouchSDKTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    private var dataManager: VouchSDKDataManager
    private var collectionAdapter: VouchSDKCollectionAdapter
    public var configData: ConfigData?
    public var onTapButtonAction: ((_ msgType: String?, _ payload: String?, _ url: String?, _ title: String?) -> ())?
    public var onTapPreviewBtnAction: ((_ type: String?, _ url: String?)->())?
    public var onTapRetryBtnAction: ((_ idx: Int)->())?
    
    init(dataManager: VouchSDKDataManager, collectionAdapter: VouchSDKCollectionAdapter, configData: ConfigData) {
        self.dataManager = dataManager
        self.collectionAdapter = collectionAdapter
        self.configData = configData
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataManager.listChat.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isLast = section == self.dataManager.listChat.count - 1
        if self.dataManager.listChat[section].msgType == "gallery" {
            return 1
        } else if self.dataManager.listChat[section].msgType == "list" {
            return (self.dataManager.listChat[section].lists?.count ?? 0) + (self.dataManager.listChat[section].buttons?.count ?? 0)
        } else {
            return 1 + (self.dataManager.listChat[section].buttons?.count ?? 0) + ((self.dataManager.listChat.last?.quickReplies?.count ?? 0) != 0  && isLast ? 1 : 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.dataManager.listChat[indexPath.section].msgType == "gallery" {
            self.collectionAdapter.currentIdx = indexPath.section
            return VouchGalleryTableCell.initCell(tableView, indexPath: indexPath, adapter: self.collectionAdapter)
        } else if self.dataManager.listChat[indexPath.section].msgType == "list" {
            if indexPath.row + 1 <= (self.dataManager.listChat[indexPath.section].lists?.count ?? 0) {
                return VouchListElementTableCell.initCell(tableView, indexPath: indexPath, data: self.dataManager.listChat[indexPath.section].lists?[indexPath.row], configData: self.configData, onTapButtonAction: self.onTapButtonAction, isLast: indexPath.row + 1 == self.dataManager.listChat[indexPath.section].lists?.count)
            } else {
                return VouchButtonRepliesTableCell.initCell(tableView, indexPath: indexPath, data: self.dataManager.listChat[indexPath.section].buttons?[indexPath.row-(self.dataManager.listChat[indexPath.section].lists?.count ?? 0)], configData: self.configData, onTapButtonAction: self.onTapButtonAction)
            }
        } else {
            if self.dataManager.listChat[indexPath.section].fromMe == true {
                return VouchMyChatListTableCell.initCell(tableView, indexPath: indexPath, data: self.dataManager.listChat[indexPath.section], configData: self.configData, onTapPreviewBtnAction: self.onTapPreviewBtnAction, onTapRetryBtnAction: self.onTapRetryBtnAction)
            } else {
                let lastRow = (self.dataManager.listChat[indexPath.section].buttons?.count ?? 0) + ((self.dataManager.listChat[indexPath.section].quickReplies?.count ?? 0) != 0 && indexPath.section == self.dataManager.listChat.count - 1 ? 1 : 0)
                if indexPath.row == 0 {
                    return VouchOtherChatListTableCell.initCell(tableView, indexPath: indexPath, data: self.dataManager.listChat[indexPath.section], configData: self.configData, onTapPreviewBtnAction: self.onTapPreviewBtnAction)
                } else if indexPath.row == lastRow && (self.dataManager.listChat[indexPath.section].quickReplies?.count ?? 0) != 0 {
                    return VouchQuickRepliesTableCell.initCell(tableView, indexPath: indexPath, adapter: self.collectionAdapter, onTapButtonAction: self.onTapButtonAction)
                } else {
                    return VouchButtonRepliesTableCell.initCell(tableView, indexPath: indexPath, data: self.dataManager.listChat[indexPath.section].buttons?[indexPath.row-1], configData: self.configData, onTapButtonAction: self.onTapButtonAction)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
