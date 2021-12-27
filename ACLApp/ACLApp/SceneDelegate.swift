//
//  SceneDelegate.swift
//  ACLApp
//
// Purpose (of windowScene): checks with firebase to see if logged in and changes the view controller if you are instead of starting at sign up screen starts at tab controller

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return } // looking at the window
        if (Auth.auth().currentUser != nil) { //checks if the user is logged in, continues if the user is logged in
            let window = UIWindow(windowScene: windowScene) //gets the current scene window
            let storyboard = UIStoryboard(name: "Main", bundle: nil) //connecting to the storyboard
            let initialVC = storyboard.instantiateViewController(withIdentifier: "TabController") //gets the tab view controller and puts it first, changes view from sign up to tab view (so that the user can stay signed in)
            window.rootViewController = initialVC //changes view controller, initaties tab view as the first view controller
            self.window = window //take this window
            self.window?.makeKeyAndVisible() //if logged in do not need to see log in screen, makes tab view window visible
        }
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

