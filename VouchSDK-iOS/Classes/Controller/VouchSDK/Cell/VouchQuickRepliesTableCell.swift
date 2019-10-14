//
//  VouchQuickRepliesTableCell.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 05/09/19.
//

import UIKit

internal class VouchQuickRepliesTableCell: UITableViewCell {
    // MARK: Outlet
    @IBOutlet private weak var containerStack: UIStackView!
    
    // MARK: Properties
    private var stackList: [UIStackView] = []
    private var onTapButtonAction: ((_ type: String?, _ payload: String?, _ url: String?, _ title: String?) -> ())?
    private var data: [MessageResponseQuickReplies] = []
    private var configData: ConfigData?
    
    private func configureCell(adapter: VouchSDKCollectionAdapter) {
        self.data = adapter.dataManager.listChat.last?.quickReplies ?? []
        self.configData = adapter.configData
        self.stackList.forEach { (list) in
            self.containerStack.removeArrangedSubview(list)
            list.removeFromSuperview()
        }
        self.stackList.removeAll()
        
        if adapter.dataManager.listChat.last?.quickReplies?.count != 0 {
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.spacing = 4
            horizontalStack.alignment = .center
            self.stackList.append(horizontalStack)
            self.containerStack.addArrangedSubview(horizontalStack)
        }
        
        let screenWidth = UIScreen.main.bounds.width
        var totalSection: CGFloat = 32
        var idx = 0
        for data in adapter.dataManager.listChat.last?.quickReplies ?? [] {
            let text = data.contentType == "location" ? "Send Location" : data.title ?? ""
            let font = UIFont.systemFont(ofSize: 12)
            let size = text.size(withAttributes: [
                NSAttributedString.Key.font: font
            ])
            let width = size.width + 16
            let view = createlabel(idx: idx, text: text, configData: adapter.configData)
            if (totalSection + width) < screenWidth {
                totalSection += width
                self.stackList[self.stackList.count-1].addArrangedSubview(view)
            } else {
                totalSection = 32 + width
                let horizontalStack = UIStackView()
                horizontalStack.axis = .horizontal
                horizontalStack.spacing = 4
                horizontalStack.alignment = .center
                self.stackList.append(horizontalStack)
                self.containerStack.addArrangedSubview(horizontalStack)
                self.stackList[self.stackList.count-1].addArrangedSubview(view)
            }
            idx += 1
        }
    }
    
    func createlabel(idx: Int, text: String, configData: ConfigData?)-> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let button = CustomButton()
        button.tag = idx
        button.setTitleColor(Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy), for: .normal)
        button.setTitleColor(Color.color(value: configData?.rightBubbleColor, defaultColor: Color.colorWhite), for: .highlighted)
        button.backgroundColor = Color.color(value: configData?.backgroundColorChat, defaultColor: Color.colorWhite)
        button.borderWidth = 1
        button.borderColor = Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy) ?? Color.colorNavy
        button.setTitle(text, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.buttonTouchUpAction(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(self.buttonTouchDownAction(_:)), for: .touchDown)
        button.changeFont(font: configData?.fontStyle ?? "")
        let text = text
        let font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.font = font
        let size = text.size(withAttributes: [
            NSAttributedString.Key.font: font
        ])
        let width = size.width + 16
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width))
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 35))
        view.insertSubview(button, aboveSubview: view)
        view.addConstraints([
            NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        view.layoutIfNeeded()
        return view
    }
    
    @objc
    private func buttonTouchUpAction(_ sender: UIButton) {
        sender.backgroundColor = Color.color(value: configData?.backgroundColorChat, defaultColor: Color.colorWhite)
        let data = self.data[sender.tag]
        self.onTapButtonAction?(data.contentType, data.payload, nil, data.title)
    }
    
    @objc
    private func buttonTouchDownAction(_ sender: UIButton) {
        sender.backgroundColor = Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy)
    }
}

extension VouchQuickRepliesTableCell {
    public static var name = "VouchQuickRepliesTableCell"
    
    public static func registerCell(_ tableView: UITableView, bundle: Bundle?) {
        tableView.register(UINib(nibName: self.name, bundle: bundle), forCellReuseIdentifier: self.name)
    }
    
    public static func initCell(_ tableView: UITableView, indexPath: IndexPath, adapter: VouchSDKCollectionAdapter, onTapButtonAction: ((_ type: String?, _ payload: String?, _ url: String?, _ title: String?) -> ())?) -> VouchQuickRepliesTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.name, for: indexPath) as! VouchQuickRepliesTableCell
        cell.configureCell(adapter: adapter)
        cell.onTapButtonAction = onTapButtonAction
        cell.selectionStyle = .none
        return cell
    }
}
