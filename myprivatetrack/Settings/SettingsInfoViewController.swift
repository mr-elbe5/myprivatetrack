/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

class SettingsInfoViewController: InfoViewController {
    
    let settingsHeader = InfoHeader(text: "settings".localize())
    let backgroundText = InfoText(text: "settingsBackgroundInfo".localize())
    let mapSizeText = InfoText(text: "settingsMapSizeInfo".localize())
    let entriesHeader = InfoHeader(text: "entries".localize())
    let resetText = InfoText(text: "settingsResetInfo".localize())
    let fullBackupText = InfoText(text: "settingsFullBackupInfo".localize())
    let partialBackupText = InfoText(text: "settingsPartialBackupInfo".localize())
    let restoreText = InfoText(text: "settingsRestoreInfo".localize())
    let filesHeader = InfoHeader(text: "files".localize())
    let filesText = InfoText(text: "settingsFilesInfo".localize())
    
    override func loadView() {
        super.loadView()
        stackView.addArrangedSubview(settingsHeader)
        stackView.addArrangedSubview(backgroundText)
        stackView.addArrangedSubview(mapSizeText)
        stackView.addArrangedSubview(entriesHeader)
        stackView.addArrangedSubview(resetText)
        stackView.addArrangedSubview(fullBackupText)
        stackView.addArrangedSubview(partialBackupText)
        stackView.addArrangedSubview(restoreText)
        stackView.addArrangedSubview(filesHeader)
        stackView.addArrangedSubview(filesText)
    }
    
    
}
