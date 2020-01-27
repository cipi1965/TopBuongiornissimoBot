import Vapor
import TelegramBotSDKVaporProvider
import VaporCron

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    let telegramClient = try app.make(TelegramBotClient.self)
    telegramClient.bot.setWebhookSync(url: "https://bots.grungi.it/topbuongiornissimobot/webhook")
    
    try VaporCron.schedule(SendBuongiorno.self, on: app)
    try VaporCron.schedule(SendReport.self, on: app)
}
