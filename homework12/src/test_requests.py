import requests

# URL of your API
BASE_URL = 'http://127.0.0.1:5000'  # Replace with your URL if different

# PART 1: Test retrieving all students (GET)
def test_get_all_students():
    response = requests.get(f'{BASE_URL}/students')
    
    if response.status_code == 200:
        students = response.json()  # Convert the response to JSON
        print("List of all students:")
        for student in students:
            print(student)
    else:
        print(f"Error: Unable to retrieve the list of students. Status code: {response.status_code}")

# Test retrieving student by ID (GET)
def test_get_student_by_id(student_id):
    response = requests.get(f'{BASE_URL}/students', params={'id': student_id})
    
    if response.status_code == 200:
        student = response.json()
        print(f"Information about the student with ID {student_id}:")
        print(student)
    elif response.status_code == 404:
        print(f"Student with ID {student_id} not found.")
    else:
        print(f"Error: Unable to retrieve the student with ID {student_id}. Status code: {response.status_code}")

# Test retrieving students by last name (GET)
def test_get_students_by_last_name(last_name):
    response = requests.get(f'{BASE_URL}/students', params={'last_name': last_name})
    
    if response.status_code == 200:
        students = response.json()
        print(f"Information about students with the last name {last_name}:")
        for student in students:
            print(student)
    elif response.status_code == 404:
        print(f"No students found with the last name {last_name}.")
    else:
        print(f"Error: Unable to retrieve students with the last name {last_name}. Status code: {response.status_code}")

# PART 2: Test creating students (POST)
def test_create_students():
    students_data = [
        {"first_name": "Jake", "last_name": "Peralta", "age": 32},
        {"first_name": "Amy", "last_name": "Santiago", "age": 30},
        {"first_name": "Terry", "last_name": "Jeffords", "age": 40}
    ]
    
    for student in students_data:
        response = requests.post(f'{BASE_URL}/students', json=student)
        if response.status_code == 201:
            try:
                print(f"Successfully created student: {response.json()}")
            except requests.exceptions.JSONDecodeError:
                print(f"Student created, but received an invalid or empty JSON response. Status code: {response.status_code}")
        else:
            print(f"Error: Unable to create student. Status code: {response.status_code}, Message: {response.text}")

# Update the age of the second student (PATCH)
def update_age(student_id, new_age):
    response = requests.patch(f'{BASE_URL}/students/{student_id}', json={'age': new_age})

    if response.status_code == 200:
        student = response.json()
        print(f"Successfully updated student ID {student_id}: {student}")
    elif response.status_code == 404:
        print(f"Student with ID {student_id} not found.")
    else:
        print(f"Error: Unable to update student. Status code: {response.status_code}")

#Update the fist name, last name and the age of the third student (PUT).
def update_all_student_data(student_id, new_age, new_first_name, new_last_name):
     response = requests.put(f'{BASE_URL}/students/{student_id}', json={'age': new_age, 'first_name': new_first_name, 'last_name': new_last_name})

     if response.status_code == 200:
        student = response.json()
        print(f"Successfully updated student ID {student_id}: {student}")
     elif response.status_code == 404:
        print(f"Student with ID {student_id} not found.")
     else:
        print(f"Error: Unable to update student. Status code: {response.status_code}")

#Delete the first user (DELETE).
def delete_student(student_id):
    response = requests.delete(f'{BASE_URL}/students/{student_id}')

    if response.status_code == 200:
        print(f"Successfully deleted student with ID {student_id}")
    elif response.status_code == 404:
        print(f"Student with ID {student_id} not found.")
    else:
        print(f"Error: Unable to delete student. Status code: {response.status_code}")

#Display the execution results in the console and write them to the results.txt file
def get_all_students_and_save_to_file():
    response = requests.get(f'{BASE_URL}/students')

    if response.status_code == 200:
        students = response.json()

        
        print("List of all students:")
        for student in students:
            print(student)

        
        with open("results.txt", "w") as file:
            file.write("List of all students:\n")
            for student in students:
                file.write(f"{student}\n")
            print("Students succesfully writed to the results.txt file")

    else:
        print(f"Error: Unable to retrieve the list of students. Status code: {response.status_code}")



# Running the tests
if __name__ == "__main__":
    
   test_get_all_students()                              # Retrieve all existing students (GET). +
   test_create_students()                               # Create three students (POST) +
   test_get_all_students()                              # Retrieve information about all existing students (GET). +
   update_age(2, 25)                                    # Update the age of the second student (PATCH) +
   test_get_student_by_id(2)                            # Retrieve information about the second student (GET). +
   update_all_student_data(3, 28, "Koliya", "Boychuck") # Update the fist name, last name and the age of the third student (PUT) +
   test_get_student_by_id(3)                            # Retrieve information about the third student (GET). +
   test_get_all_students()                              # Retrieve information about all existing students (GET). +
   delete_student(1)                                    # Delete the first user (DELETE) +
#  test_get_all_students()                              # Retrieve information about all existing students (GET). +
   get_all_students_and_save_to_file()                  # Display the execution results in the console and write them to the results.txt file.+
#  test_get_students_by_last_name('Doe')                # Test retrieving students by last name

#PART 2: Create test_requests.py
#Functionalities
#Create a test_requests.py file to verify the created REST API. In this file, demonstrate the 
# functionality of all methods using the requests library in the following sequence:

#+Retrieve all existing students (GET). +
#+Create three students (POST). +
#+Retrieve information about all existing students (GET). +
#+Update the age of the second student (PATCH). +
#+Retrieve information about the second student (GET). +
#+Update the fist name, last name and the age of the third student (PUT). +
#+Retrieve information about the third student (GET). +
#+Retrieve all existing students (GET). +
#+Delete the first user (DELETE). +
#+Retrieve all existing students (GET).
#+Display the execution results in the console and write them to the results.txt file.

#As a result, you should push app.py, test_requests.py, results.txt, requirements.txt and screenshots of execution to GitHub.

