# Description:
#   Whois for people
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot whois <gname> - returns gem details if it exists
#
# Author:
#   fordie

module.exports = (robot) ->
  robot.respond /whois (.*)/i, (msg) ->
    person = (msg.match[1])
    person = person.replace ' ', '-'
    msg.reply("https://peoplefinder.service.gov.uk/people/#{person}")
