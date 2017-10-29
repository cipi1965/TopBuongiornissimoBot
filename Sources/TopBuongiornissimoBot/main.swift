//
//  main.swift
//  TopBuongiornissimoBotPackageDescription
//
//  Created by Matteo Piccina on 29/10/17.
//

import Foundation
import TelegramBotSDK
import Meow

let bot = TelegramBot(token: "341980331:AAGkxNuLxkiF9UGg3J29ILPqBVQHD7yEf_M")

try! Meow.init("mongodb://localhost/topbuongiornissimobot")

let user = User(telegramId: 34223706, name: "Matteo", surname: "Piccina", username: "cipi1965")
try user.save()

let group = Group(name: "Test", chatId: 34223706)
try group.save()

let counter = GroupCounter(group: Reference(to: group), user: Reference(to: user), count: 0, last: Date())
try counter.save()

let foundCounter = try GroupCounter.findOne([
    "group": group._id,
    "user": user._id
] as Query)

let linkedUser = try foundCounter?.user?.resolve()
print(linkedUser?.name)
