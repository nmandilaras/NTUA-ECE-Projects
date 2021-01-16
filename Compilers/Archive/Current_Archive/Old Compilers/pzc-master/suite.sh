#!/bin/bash

for component in "examples" "lexer" "parser" "semantics" ;
do
    echo ""
    echo "==========  Now testing $component ============"

    for testcase in tests/$component/*.pzc;
    do echo "========== $testcase ============"
        ./pazcal $testcase
    done
done



