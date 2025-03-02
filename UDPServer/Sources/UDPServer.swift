//
//  UDPServer.swift
//  UDPServer
//
//  Created by Maxim Egorov on 25/2/25.
//

import Network

protocol UDPServer {
    func start()
    func stop()
}

final class UDPServerImpl: Sendable {
    private let connectionListener: NWListener
    
    /// Initializes the UDP Server with a given port
    /// - Parameter port: The UDP port to listen on
    init(port: UInt16) throws {
        connectionListener = try NWListener(
            using: .udp,
            on: NWEndpoint.Port(integerLiteral: port)
        )
        // Handle new incoming connections
        connectionListener.newConnectionHandler = { [weak self] connection in
            // Start connection processing in global queue
            connection.start(queue: .global())
            self?.receive(on: connection)
        }
        // Handle listener state changes
        connectionListener.stateUpdateHandler = { state in
            print("Server state: \(state)")
        }
    }
}

extension UDPServerImpl: UDPServer {
    /// Starts the UDP server
    func start() {
        connectionListener.start(queue: .global())
        print("Server started")
    }
    
    /// Stops the UDP server
    func stop() {
        connectionListener.cancel()
        print("Server stopped")
    }
}

// MARK: - Private
private extension UDPServerImpl {
    /// Handles incoming messages from clients
    /// - Parameter connection: The connection on which to receive data
    func receive(on connection: NWConnection) {
        connection.receiveMessage { data, _, _, error in
            if let error = error {
                print("New message error: \(error)")
            }
            
            if
                let data = data, let message = String(data: data, encoding: .utf8) {
                print("New message: \(message)")
            }
        }
    }
}
