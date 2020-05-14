//
//  ViewController.swift
//  AppIcon
//
//  Created by DDS on 2020/5/14.
//  Copyright © 2020 zerosportsai. All rights reserved.
//

import UIKit
import SnapKit

private let kDefaultAddViewHeight: CGFloat = 126

final class HomeViewController: UIViewController {
  
  private let addView = AddFileView()
  
  private lazy var tableView: UITableView = {
    let tbl = UITableView(frame: .zero, style: .plain)
    tbl.dataSource = self
    tbl.delegate = self
    tbl.separatorStyle = .singleLine
    tbl.separatorInset = .zero
    tbl.contentInsetAdjustmentBehavior = .never
    tbl.contentInset = UIEdgeInsets(top: kDefaultAddViewHeight, left: 0, bottom: 0, right: 0)
    tbl.tableFooterView = UIView()
    tbl.register(ImageFileCell.self, forCellReuseIdentifier: "Cell")
    return tbl
  }()
  
  private let imagePicker = UIImagePickerController()
  
  private var files = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    setupUI()
    
    reloadFiles()
  }

  private func setupUI() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    addView.delegate = self
    view.addSubview(addView)
    addView.snp.makeConstraints { (make) in
      make.left.right.top.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(kDefaultAddViewHeight)
    }
    
    imagePicker.delegate = self
    
    let interaction = UIDropInteraction(delegate: self)
    addView.interactions.append(interaction)
  }
  
  private func reloadFiles() {
    let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    if let contents = try? FileManager.default.contentsOfDirectory(atPath: docPath) {
      files = contents.filter({ $0.hasSuffix(".png") })
      tableView.reloadData()
    }
  }
  
  private func add(_ images: [UIImage]) {
    images.forEach { (image) in
      let imageName = "\(Int(Date().timeIntervalSince1970)).png"
      try? image.pngData()?.write(to: URL(fileURLWithPath: imageName.docPath))
    }
    reloadFiles()
  }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AddFileViewDelegate {
  func onAdd() {
    #if !targetEnvironment(macCatalyst)
    show(imagePicker, sender: self)
    #endif
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    imagePicker.dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage else {
      return
    }
    add([image])
  }
}

extension HomeViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return files.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ImageFileCell
    cell.update(files[indexPath.row])
    return cell
  }
}

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 54
  }

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }

  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    let fileName = files[indexPath.row]
    try? FileManager.default.removeItem(atPath: fileName.docPath)
    try? FileManager.default.removeItem(atPath: fileName.replacingOccurrences(of: ".png", with: "").docPath)
    files.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    show(ImageGearViewController(files[indexPath.row]), sender: self)
  }
}

extension HomeViewController: UIDropInteractionDelegate {
  func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
    session.canLoadObjects(ofClass: UIImage.self)
  }
  
  func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
    UIDropProposal(operation: .copy)
  }
  
  func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
    session.loadObjects(ofClass: UIImage.self) { [weak self] (items) in
      guard let this = self else { return }
      let images = items as! [UIImage]
      this.add(images)
    }
  }
}
