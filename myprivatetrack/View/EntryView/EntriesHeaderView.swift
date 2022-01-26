//
//  EntriesHeaderView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 10.08.21.
//  Copyright © 2021 Michael Rönnau. All rights reserved.
//

import UIKit


protocol EntriesHeaderDelegate{
    func toggleEditMode()
    func showInfo()
}

class EntriesHeaderView: UIView{

    let editButton = IconButton(icon: "pencil.circle")
    let infoButton = IconButton(icon: "info.circle")
    
    var delegate : EntriesHeaderDelegate? = nil
    
    func setupView() {
        let stackView = UIStackView()
        backgroundColor = Statics.tabColor
        addSubview(stackView)
        stackView.setupHorizontal(spacing: defaultInset)
        stackView.alignment = .trailing
        stackView.setAnchors(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchDown)
        stackView.addArrangedSubview(editButton)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        stackView.addArrangedSubview(infoButton)
    }

    @objc func toggleEditMode(){
        delegate?.toggleEditMode()
    }
    
    @objc func showInfo(){
        delegate?.showInfo()
    }
    
}
    
