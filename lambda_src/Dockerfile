FROM public.ecr.aws/lambda/python:3.9

# Copy function code
COPY handler.py ./
COPY requirements.txt ./

# Install dependencies
RUN pip install -r requirements.txt

# Set the CMD to your handler (filename.handler_function_name)
CMD ["app.lambda_handler"]
