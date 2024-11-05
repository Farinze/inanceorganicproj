# Use the latest official Python runtime as a parent image
FROM python:3.9  # Specify a stable Python version for consistency

# Set the working directory
WORKDIR /usr/src/app

# Copy requirements.txt into the working directory
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Expose port 8000 for Django app
EXPOSE 8000

# Define environment variable for Django settings (adjust as needed)
ENV DJANGO_SETTINGS_MODULE=myproject.settings

# Run manage.py to start the Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
