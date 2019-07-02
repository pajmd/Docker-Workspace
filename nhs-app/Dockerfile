# Dockerfile

# build from  ~/Docker\ Workspace, context being $home
# docker build --no-cache --tag=nhs-server:v0.1 -f nsh-app/Dockerfile $HOME

# Use an official Python runtime as a parent image
FROM python:3.6-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY python_workspace/PychramProjects/nhs-server /app
COPY js_workspace/VueProjects/nhs-ui/dist /app/nhs-ui

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variable
ENV NAME World

# need to extend PYHTONPATH
ENV PYTHONPATH="$PYTHONPATH:/app"

# NHS-UI built distribution
ENV NHS_UI_DIST="nhs-ui"

# Run app.py when the container launches
CMD ["python", "app/run.py"]
