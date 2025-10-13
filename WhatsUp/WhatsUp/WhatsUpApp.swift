//
//  WhatsUpApp.swift
//  WhatsUp
//
//  Created by Robert Gruevski on 10/11/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct WhatsUpApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = AppState()
    @StateObject private var model = Model()
    
    var body: some Scene {
        WindowGroup {
            
            NavigationStack(path: $appState.routes) {
                
                ZStack {
                    if Auth.auth().currentUser != nil {
                        MainView()
                    } else {
                        LoginView()
                    }
                }.navigationDestination(for: Route.self) { route in
                    switch route {
                    case .main:
                        MainView()
                    case .login:
                        LoginView()
                    case .signUp:
                        SignUpView()
                    }
                }
            }
            .overlay(alignment: .top, content: {
                switch appState.loadingState {
                case .idle:
                    EmptyView()
                case .loading(let message):
                    LoadingView(message: message)
                }
            })
            .sheet(item: $appState.errorWrapper, content: { errorWrapper in
                ErrorView(errorWrapper: errorWrapper)
            })
            .environmentObject(model)
            .environmentObject(appState)
        }
    }
}
