# Description:
#   IFTTT のポストをトリガーとして irkit を動かす
#
module.exports = (robot) ->
  hubotSlack = require 'hubot-slack'
  deviceName = 'home'
  messageName = 'aircon-加湿暖房'

  robot.listeners.push new hubotSlack.SlackBotListener robot, /もうすぐ :frog: よ/i, (msg) ->
    herokuUrl = process.env.HEROKU_URL
    if herokuUrl
      herokuUrl += '/' unless /\/$/.test herokuUrl

    msg.http("#{herokuUrl || '/'}irkit/messages/#{encodeURIComponent(deviceName)}/#{encodeURIComponent(messageName)}").put() (err, res, body) ->
      if err || res.statusCode != 200
        msg.send "エラー: #{err || res.statusCode}"
        return
      msg.send "デバイス #{deviceName} で #{messageName} を実行しました"
