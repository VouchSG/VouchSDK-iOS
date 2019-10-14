//
//  VouchButtonRepliesTableCell.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 05/09/19.
//

import UIKit

internal class VouchButtonRepliesTableCell: UITableViewCell {
    // MARK: Outlet
    @IBOutlet weak var button: CustomButton!
    @IBOutlet weak var maxChatConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    private var configData: ConfigData?
    private var data: MessageResponseButtons?
    private var onTapButtonAction: ((_ type: String?, _ payload: String?, _ url: String?, _ title: String?) -> ())?
    
    private func configureCell(data: MessageResponseButtons?, configData: ConfigData?) {
        self.data = data
        self.button.setTitle(data?.title ?? "", for: .normal)
        let max = UIScreen.main.bounds.width / 2.8
        self.maxChatConstraint.constant = max
        
        self.configData = configData
        self.button.setTitleColor(Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy), for: .normal)
        self.button.setTitleColor(Color.color(value: configData?.rightBubbleColor, defaultColor: Color.colorWhite), for: .highlighted)
        self.button.backgroundColor = Color.color(value: configData?.backgroundColorChat, defaultColor: Color.colorWhite)
        self.button.borderColor = Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy) ?? Color.colorNavy
        self.button.changeFont(font: configData?.fontStyle ?? "")
    }
    
    @IBAction func buttonTouchUpAction(_ sender: UIButton) {
        self.button.backgroundColor = Color.color(value: configData?.backgroundColorChat, defaultColor: Color.colorWhite)
        guard let data = self.data else { return }
        self.onTapButtonAction?(data.type, data.payload, data.url, data.title)
    }
    
    @IBAction func buttonTouchDownAction(_ sender: UIButton) {
        self.button.backgroundColor = Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy)
    }
}

extension VouchButtonRepliesTableCell {
    public static var name = "VouchButtonRepliesTableCell"
    
    public static func registerCell(_ tableView: UITableView, bundle: Bundle?) {
        tableView.register(UINib(nibName: self.name, bundle: bundle), forCellReuseIdentifier: self.name)
    }
    
    public static func initCell(_ tableView: UITableView, indexPath: IndexPath, data: MessageResponseButtons?, configData: ConfigData?, onTapButtonAction: ((_ type: String?, _ payload: String?, _ url: String?, _ title: String?) -> ())?) -> VouchButtonRepliesTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.name, for: indexPath) as! VouchButtonRepliesTableCell
        cell.configureCell(data: data, configData: configData)
        cell.onTapButtonAction = onTapButtonAction
        cell.selectionStyle = .none
        return cell
    }
}
