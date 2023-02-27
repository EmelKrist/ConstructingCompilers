/*
BSD License

Copyright (c) 2020, Tom Everett
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. Neither the name of Tom Everett nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/*
* https://people.inf.ethz.ch/wirth/Oberon/Oberon07.Report.pdf
*/

grammar oberon7;

ident
   : IDENT
   ;

qualident
   : (ident '.')? ident
   ;

identdef
   : ident '*'?
   ;

integer
   : (DIGIT+)
   | (DIGIT HEXDIGIT* (?i)'H')
   ;

real
   : DIGIT+ '.' DIGIT* scaleFactor?
   ;

scaleFactor
   : (?i)'E' ('+' | '-')? DIGIT+
   ;

number
   : integer
   | real
   ;

constDeclaration
   : identdef '=' constExpression
   ;

constExpression
   : expression
   ;

typeDeclaration
   : identdef '=' type_
   ;

type_
   : qualident
   | arrayType
   | recordType
   | pointerType
   | procedureType
   ;

arrayType
   : ARRAY length (',' length)* OF type_
   ;

length
   : constExpression
   ;

recordType
   : RECORD ('(' baseType ')')? fieldListSequence? END
   ;

baseType
   : qualident
   ;

fieldListSequence
   : fieldList (';' fieldList)*
   ;

fieldList
   : identList ':' type_
   ;

identList
   : identdef (',' identdef)*
   ;

pointerType
   : POINTER TO type_
   ;

procedureType
   : PROCEDURE formalParameters?
   ;

variableDeclaration
   : identList ':' type_
   ;

expression
   : simpleExpression (relation simpleExpression)?
   ;

relation
   : '='
   | '#'
   | '<'
   | '<='
   | '>'
   | '>='
   | IN
   | IS
   ;

simpleExpression
   : ('+' | '-')? term (addOperator term)*
   ;

addOperator
   : '+'
   | '-'
   | OR
   ;

term
   : factor (mulOperator factor)*
   ;

mulOperator
   : '*'
   | '/'
   | DIV
   | MOD
   | '&'
   ;

factor
   : number
   | STRING
   | NIL
   | TRUE
   | FALSE
   | set_
   | designator (actualParameters)?
   | '(' expression ')'
   | '~' factor
   ;

designator
   : qualident selector*
   ;

selector
   : '.' ident
   | '[' expList ']'
   | '^'
   | '(' qualident ')'
   ;

set_
   : '{' (element (',' element)*)? '}'
   ;

element
   : expression ('..' expression)?
   ;

expList
   : expression (',' expression)*
   ;

actualParameters
   : '(' expList? ')'
   ;

statement
   : (assignment | procedureCall | ifStatement | caseStatement | whileStatement | repeatStatement | forStatement)?
   ;

assignment
   : designator ':=' expression
   ;

procedureCall
   : designator actualParameters?
   ;

statementSequence
   : statement (';' statement)*
   ;

ifStatement
   : IF expression THEN statementSequence (ELSIF expression THEN statementSequence)* (ELSE statementSequence)? END
   ;

caseStatement
   : CASE expression OF case_ ('|' case_)* END
   ;

case_
   : (caseLabelList ':' statementSequence)?
   ;

caseLabelList
   : labelRange (',' labelRange)*
   ;

labelRange
   : label ('..' label)?
   ;

label
   : integer
   | STRING
   | qualident
   ;

whileStatement
   : WHILE expression DO statementSequence (ELSIF expression DO statementSequence)* END
   ;

repeatStatement
   : REPEAT statementSequence UNTIL expression
   ;

forStatement
   : FOR ident ':=' expression TO expression (BY constExpression)? DO statementSequence END
   ;

procedureDeclaration
   : procedureHeading ';' procedureBody ident
   ;

procedureHeading
   : PROCEDURE identdef formalParameters?
   ;

procedureBody
   : declarationSequence (BEGIN statementSequence)? (RETURN expression)? END
   ;

declarationSequence
   : (CONST (constDeclaration ';')*)? 
     (TYPE (typeDeclaration ';')*)? 
     (VAR (variableDeclaration ';')*)? 
     (procedureDeclaration ';')*
   ;

formalParameters
   : '(' (fPSection (';' fPSection)*)? ')' (':' qualident)?
   ;

fPSection
   : VAR? ident (',' ident)* ':' formalType
   ;

formalType
   : (ARRAY OF)* qualident
   ;

module
   : MODULE ident ';' importList? declarationSequence (BEGIN statementSequence)? END ident '.' EOF
   ;

importList
   : IMPORT import_ (',' import_)* ';'
   ;

import_
   : ident (':=' ident)?
   ;

ARRAY
   : (?i)'ARRAY'
   ;

OF
   : (?i)'OF'
   ;

END
   : (?i)'END'
   ;

POINTER
   : (?i)'POINTER'
   ;

TO
   : (?i)'TO'
   ;

RECORD
   : (?i)'RECORD'
   ;

PROCEDURE
   : (?i)'PROCEDURE'
   ;

IN
   : (?i)'IN'
   ;

IS
   : (?i)'IS'
   ;

OR
   : (?i)'OR'
   ;

DIV
   : (?i)'DIV'
   ;

MOD
   : (?i)'MOD'
   ;

NIL
   : (?i)'NIL'
   ;

TRUE
   : (?i)'TRUE'
   ;

FALSE
   : (?i)'FALSE'
   ;

IF
   : (?i)'IF'
   ;

THEN
   : (?i)'THEN'
   ;

ELSIF
   : (?i)'ELSIF'
   ;

ELSE
   : (?i)'ELSE'
   ;

CASE
   : (?i)'CASE'
   ;

WHILE
   : (?i)'WHILE'
   ;

DO
   : (?i)'DO'
   ;

REPEAT
   : (?i)'REPEAT'
   ;

UNTIL
   : (?i)'UNTIL'
   ;

FOR
   : (?i)'FOR'
   ;

BY
   : (?i)'BY'
   ;

BEGIN
   : (?i)'BEGIN'
   ;

RETURN
   : (?i)'RETURN'
   ;

CONST
   : (?i)'CONST'
   ;

TYPE
   : (?i)'TYPE'
   ;

VAR
   : (?i)'VAR'
   ;

MODULE
   : (?i)'MODULE'
   ;

IMPORT
   : (?i)'IMPORT'
   ;

STRING
   : ('"' .*? '"')
   | (DIGIT HEXDIGIT* (?i)'X')
   ;

HEXDIGIT
   : DIGIT
   | 'A'
   | 'B'
   | 'C'
   | 'D'
   | 'E'
   | 'F'
   ;

IDENT
   : LETTER (LETTER | DIGIT)*
   ;

LETTER
   : [a-zA-Z]
   ;

DIGIT
   : [0-9]
   ;

COMMENT
   : '(*' .*? '*)' -> skip
   ;

WS
   : [ \t\r\n] -> skip
   ;
