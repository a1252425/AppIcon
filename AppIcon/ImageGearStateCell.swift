//
//  ImageGearStateCell.swift
//  AppIcon
//
//  Created by DDS on 2020/5/14.
//  Copyright © 2020 zerosportsai. All rights reserved.
//

import UIKit

final class ImageGearsView: UIView {
  init(_ fileName: String, _ type: AppIconType) {
    super.init(frame: .zero)
    
    var lastImageView: UIView?
    type.scales.forEach { (scale) in
      let imageView = UIImageView()
      imageView.setImage(fileName, scale: scale, size: type.size)
      addSubview(imageView)
      if let last = lastImageView {
        imageView.snp.makeConstraints { (make) in
          make.top.equalToSuperview()
          make.left.equalTo(last.snp.right).offset(30)
          make.width.height.equalTo(120)
        }
      } else {
        imageView.snp.makeConstraints { (make) in
          make.top.equalToSuperview()
          make.left.equalToSuperview().offset(30)
          make.width.height.equalTo(120)
        }
      }
      
      let scaleLabel = UILabel()
      scaleLabel.font = UIFont.systemFont(ofSize: 13)
      scaleLabel.textColor = .black
      scaleLabel.text = "\(scale)x"
      addSubview(scaleLabel)
      scaleLabel.snp.makeConstraints { (make) in
        make.centerX.equalTo(imageView)
        make.top.equalTo(imageView.snp.bottom)
        make.height.equalTo(30)
      }
      
      lastImageView = imageView
      
      imageView.layer.cornerRadius = 4
      imageView.layer.masksToBounds = true
    }
    
    let lineView = UIView()
    lineView.backgroundColor = .lightGray
    addSubview(lineView)
    lineView.snp.makeConstraints { (make) in
      make.left.right.bottom.equalToSuperview()
      make.height.equalTo(0.5)
      make.right.equalTo(lastImageView!).offset(30)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class ImageGearStateCell: UITableViewCell {
  
  private let imageContentView = UIView()
  private let infoLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    selectionStyle = .none
    
    imageContentView.backgroundColor = .clear
    contentView.addSubview(imageContentView)
    imageContentView.snp.makeConstraints { (make) in
      make.left.right.top.equalToSuperview()
      make.height.equalTo(150)
    }
    
    infoLabel.font = UIFont.systemFont(ofSize: 14)
    infoLabel.textColor = UIColor.black
    contentView.addSubview(infoLabel)
    infoLabel.snp.makeConstraints { (make) in
      make.top.equalTo(imageContentView.snp.bottom).offset(8)
      make.centerX.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ImageGearStateCell {
  func update(_ fileName: String, _ gearName: AppIconType) {
    infoLabel.text = "\(gearName.name) \(gearName.size)pt"
    
    imageContentView.subviews.forEach({ $0.removeFromSuperview() })
    let imagesView = ImageGearsView(fileName, gearName)
    imageContentView.addSubview(imagesView)
    imagesView.snp.makeConstraints { (make) in
      make.top.bottom.centerX.equalToSuperview()
    }
  }
}

extension UIImageView {
  func setImage(_ fileName: String, scale: Int, size: String) {
    contentMode = .scaleAspectFill
    
    let folderName = fileName.replacingOccurrences(of: ".png", with: "")
    let filePath = folderName + "/" + folderName + "_\(size)x\(size)@\(scale)x.png"
    
    if FileManager.default.fileExists(atPath: filePath.docPath) {
      image = UIImage(contentsOfFile: filePath.docPath)
    } else {
      if !FileManager.default.fileExists(atPath: folderName.docPath) {
        try? FileManager.default.createDirectory(atPath: folderName.docPath, withIntermediateDirectories: true, attributes: nil)
      }
      DispatchQueue.global().async {
        let size = CGFloat(Float(size) ?? 0)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, CGFloat(scale))
        defer { UIGraphicsEndImageContext() }
        let image = UIImage(contentsOfFile: fileName.docPath)!
        image.draw(in: CGRect(x: 0, y: 0, width: size, height: size))
        if let drawedImage = UIGraphicsGetImageFromCurrentImageContext() {
          try? drawedImage.pngData()?.write(to: URL(fileURLWithPath: filePath.docPath))
          DispatchQueue.main.async {
            self.image = drawedImage
          }
        }
      }
    }
  }
}
