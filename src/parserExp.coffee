Parser = (require 'jison').Parser
jison = require 'jison'

grammar = 
  comment: 'Binary string to json'

  lex:
    rules: [
      ["[a-zA-Z]+", "return 'e'"]
      ["$", "return 'EOF'"]
      ["\\s", "return 'SPACE'"]
    ]

  operators: [
    ["right", "T"]
  ]

  bnf:
    E: [
      ["T EOF", "return  $1"]
    ]

    T: [
      ["e SPACE T", "$$ = (function(a, b) { return {key: a, value: b}; })($1, $3)"]
      ["e", "$$ = $1;"]
    ]

parser = new Parser grammar
module.exports = parser

# ab cd ef gh
#e SPACE e SPACE e SPACE e EOF


# e (ab)
# e SPACE (ab )
# e SPACE e (ab cd)
# e SPACE e (ab cd)
# e SPACE e SPACE e SPACE T (ab cd ef gh)
# e SPACE e SPACE T (ab cd {key:ef, value:gh})
# e SPACE T (ab {key:cd, value:{key:ef, value:gh}})
# T {key:ab value:{key:cd, value:{key:ef, value:gh}}}

