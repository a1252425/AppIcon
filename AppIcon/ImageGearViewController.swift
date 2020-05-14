//
//  ImageGearViewController.swift
//  AppIcon
//
//  Created by DDS on 2020/5/14.
//  Copyright © 2020 zerosportsai. All rights reserved.
//

import UIKit

enum AppIconType: String {
  case iPhoneNotification
  case iPhoneSettings
  case iPhoneSpotlight
  case iPhoneApp
  case iPadNotifications
  case iPadSettings
  case iPadSpotlight
  case iPadApp
  case iPadProApp
  case AppStore
  
  var name: String {
    switch self {
      case .iPhoneNotification: return "iPhone Notification"
      case .iPhoneSettings: return "iPhone Settings"
      case .iPhoneSpotlight: return "iPhone Spotlight"
      case .iPhoneApp: return "iPhone App"
      case .iPadNotifications: return "iPad Notifications"
      case .iPadSettings: return "iPad Settings"
      case .iPadSpotlight: return "iPad Spotlight"
      case .iPadApp: return "iPad App"
      case .iPadProApp: return "iPad Pro App"
      case .AppStore: return "App Store"
    }
  }
  
  var idiom: String {
    switch self {
      case .iPhoneNotification, .iPhoneSettings, .iPhoneSpotlight, .iPhoneApp:
      return "iphone"
      case .iPadNotifications, .iPadSettings, .iPadSpotlight, .iPadApp, .iPadProApp:
      return "ipad"
      case .AppStore:
      return "ios-marketing"
    }
  }
  
  var size: String {
    switch self {
      case .iPhoneNotification: return "20"
      case .iPhoneSettings: return "29"
      case .iPhoneSpotlight: return "40"
      case .iPhoneApp: return "60"
      case .iPadNotifications: return "20"
      case .iPadSettings: return "29"
      case .iPadSpotlight: return "40"
      case .iPadApp: return "76"
      case .iPadProApp: return "83.5"
      case .AppStore: return "1024"
    }
  }
  
  var scales: [Int] {
    switch self {
      case .iPhoneNotification: return [1, 2, 3]
      case .iPhoneSettings: return [1, 2, 3]
      case .iPhoneSpotlight: return [1, 2, 3]
      case .iPhoneApp: return [1, 2, 3]
      case .iPadNotifications: return [1, 2]
      case .iPadSettings: return [1, 2]
      case .iPadSpotlight: return [1, 2]
      case .iPadApp: return [1, 2]
      case .iPadProApp: return [1, 2]
      case .AppStore: return [1]
    }
  }
}

private let kDefaultAddViewHeight: CGFloat = 56

final class ImageGearViewController: UIViewController {
  
  private let fileName: String
  
  private lazy var tableView: UITableView = {
    let tbl = UITableView(frame: .zero, style: .plain)
    tbl.dataSource = self
    tbl.delegate = self
    tbl.separatorStyle = .none
    tbl.contentInsetAdjustmentBehavior = .never
    tbl.contentInset = UIEdgeInsets(top: kDefaultAddViewHeight, left: 0, bottom: 20, right: 0)
    tbl.tableFooterView = UIView()
    tbl.register(ImageGearStateCell.self, forCellReuseIdentifier: "Cell")
    return tbl
  }()
  
  private var files: [AppIconType] = [.iPhoneNotification,
                                      .iPhoneSettings,
                                      .iPhoneSpotlight,
                                      .iPhoneApp,
                                      .iPadNotifications,
                                      .iPadSettings,
                                      .iPadSpotlight,
                                      .iPadApp,
                                      .iPadProApp,
                                      .AppStore]
  
  init(_ fileName: String) {
    self.fileName = fileName
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    view.backgroundColor = UIColor(red: 225 / 255.0, green: 227 / 255.0, blue: 230 / 255.0, alpha: 1)
    
    setupUI()
    reloadFiles()
  }
  
  private func setupUI() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    let backBt = UIButton()
    backBt.setImage(UIImage(systemName: "arrowshape.turn.up.left"), for: .normal)
    backBt.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    view.addSubview(backBt)
    backBt.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(12)
      make.top.equalToSuperview().offset(8)
      make.width.height.equalTo(64)
    }
    
    let shareBt = UIButton()
    shareBt.setImage(UIImage(systemName: "folder"), for: .normal)
    shareBt.addTarget(self, action: #selector(export), for: .touchUpInside)
    view.addSubview(shareBt)
    shareBt.snp.makeConstraints { (make) in
      make.right.equalToSuperview().offset(-12)
      make.top.equalToSuperview().offset(8)
      make.width.height.equalTo(64)
    }
  }
  
  private func reloadFiles() {
    let folderName = fileName.replacingOccurrences(of: ".png", with: "")
    if !FileManager.default.fileExists(atPath: folderName.docPath) {
      try? FileManager.default.createDirectory(atPath: folderName, withIntermediateDirectories: true, attributes: nil)
    }
    
    
  }
  
  @objc private func cancel() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func export(_ button: UIButton) {
    let folderName = fileName.replacingOccurrences(of: ".png", with: "")
    
    for file in files {
      let size = file.size
      for scale in file.scales {
        let filePath = folderName + "/" + folderName + "_\(size)x\(size)@\(scale)x.png"
        if !FileManager.default.fileExists(atPath: filePath.docPath) {
          return
        }
      }
    }
    
    let plistName = "Contents.json"
    let plistPath = folderName + "/" + plistName
    if !FileManager.default.fileExists(atPath: plistPath.docPath) {
      var info: [String: Any] = [
        "info": [
          "version": NSNumber(value: 1),
          "author": "xcode"
        ]
      ]
      var images = [[String: String]]()
      for file in files {
        let size = file.size
        for scale in file.scales {
          let imageName = folderName + "_\(size)x\(size)@\(scale)x.png"
          images.append([
            "size":"\(size)x\(size)",
            "idiom":file.idiom,
            "filename": imageName,
            "scale": "\(scale)x"
          ])
        }
      }
      info["images"] = images
      try? JSONSerialization.data(withJSONObject: info, options: .fragmentsAllowed).write(to: URL(fileURLWithPath: plistPath.docPath))
    }
    
    #if targetEnvironment(macCatalyst)
    #else
    let activity = UIActivityViewController(activityItems: ["导出文件", URL(fileURLWithPath: folderName.docPath)], applicationActivities: nil)
    activity.popoverPresentationController?.sourceView = button
    present(activity, animated: true, completion: nil)
    #endif
  }
}

extension ImageGearViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return files.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ImageGearStateCell
    cell.update(fileName, files[indexPath.row])
    return cell
  }
}

extension ImageGearViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 204
  }

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }

  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    files.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
}
