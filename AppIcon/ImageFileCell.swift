//
//  ImageFileCell.swift
//  AppIcon
//
//  Created by DDS on 2020/5/14.
//  Copyright © 2020 zerosportsai. All rights reserved.
//

import UIKit

final class ImageFileCell: UITableViewCell {
  
  private let fileImageView = UIImageView()
  private let fileNameLabel = UILabel()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    fileNameLabel.textColor = .black
    fileNameLabel.font = UIFont.systemFont(ofSize: 16)
    fileImageView.contentMode = .scaleAspectFill
    fileImageView.clipsToBounds = true
    
    accessoryType = .disclosureIndicator
    selectionStyle = .none
    
    contentView.addSubview(fileImageView)
    fileImageView.snp.makeConstraints { (make) in
      make.left.top.bottom.equalToSuperview().inset(8)
      make.width.equalTo(fileImageView.snp.height)
    }
    
    contentView.addSubview(fileNameLabel)
    fileNameLabel.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.equalTo(fileImageView.snp.right).offset(8)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(_ fileName: String) {
    fileNameLabel.text = fileName
    fileImageView.image = UIImage(contentsOfFile: fileName.docPath)
  }
}
