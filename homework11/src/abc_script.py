#!/usr/bin/env python3

class Alphabet:
    def __init__(self, lang, letters):
        self.lang = lang
        self.letters = letters

    def printAlphabet(self):
        print(self.letters)

    def countLetters(self):
        return len(self.letters)

class EngAlphabet(Alphabet):
    __num_letters = 26
    alphabet_string = "abcdefghijklmnopqrstuvwxyz"
    def __init__(self):
        alphabet_list = list(self.alphabet_string)
        super().__init__("En", alphabet_list)
  
    def is_en_letter(self,letter):  #Determine whether a letter belongs to the English alphabet
        if letter.lower() in  self.letters:
            print(f"English alphabet has this letter: {letter}")
        else:
             print(f"English alphabet dosn't have this letter: {letter}")

    def letters_num(self):  #Count the number of letters
        return self.__num_letters
    
    @staticmethod
    def example():  #Get an example text in English.
        return EngAlphabet.alphabet_string
    @staticmethod

    def example_text():
        return "DanIT is the best course ever"

    #__main__
if __name__ == "__main__":
        eng_alphabet_obj = EngAlphabet()

        print("1.Create an object of the EngAlphabet class.Test result is:")
        print(EngAlphabet.example()) 
        
        print("2.Output the number of letters in the alphabet.Test result is:")
        print(eng_alphabet_obj.letters_num()) 
        
        print("3.Check if the letter 'F' belongs to the English alphabet.Test result is:")
        eng_alphabet_obj.is_en_letter('F')
        
        print("4.Check if the letter 'Щ' belongs to the English alphabet.Test result is:")
        eng_alphabet_obj.is_en_letter('Щ')
        
        print("5.Output an example text in English.Test result is:")
        print(EngAlphabet.example_text()) 

#=======
#Task: ABC
#Description of the class structure
#Alphabet Class, characterized by:
#Language
#List of letters
#For the Alphabet, you can:
#Print all the letters of the alphabet
#Count the number of letters
#==
#English Alphabet Properties:
#Language
#List of letters
#Number of letters

#For the English Alphabet, you can:
#Count the number of letters
#Determine whether a letter belongs to the English alphabet
#Get an example text in English.
#===
#Task
#Alphabet Class
#+Create the Alphabet class
#+Create the __init__() method, inside of which two attributes will be defined: 1) lang - language and 2) letters - list of letters. The initial values of the properties are taken from the method's input parameters.
#+Create the print() method, which will print the alphabet letters to the console.
#+Create the letters_num() method, which will return the number of letters in the alphabet.
#EngAlphabet Class
#+Create the EngAlphabet class by inheriting from the Alphabet class.
#+Create the __init__() method, inside of which the parent method __init__() will be called. The language designation (e.g., En) and a string consisting of all the letters of the alphabet will be passed to it as parameters.
#+Add a private static attribute _letters_num, which will store the number of letters in the alphabet.
#+Create the is_en_letter() method, which will take a letter as a parameter and determine whether this letter belongs to the English alphabet.
#+Redefine the letters_num() method - let it return the value of the _letters_num attribute in the current class.
#+Create a static method example(), which will return an example text in English.
#Tests (main)
#Create an object of the EngAlphabet class.
#Print the alphabet letters for this object.
#Output the number of letters in the alphabet.
#Check if the letter 'F' belongs to the English alphabet.
#Check if the letter 'Щ' belongs to the English alphabet.
#Output an example text in English.
