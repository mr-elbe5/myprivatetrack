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
    func createTextEntry()
    func createPhotoEntry()
    func createAudioEntry()
    func createVideoEntry()
    func createMapEntry()
}

class EntriesHeaderView: UIView{

    var addTextButton = IconButton(icon: "text.alignleft")
    var addPhotoButton = IconButton(icon: "camera")
    var addAudioButton = IconButton(icon: "mic")
    let addVideoButton = IconButton(icon: "video")
    var addMapButton = IconButton(icon: "map")
    let editButton = IconButton(icon: "pencil.circle")
    let infoButton = IconButton(icon: "info.circle")
    
    var delegate : EntriesHeaderDelegate? = nil
    
    func setupView() {
        let leftStackView = UIStackView()
        addSubview(leftStackView)
        leftStackView.setupHorizontal(spacing: defaultInset)
        leftStackView.alignment = .leading
        leftStackView.setAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, insets: flatInsets)
        addTextButton.addTarget(self, action: #selector(addTextEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addTextButton)
        addPhotoButton.addTarget(self, action: #selector(addPhotoEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addPhotoButton)
        addAudioButton.addTarget(self, action: #selector(addAudioEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addAudioButton)
        addVideoButton.addTarget(self, action: #selector(addVideoEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addVideoButton)
        addMapButton.addTarget(self, action: #selector(addMapEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addMapButton)
        let rightStackView = UIStackView()
        addSubview(rightStackView)
        rightStackView.setupHorizontal(spacing: defaultInset)
        rightStackView.alignment = .trailing
        rightStackView.setAnchors(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchDown)
        rightStackView.addArrangedSubview(editButton)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
    }
    
    @objc func addTextEntry(){
        delegate?.createTextEntry()
    }
    
    @objc func addPhotoEntry(){
        delegate?.createPhotoEntry()
    }
    
    @objc func addAudioEntry(){
        delegate?.createAudioEntry()
    }
    
    @objc func addVideoEntry(){
        delegate?.createVideoEntry()
    }
    
    @objc func addMapEntry(){
        delegate?.createMapEntry()
    }

    @objc func toggleEditMode(){
        delegate?.toggleEditMode()
    }
    
    @objc func showInfo(){
        delegate?.showInfo()
    }
    
}
    
