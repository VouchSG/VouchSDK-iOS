//
//  VouchListElementTableCell.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 12/09/19.
//

import UIKit

internal class VouchListElementTableCell: UITableViewCell {
    // MARK: Outlet
    @IBOutlet private weak var cardViewTop: CardView!
    @IBOutlet private weak var cardViewCenter: CardView!
    @IBOutlet private weak var cardViewBottom: CardView!
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var descLbl: UILabel!
    @IBOutlet private weak var buttonStackVw: UIStackView!
    @IBOutlet private weak var listImageStackVw: UIStackView!
    @IBOutlet private weak var listImageVw: UIImageView!
    @IBOutlet private weak var maxChatConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    private var listButton: [CustomButton] = []
    private var configData: ConfigData?
    private var data: MessageResponseLists?
    private var onTapButtonAction: ((_ type: String?, _ payload: String?, _ url: String?, _ title: String?) -> ())?
    
    private func configureCell(data: MessageResponseLists?, configData: ConfigData?, isFirst: Bool, isLast: Bool) {
        self.data = data
        self.configData = configData
        self.titleLbl.text = data?.title ?? "-"
        self.descLbl.text = data?.subtitle
        if let img = data?.imageUrl, let url = URL(string: img) {
            self.listImageStackVw.isHidden = false
            self.listImageVw.backgroundColor = .clear
            self.listImageVw.sd_setImage(with: url, completed: nil)
        } else {
            self.listImageStackVw.isHidden = true
            self.listImageVw.image = nil
            self.listImageVw.backgroundColor = .lightGray
        }
        
        // List Button
        self.listButton.forEach { (button) in
            self.buttonStackVw.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        self.listButton.removeAll()
        if listButton.count == 0 {
            var idx = 0
            for dt in data?.buttons ?? [] {
                let button = CustomButton()
                button.tag = idx
                button.borderWidth = 1
                button.cornerRadius = 3
                button.shadow = 0
                button.shadowRadius = 0
                button.setTitle(dt.title, for: .normal)
                button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30))
                button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
                button.setTitleColor(Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy), for: .normal)
                button.setTitleColor(Color.color(value: configData?.rightBubbleColor, defaultColor: Color.colorWhite), for: .highlighted)
                button.backgroundColor = .clear
                button.borderColor = Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy) ?? Color.colorNavy
                button.addTarget(self, action: #selector(self.buttonTouchUpAction(_:)), for: .touchUpInside)
                button.addTarget(self, action: #selector(self.buttonTouchDownAction(_:)), for: .touchDown)
                button.changeFont(font: configData?.fontStyle ?? "")
                listButton.append(button)
                self.buttonStackVw.addArrangedSubview(button)
                idx += 1
            }
        }
        
        // Constraint
        let max = UIScreen.main.bounds.width / 2.8
        self.maxChatConstraint.constant = max
        self.topConstraint.constant = isLast ? 8 : 0
        self.bottomConstraint.constant = isFirst ? 8 : 0
        
        // Container
        self.cardViewTop.cornerRadius = isLast ? 5 : 0
        self.cardViewBottom.cornerRadius = isFirst ? 5 : 0
        self.cardViewTop.borderColor = Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy) ?? Color.colorNavy
        self.cardViewBottom.borderColor = Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy) ?? Color.colorNavy
        self.cardViewCenter.borderColor = Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy) ?? Color.colorNavy
        
        self.titleLbl.changeFont(fontText: configData?.fontStyle ?? "")
        self.descLbl.changeFont(fontText: configData?.fontStyle ?? "")
    }
    
    @objc
    private func buttonTouchUpAction(_ sender: UIButton) {
        sender.backgroundColor = Color.color(value: configData?.backgroundColorChat, defaultColor: Color.colorWhite)
        guard let data = self.data?.buttons?[sender.tag] else { return }
        self.onTapButtonAction?(data.type, data.payload, data.url, data.title)
    }
    
    @objc
    private func buttonTouchDownAction(_ sender: UIButton) {
        sender.backgroundColor = Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy)
    }
}

extension VouchListElementTableCell {
    public static var name = "VouchListElementTableCell"
    
    public static func registerCell(_ tableView: UITableView, bundle: Bundle?) {
        tableView.register(UINib(nibName: self.name, bundle: bundle), forCellReuseIdentifier: self.name)
    }
    
    public static func initCell(_ tableView: UITableView, indexPath: IndexPath, data: MessageResponseLists?, configData: ConfigData?, onTapButtonAction: ((_ type: String?, _ payload: String?, _ url: String?, _ title: String?) -> ())?, isLast: Bool) -> VouchListElementTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.name, for: indexPath) as! VouchListElementTableCell
        cell.configureCell(data: data, configData: configData, isFirst: isLast, isLast: indexPath.row == 0)
        cell.onTapButtonAction = onTapButtonAction
        cell.selectionStyle = .none
        return cell
    }
}
