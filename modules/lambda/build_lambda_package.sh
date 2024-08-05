#!/bin/bash

# Create a temporary directory
mkdir -p lambda_package

# Install dependencies
pip install -r requirements.txt -t lambda_package

# Copy the Lambda function code
cp lambda_function.py lambda_package/

# Create the ZIP file
cd lambda_package
zip -r ../lambda_function.zip .
cd ..

# Clean up
rm -rf lambda_package
