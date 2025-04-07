Task
Create a test GitHub repository with a Node.js app from forStep2.

Create a test account in Docker Hub (free): Docker Hub

Using Vagrant, create two VMs: one for the Jenkins server and the second for the Jenkins worker.

Manually or in the Vagrant file, add installation of Docker and run Jenkins on the first VM.
Manually or using the Vagrant file, add installation of Docker and Jenkins worker directly on the second VM (without Docker).
Connect the Jenkins worker to the master node. Check that you can run a test pipeline on the Jenkins worker.

Add credentials with your Docker Hub username and password to Jenkins credentials.

Create a test pipeline using the Groovy language, which will start by running it manually. The pipeline must:

Pull the code.
Build the Docker image on the Jenkins worker.
Run the Docker image with tests.
If the tests are successful, log in to your Docker Hub account using Jenkins credentials from step 7 and push the built image to Docker Hub.
If the tests fail, print the message "Tests failed".
