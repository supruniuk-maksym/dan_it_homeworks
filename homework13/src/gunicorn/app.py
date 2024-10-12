#REST API
#PART 1: Develop a REST API
#Functionalities
#Develop a REST API for student management in Python using the Flask library named app.py, 
#with data persistence in a students.csv file. The API should support GET, POST, PUT, PATCH, 
# and DELETE requests. Each student should have fields for id, first name, last name, and age.

from flask import Flask, jsonify, request 
app = Flask(__name__)

import csv 
import json

#HTTP Requests

#GET
#+Retrieve information about a specific student (display all available information):
#By their ID; if the provided ID is not found in the CSV file, return an error.
#By their last name; if there are multiple students with the same last name, display all of them; 
# if the provided last name is not found in the CSV file, return an error.
#Retrieve a list of all students (display all available information).

@app.route('/students', methods=['GET'])
def get_students():
    students = []
    
    with open('students.csv', mode='r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            students.append(row)
    
    student_id = request.args.get('id')
    last_name = request.args.get('last_name')

    print(f"Received student_id: {student_id}, last_name: {last_name}")
    
    if student_id:
        for student in students:
            print(f"Comparing student ID {student['id']} with {student_id}")
        
        student_by_id = next((student for student in students if str(student['id']) == str(student_id)), None)
        
        if student_by_id is None:
            return jsonify({'error': 'Student with provided ID not found'}), 404
        
        return jsonify(student_by_id)

    elif last_name:
        students_by_last_name = [student for student in students if student['last_name'].strip().lower() == last_name.strip().lower()]
        
        if not students_by_last_name:
            return jsonify({'error': 'Students with provided last name not found'}), 404
        
        return jsonify(students_by_last_name)

    return jsonify(students)



#POST
#Create a new student.
#The ID field should be automatically generated with an increment of +1.
#The POST request body should include first name, last name, and age.
#If a non-existing field is passed in the POST body or if no fields are passed at all, return an error.
#If any of the fields are missing in the POST body, return an error without writing to the CSV file.
#Upon successful request, return information about the added student.


# Route for creating one or more students (POST)
@app.route('/students', methods=['POST'])
def post_students():
    # Required fields for creating a new student
    required_fields = ['first_name', 'last_name', 'age']

    # Get data from the request (can be one student or a list of students)
    data = request.get_json()

    # If no data is provided or data is not in the correct format, return an error
    if not data:
        return jsonify({'error': 'No input provided or invalid format.'}), 400

    # Handle the case where a single student (dict) is provided
    if isinstance(data, dict):
        new_students = [data]  # Convert to a list for consistent processing
    # Handle the case where multiple students (list) are provided
    elif isinstance(data, list):
        new_students = data
    else:
        return jsonify({'error': 'Invalid input format. Expected a student or a list of students.'}), 400

    # Validate each student in the list
    for student in new_students:
        # Check if all required fields are present
        for field in required_fields:
            if field not in student:
                return jsonify({'error': f'Missing required field: {field}'}), 400

        # Ensure no extra fields are passed
        for key in student.keys():
            if key not in required_fields:
                return jsonify({'error': f'Invalid field: {key}. Only first name, last name, and age are allowed.'}), 400

    # Read existing students from CSV file
    students = []
    with open('students.csv', mode='r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            students.append(row)

    # Determine the new ID (auto-incremented by +1)
    if students:
        new_id = int(max(int(student['id']) for student in students)) + 1
    else:
        new_id = 1  # Start with ID = 1 if there are no students

    # Add unique ID to each new student
    for new_student in new_students:
        new_student['id'] = new_id
        new_id += 1  # Increment ID for the next student

    # Write all new students to the CSV file
    with open('students.csv', mode='a', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['id', 'first_name', 'last_name', 'age'])
        
        # Write header if the file is empty
        if file.tell() == 0:
            writer.writeheader()

        # Write all new students
        writer.writerows(new_students)

    # Return the list of added students
    return jsonify(new_students), 201



#PUT
#Update student information by their ID.
#It should be possible to update the fields first name, last name, and age.
#If the provided ID is not found in the CSV file, return an error.
#The PUT request body should include first name, last name, and age accordingly.
#If a non-existing field is passed in the PUT body or if no fields are passed at all, return an error.
#Upon successful request, return the updated information about the student.

@app.route('/students/<int:id>', methods=['PUT'])
def update_student(id):
    updated_data = request.get_json()
    
    allowed_fields = ['first_name', 'last_name', 'age']
    
    students = []
    updated_student = None
    
    with open('students.csv', mode='r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            if int(row['id']) == id:
                for key in allowed_fields:
                    if key in updated_data:
                        row[key] = updated_data[key]
                updated_student = row  
            students.append(row)

    if updated_student is None:
        return jsonify({'error': 'Student not found'}), 404

    with open('students.csv', mode='w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['id', 'first_name', 'last_name', 'age'])
        writer.writeheader()
        writer.writerows(students)

    return jsonify(updated_student), 200




#PATCH
#Update a student's age by their ID.
#It should be possible to update the age field.
#If the provided ID is not found in the CSV file, return an error.
#The PATCH request body should include the age.
#If a non-existing field is passed in the PATCH body or if no fields are passed at all, return an error.
#Upon successful request, return the updated information about the student.

@app.route('/students/<int:id>', methods=['PATCH'])
def patch_student(id):
    updated_age = request.get_json().get('age')
    students = []
    with open('students.csv', mode='r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            if int(row['id']) == id:
                row['age'] = updated_age
            students.append(row)

    with open('students.csv', mode='w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['id', 'first_name', 'last_name', 'age'])
        writer.writeheader()
        writer.writerows(students)

    return jsonify({'id': id, 'age': updated_age})

#DELETE
#Delete a student from the CSV file by their ID.
#If the provided ID is not found in the CSV file, return an error.
#Upon successful request, return a message confirming the successful deletion of the student.

@app.route('/students/<int:id>', methods=['DELETE'])
def delete_student(id):
    students = []
    student_deleted = False
    with open('students.csv', mode='r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            if int(row['id']) != id:
                students.append(row)
            else:
                student_deleted = True

    with open('students.csv', mode='w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['id', 'first_name', 'last_name', 'age'])
        writer.writeheader()
        writer.writerows(students)

    if student_deleted:
        return jsonify({'message': f'Student with id {id} deleted successfully'}), 200
    else:
        return jsonify({'message': 'Student not found'}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)


#REST API
#PART 1: Develop a REST API
#Functionalities
#Develop a REST API for student management in Python using the Flask library named app.py, 
#with data persistence in a students.csv file. The API should support GET, POST, PUT, PATCH, 
# and DELETE requests. Each student should have fields for id, first name, last name, and age.



#HTTP Requests
#GET
#Retrieve information about a specific student (display all available information):
#By their ID; if the provided ID is not found in the CSV file, return an error.
#By their last name; if there are multiple students with the same last name, display all of them; 
# if the provided last name is not found in the CSV file, return an error.
#Retrieve a list of all students (display all available information).
#POST
#Create a new student.
#The ID field should be automatically generated with an increment of +1.
#The POST request body should include first name, last name, and age.
#If a non-existing field is passed in the POST body or if no fields are passed at all, return an error.
#If any of the fields are missing in the POST body, return an error without writing to the CSV file.
#Upon successful request, return information about the added student.
#PUT
#Update student information by their ID.
#It should be possible to update the fields first name, last name, and age.
#If the provided ID is not found in the CSV file, return an error.
#The PUT request body should include first name, last name, and age accordingly.
#If a non-existing field is passed in the PUT body or if no fields are passed at all, return an error.
#Upon successful request, return the updated information about the student.
#PATCH
#Update a student's age by their ID.
#It should be possible to update the age field.
#If the provided ID is not found in the CSV file, return an error.
#The PATCH request body should include the age.
#If a non-existing field is passed in the PATCH body or if no fields are passed at all, return an error.
#Upon successful request, return the updated information about the student.
#DELETE
#Delete a student from the CSV file by their ID.
#If the provided ID is not found in the CSV file, return an error.
#Upon successful request, return a message confirming the successful deletion of the student.


#PART 2: Create test_requests.py
#Functionalities
#Create a test_requests.py file to verify the created REST API. In this file, demonstrate the 
# functionality of all methods using the requests library in the following sequence:

#Retrieve all existing students (GET).
#Create three students (POST).
#Retrieve information about all existing students (GET).
#Update the age of the second student (PATCH).
#Retrieve information about the second student (GET).
#Update the fist name, last name and the age of the third student (PUT).
#Retrieve information about the third student (GET).
#Retrieve all existing students (GET).
#Delete the first user (DELETE).
#Retrieve all existing students (GET).
#Display the execution results in the console and write them to the results.txt file.

#As a result, you should push app.py, test_requests.py, results.txt, requirements.txt and screenshots of execution to GitHub.
