import Vapor
import TelegramBotSDKVaporProvider

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.post("topbuongiornissimobot","webhook") { (request) -> HTTPStatus in
        let telegramClient = try request.make(TelegramBotClient.self)
        try telegramClient.handleRequest(request)
        return .ok
    }
}
