# Description:
#   IFTTT のポストをトリガーとして irkit を動かす
#
module.exports = (robot) ->
  hubotSlack = require 'hubot-slack'
  deviceName = 'home'
  messageName = 'aircon-加湿暖房'

  endpoint = ->
    herokuUrl = process.env.HEROKU_URL
    if herokuUrl
      herokuUrl += '/' unless /\/$/.test herokuUrl

    "#{herokuUrl || '/'}irkit/messages/#{encodeURIComponent(deviceName)}/#{encodeURIComponent(messageName)}"

  robot.listeners.push new hubotSlack.SlackBotListener robot, /もうすぐ :frog: よ/i, (msg) ->
    client = msg.http(endpoint())
    if process.env.EXPRESS_USER && process.env.EXPRESS_PASSWORD
      client.auth(process.env.EXPRESS_USER, process.env.EXPRESS_PASSWORD)
    client.put() (err, res, body) ->
      if err || res.statusCode != 200
        msg.send "エラー: #{err || res.statusCode}"
        return
      msg.send "irkitデバイス #{deviceName} で #{messageName} を実行しました"
