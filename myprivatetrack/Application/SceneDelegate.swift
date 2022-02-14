/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit
import AVFoundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        FileController.initialize()
        Settings.load()
        GlobalData.load()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        mainWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
        mainWindow?.windowScene = windowScene
        mainWindow?.rootViewController = MainTabController()
        mainWindow?.makeKeyAndVisible()
        LocationService.shared.requestWhenInUseAuthorization()
        AVCaptureDevice.askCameraAuthorization(){ result in
            print("camera authorization is \(result)")
        }
        AVCaptureDevice.askAudioAuthorization(){ result in
            print("audio authorization is \(result)")
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        LocationService.shared.start()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        LocationService.shared.stop()
        Settings.shared.save()
        GlobalData.shared.save()
    }


}

var mainWindow : UIWindow? = nil

var windowOrientation: UIInterfaceOrientation {
    return mainWindow?.windowScene?.interfaceOrientation ?? .unknown
}

