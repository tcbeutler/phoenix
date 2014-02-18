Parser = (require 'jison').Parser
jison = require 'jison'

grammar = 
  comment: 'API Blueprint Grammar'

  lex:
    rules: [
      ["^", "return 'BOF'"]
    ]

  bnf:
    E: [
      ["BOF", "return {\"_version\": \"1.0\"}"]
    ]

parser = new Parser grammar
module.exports = parser
