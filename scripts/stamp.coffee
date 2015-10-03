# Description:
#   スタンプURLを出す
#
module.exports = (robot) ->
  base = 'https://raw.githubusercontent.com/shiratsuchi/stamp/master/'
  stamps = [
    { key: /デプロイします/i,          image: 'deploy.png' },
    { key: /飲みに(い|行)こう/i,       image: 'drink.png' },
    { key: /ごはん(行|い)きましょう/i, image: 'eat.png' },
    { key: /お(つか|疲)れ(さま|様)/i,  image: 'goodjob.png' },
    { key: /帰(る|り)/i,               image: 'home.png' },
    { key: /いいね/i,                  image: 'like.png' },
    { key: /ごめん/i,                  image: 'sorry.png' },
    { key: /ありがと/i,                image: 'thanks.png' },
  ]

  for stamp in stamps
    do (stamp) ->
      robot.hear stamp.key, (res) ->
        res.send(base + stamp.image)
