//
//  SceneDelegate.swift
//  Assignment_7
//
//  Created by Luz on 5/6/24.
//

import UIKit
import SnapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowscene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowscene)
        
        // TabBarController 생성
        let tabBarController = UITabBarController()
        
        // 각 탭에 대한 ViewController 생성
        let firstViewController = ViewController()
        let secondViewController = WishViewController()
        
        // ViewController를 TabBarController에 추가
        tabBarController.viewControllers = [firstViewController, secondViewController]
        
        // ViewController에 타이틀 지정
        firstViewController.title = "Search"
        secondViewController.title = "Wish"
        
        if let item = tabBarController.tabBar.items {
            item[0].selectedImage = UIImage(systemName: "doc.text.magnifyingglass")
            item[0].image = UIImage(systemName: "doc.text.magnifyingglass")
            
            item[1].image = UIImage(systemName: "heart")
            item[1].selectedImage = UIImage(systemName: "heart.fill")
        }
        
        tabBarController.tabBar.backgroundColor = .lightGray
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .white
        tabBarController.tabBar.itemPositioning = .centered
        tabBarController.tabBar.layer.cornerRadius = 35
        // tabBarController.tabBar.itemSpacing = 50 // 이거 왜 안되지..
        tabBarController.selectedIndex = 0
        
        // Window에 TabBarController를 설정
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

