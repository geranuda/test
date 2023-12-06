//
//  ContentView.swift
//  test
//
//  Created by Gerardo Nunez on 06/12/23.
//
//
import SwiftUI
import WatchConnectivity

// SessionManager conforms to ObservableObject
class SessionManager: NSObject, WCSessionDelegate, ObservableObject {
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    // MARK: - Published Properties
    @Published var receivedMessage: String = "Hola Dany ya ponte a hacer tu tarea"
    
    @Published var currentHeartRate: Double = 0.0
    
    // MARK: - Properties
    var session: WCSession = WCSession.default
    
    // MARK: - Initialization
    override init() {
        super.init()
        session.delegate = self
        session.activate()
    }
    
    // MARK: - WCSessionDelegate Methods
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async { [weak self] in
            if let receivedMessage = message["message"] as? String {
                self?.receivedMessage = receivedMessage
                replyHandler(["response": "Message received"])
            } else {
                replyHandler(["response": "Message format not recognized"])
            }
        }
    }
    
    // Add other necessary delegate methods...
}

struct ContentView: View {
    // Use StateObject for SwiftUI 2.0 and later
    @StateObject private var sessionManager = SessionManager()

    var body: some View {
        Text(sessionManager.receivedMessage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
