# Description:
#   Whois for people
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot whois <name> - returns person details if it exists
#
# Author:
#   fordie

module.exports = (robot) ->
  robot.respond /whois (.*)/i, (msg) ->
    gemname = escape(msg.match[1])
    msg.http("https://warm-lake-9867.herokuapp.com/?name=#{gemname}")
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)
          msg.send " image_url: #{json.image_url}\n
          role: #{json.role}\n
          team: #{json.team}\n
          location: #{json.location}\n
          people_finder_url: #{json.people_finder_url}\n"
        catch err
          msg.send "Who?! Never heard of them :("