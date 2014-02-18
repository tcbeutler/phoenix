Parser = (require 'jison').Parser

grammar = 
  comment: "JSON Math Parser"
  
  lex:
    rules: [
      ["\\s+", "/* skip whitespace */"]
      ["[0-9]+(?:\\.[0-9]+)?\\b", "return 'NUMBER'"]
      ["\\*", "return '*'"]
      ["\\/", "return '/'"]
      ["-", "return '-'"]
      ["\\+", "return '+'"]
      ["\\^", "return '^'"]
      ["!", "return '!'"]
      ["%", "return '%'"]
      ["\\(", "return '('"]
      ["\\)", "return ')'"]
      ["PI\\b", "return 'PI'"]
      ["E\\b", "return 'E'"]
      ["$", "return 'EOF'"]
      [".", "/* eat unrecognized tokens*/"]
    ]

  operators: [
    ["left", "+", "-"]
    ["left", "*", "/"]
    ["left", "^"]
    ["right", "!"]
    ["right", "%"]
    ["left", "UMINUS"]
  ]

  bnf:
    expressions: [["e EOF", "return $1"]]

    e: [["e + e", "$$ = $1+$3"]
    ["e - e", "$$ = $1-$3"]
    ["e * e", "$$ = $1*$3"]
    ["e / e", "$$ = $1/$3"]
    ["e ^ e", "$$ = Math.pow($1, $3)"]
    ["e !", "$$ = (function(n) {if(n==0) return 1; return arguments.callee(n-1) * n})($1)"]
    ["e %", "$$ = $1/100"]
    ["- e", "$$ = -$2",
      prec: "UMINUS"
    ]
    ["( e )", "$$ = $2"]
    ["NUMBER", "$$ = Number(yytext)"]
    ["E", "$$ = Math.E"]
    ["PI", "$$ = Math.PI"]]

parser = new Parser grammar
module.exports = parser



