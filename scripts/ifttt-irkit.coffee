# Description:
#   IFTTT のポストをトリガーとして irkit を動かす
#
hubotSlack = require 'hubot-slack'
moment = require "moment"

module.exports = (robot) ->
  deviceName = 'home'
  messageName = 'aircon-加湿暖房'

  lastSended = ->
    key = "last-sended-#{encodeURIComponent(deviceName)}-#{encodeURIComponent(messageName)}"
    last = robot.brain.get(key)
    if last && moment(last) > moment().subtract(4, 'hours').valueOf()
      moment(last).format("YYYY-MM-DD HH:mm:ss")
    else
      robot.brain.set key, moment().valueOf()
      return false

  endpoint = ->
    herokuUrl = process.env.HEROKU_URL
    if herokuUrl
      herokuUrl += '/' unless /\/$/.test herokuUrl

    "#{herokuUrl || '/'}irkit/messages/#{encodeURIComponent(deviceName)}/#{encodeURIComponent(messageName)}"

  robot.listeners.push new hubotSlack.SlackBotListener robot, /もうすぐ :frog: よ/i, (msg) ->
    if (last = lastSended())
      msg.send "#{last} に実行したので、今はしないよ"
      return

    client = msg.http(endpoint())
    if process.env.EXPRESS_USER && process.env.EXPRESS_PASSWORD
      client.auth(process.env.EXPRESS_USER, process.env.EXPRESS_PASSWORD)
    client.put() (err, res, body) ->
      if err || res.statusCode != 200
        msg.send "エラー: #{err || res.statusCode}"
        return
      msg.send "irkitデバイス #{deviceName} で #{messageName} を実行しました"
