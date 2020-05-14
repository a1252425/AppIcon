//
//  AddFileView.swift
//  AppIcon
//
//  Created by DDS on 2020/5/14.
//  Copyright © 2020 zerosportsai. All rights reserved.
//

import UIKit

protocol AddFileViewDelegate: AnyObject {
  func onAdd()
}

final class AddFileView: UIView {
  
  weak var delegate: AddFileViewDelegate?

  private let addLayer = CAShapeLayer()
  private let borderLayer = CAShapeLayer()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    
    #if targetEnvironment(macCatalyst)
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 20)
    label.text = "请将文件拖到此处"
    addSubview(label)
    label.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
    #else
    addLayer.fillColor = UIColor.clear.cgColor
    addLayer.lineWidth = 2
    addLayer.strokeColor = UIColor.lightGray.cgColor
    layer.addSublayer(addLayer)
    #endif
    
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.lineWidth = 2
    borderLayer.lineDashPattern = [4, 5]
    borderLayer.strokeColor = UIColor.lightGray.cgColor
    layer.addSublayer(borderLayer)
    
    let buttton = UIButton()
    buttton.backgroundColor = .clear
    buttton.addTarget(self, action: #selector(add), for: .touchUpInside)
    addSubview(buttton)
    buttton.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let addPath: UIBezierPath = {
      let path = UIBezierPath()
      path.move(to: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.25))
      path.addLine(to: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.75))
      path.move(to: CGPoint(x: bounds.width * 0.5 - bounds.height * 0.25, y: bounds.height * 0.5))
      path.addLine(to: CGPoint(x: bounds.width * 0.5 + bounds.height * 0.25, y: bounds.height * 0.5))
      return path
    }()
    addLayer.path = addPath.cgPath
    
    let borderPath: UIBezierPath = {
      let path = UIBezierPath(rect: bounds.insetBy(dx: 12, dy: 8))
      path.setLineDash([2, 2], count: 2, phase: 0)
      return path
    }()
    borderLayer.path = borderPath.cgPath
  }
  
  @objc private func add() {
    delegate?.onAdd()
  }
}
