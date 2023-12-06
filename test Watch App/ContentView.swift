//
//  ContentView.swift
//  test Watch App
//
//  Created by Gerardo Nunez on 06/12/23.
//
import SwiftUI
import WatchConnectivity


struct ContentView: View {
    @StateObject private var sessionManager = WatchSessionManager()
    
    var body: some View {
        VStack {
            Button("Send Message") {
                print("Send message button clicked")
                sessionManager.sendMessage(["message": "Test Message from Watch"])
            }

            Text(sessionManager.receivedMessage) // Display received message, if needed
        }
    }
}


class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    // MARK: - Properties
    @Published var receivedMessage: String = ""
    var session: WCSession
    
    // MARK: - Initialization
    override init() {
        self.session = WCSession.default
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    // MARK: - Public Methods
    func sendMessage(_ message: [String: Any]) {
        guard self.session.isReachable else {
            print("WCSession is not reachable.")
            return
        }
        self.session.sendMessage(message, replyHandler: { reply in
            // Handle reply here if needed
            DispatchQueue.main.async {
                print("Message sent successfully with reply: \(reply)")
            }
        }, errorHandler: { error in
            // Handle sending error here
            DispatchQueue.main.async {
                print("Error sending message: \(error.localizedDescription)")
            }
        })
    }

    // MARK: - WCSessionDelegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation if needed
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        // Handle received message from iOS app
        DispatchQueue.main.async {
            if let receivedMessage = message["message"] as? String {
                self.receivedMessage = receivedMessage
            }
        }
    }

    // Add other delegate methods if necessary...
}
