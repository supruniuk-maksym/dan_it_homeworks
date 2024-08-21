#!/bin/bash

#Input sentence

echo "Type sentence: "
read  sentence

reverse_sentence=$(echo "$sentence" | tr ' ' '\n' | tac  | xargs )
echo "That is your reverse sentence: $reverse_sentence"
