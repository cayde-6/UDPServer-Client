import Foundation

guard let message = CommandLine.arguments.last else {
    exit(EXIT_FAILURE)
}

let client: UDPClient = UDPClientImpl(
    host: "127.0.0.1",
    port: 8888,
    initialMessage: message
)
client.start()

RunLoop.main.run()
