//
//  UDPClient.swift
//  UDPClient
//
//  Created by Maxim Egorov on 28/2/25.
//

import Network

protocol UDPClient {
    func start()
    func stop()
    func send(message: String)
}

final class UDPClientImpl: Sendable {
    private let connection: NWConnection
    
    /// Initializes the UDP Client
    /// - Parameters:
    ///   - host: The server's hostname or IP address
    ///   - port: The server's UDP port
    ///   - initialMessage: The first message to send upon connection
    init(
        host: String,
        port: UInt16,
        initialMessage: String
    ) {
        connection = NWConnection(
            host: NWEndpoint.Host(host),
            port: NWEndpoint.Port(integerLiteral: port),
            using: .udp
        )
        connection.stateUpdateHandler = { [weak self] state in
            print("Client: state = \(state)")
            if state == .ready {
                self?.send(message: initialMessage)
            }
        }
    }
}

extension UDPClientImpl: UDPClient {
    /// Starts the UDP client
    func start() {
        connection.start(queue: .global())
        print("Client: started")
    }
    
    /// Stops the UDP client
    func stop() {
        connection.cancel()
        print("Client: stopped")
    }
    
    /// Sends a message to the UDP server
    /// - Parameter message: The message to send
    func send(message: String) {
        guard let data = message.data(using: .utf8) else {
            print("Client: encoding message error")
            return
        }

        connection.send(content: data, completion: .contentProcessed { error in
            if let error = error {
                print("Client: failed to send message: \(error)")
            } else {
                print("Client: message sent")
            }
        })
    }
}
