# Description:
#   Return definitions of acronyms from the Big Book of Acronyms
#
# Commands:
#   hubot def[ine] <acronym> - Returns definitions for the given acronym

module.exports = (robot) ->

  define = (query, msg, method) ->
    msg.http("#{process.env.HUBOT_BBA_HOST}/define/#{query}").headers("Accept": "application/json").get() (err, res, body) ->
      return msg.send "BBA says: #{err}" if err
      if res.statusCode != 500
        acronym = JSON.parse body
        if acronym.error
          msg.send acronym.error
        else
          for def in acronym.definitions
            resp = []
            resp.push "#{acronym.acronym} = #{def.definition} - #{def.url}"
            msg[if method is true then 'reply' else 'send'] resp.join('\n')


  robot.respond /(def|define) (.*)/i, (msg)->
    query = msg.match[2]

    define query, msg


  robot.hear /([A-Z]{2,})(?=\smeans?)/, (msg) ->
    query = msg.match[0]

    define query, msg, true


  robot.hear /(W|w)hat(\'s)? (is )?([A-Z]{2,})/, (msg) ->
    query = msg.match[4]

    define query, msg, true
