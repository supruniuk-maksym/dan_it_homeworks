#!/bin/env python3

import random

R_NUM = random.randint(1, 100)

print("You have given 5 attemps to guess a number from 1 to 100. \nGood luck!")

def GUESS_N():
        if I_NUM > R_NUM: 
            print(f"{I_NUM} more than the random number")
        elif I_NUM < R_NUM:
            print(f"{I_NUM} less than the random number")
        else:
            print(f"Congrat you guess the number")
            return True
        return False

        
count = 1
while count <= 5:
    try:
        I_NUM = int(input("Print your number:"))
        print(I_NUM)
        if I_NUM < 1 or I_NUM > 100:
            print("The number should be from 1 to 100. Try again")
            continue
    except ValueError:
            print("Your input isn't a number. Try again")
            continue

    if GUESS_N():
        break #fuction was stoped because it is true
    
    count += 1
    
if count > 5:
        print(f"You used 5 attempts given to you. \nThe correct number was {R_NUM}")


