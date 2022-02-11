/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit


protocol TimelineHeaderDelegate{
    func toggleEditMode()
    func showInfo()
    func createTextEntry()
    func createPhotoEntry()
    func createImageEntry()
    func createAudioEntry()
    func createVideoEntry()
}

class TimelineHeaderView: UIView{

    var addTextButton = IconButton(icon: "text.alignleft")
    var addPhotoButton = IconButton(icon: "camera")
    var addImageButton = IconButton(icon: "photo")
    var addAudioButton = IconButton(icon: "mic")
    let addVideoButton = IconButton(icon: "video")
    let editButton = IconButton(icon: "pencil.circle")
    let infoButton = IconButton(icon: "info.circle")
    
    var delegate : TimelineHeaderDelegate? = nil
    
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
        addImageButton.addTarget(self, action: #selector(addImageEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addImageButton)
        addAudioButton.addTarget(self, action: #selector(addAudioEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addAudioButton)
        addVideoButton.addTarget(self, action: #selector(addVideoEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addVideoButton)
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
    
    @objc func addImageEntry(){
        delegate?.createImageEntry()
    }
    
    @objc func addAudioEntry(){
        delegate?.createAudioEntry()
    }
    
    @objc func addVideoEntry(){
        delegate?.createVideoEntry()
    }

    @objc func toggleEditMode(){
        delegate?.toggleEditMode()
    }
    
    @objc func showInfo(){
        delegate?.showInfo()
    }
    
}
    
