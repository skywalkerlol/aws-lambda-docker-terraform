FROM public.ecr.aws/lambda/python:3.13

# Copy function code
COPY handler.py ./
COPY requirements.txt ./

# Upgrade setuptools to a secure version
RUN pip install --upgrade setuptools>=70.0.0

# Install dependencies
RUN pip install -r requirements.txt

# Switch to non-root user
USER 1000

# Add a healthcheck to ensure handler.py and function exist
HEALTHCHECK CMD python -c "from handler import lambda_handler" || exit 1

# Set the command to your Lambda handler
CMD ["handler.lambda_handler"]