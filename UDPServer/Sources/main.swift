import Foundation

do {
    let server: UDPServer = try UDPServerImpl(port: 8888)
    server.start()
    
    RunLoop.main.run()
} catch let error {
    print("Failed to initialize listener: \(error)")
    exit(EXIT_FAILURE)
}
