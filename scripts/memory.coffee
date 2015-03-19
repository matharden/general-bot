# Description
#   Remembers a key and fact
#
# Commands:
#   hubot remember <SUBJECT> [can|do|does] <FACT>. - Remembers a fact. eg "Vera can create email accounts"
#   hubot who [can|do|does] <QUESTION>. - Uses known facts to return an answer. eg "who can create email accounts" would return "Vera"
#   hubot list everything. - Prints out all known facts
#   hubot forget everything. - Delete all knows facts
#
# Dependencies:
#   "underscore": "*"

_ = require('underscore')

module.exports = (robot) ->
  memoriesByRecollection = () -> robot.brain.data.memoriesByRecollection ?= {}
  memories = () -> robot.brain.data.remember ?= {}


  #
  # Will iterate over the memories collection 
  #
  #
  # @param [String] question - the question that the user asked
  # @returns [Array] and array of answers
  #
  findAnswers = (question) ->
    questionWords = question.toString().toLowerCase().split(' ')

    matchingFacts = Object.keys(memories()).map (fact) -> findAnswer questionWords, fact

    _.compact _.flatten matchingFacts


  findAnswer = (questionWords, fact) ->
    factWords = fact.toString().toLowerCase().split(' ')

    commonWords = _.intersection(questionWords.slice(), factWords)

    # are the words in the question contained in our answer?
    if commonWords.length == questionWords.length
      memories()[fact]
    else
      null

    


  robot.respond /remember (.*) (can|do|does) (.*)/i, (msg) ->

    [subject, predicate, fact] = [msg.match[1], msg.match[2], msg.match[3]]

    if memories()[fact]
      memories()[fact].push subject
    else
      memories()[fact] = [subject]

    msg.reply "OK I'll remember #{subject} #{predicate} #{fact}" 



  robot.respond /who (can|do|does) (.*)/i, (msg) ->

    predicate = msg.match[1]
    question = msg.match[2].replace(/\?/, '')

    answer = findAnswers question

    if answer.length
      msg.reply "#{answer.join(", ")} #{predicate} #{question}"



  robot.respond /list memory/i, (msg) ->
    
    _.each(Object.keys(memories()), (key) ->
      msg.reply "#{key} : #{memories()[key]}"
    )



  robot.respond /forget everything/i, (msg) ->
    _.each(Object.keys(memories()), (key) ->
      delete memories()[key]
    )
    msg.reply "All Facts forgotten"

  
