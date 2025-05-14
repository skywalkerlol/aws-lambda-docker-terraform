FROM public.ecr.aws/lambda/python:3.11

# Create a non-root user for security
RUN yum install -y shadow-utils && \
    useradd -u 1000 appuser && \
    chown -R appuser /var/task

# Copy function code
COPY handler.py ./
COPY requirements.txt ./

# Upgrade setuptools to a secure version
RUN pip install --upgrade setuptools>=70.0.0

# Install dependencies
RUN pip install -r requirements.txt

# Switch to non-root user
USER appuser

# Add a healthcheck to ensure handler.py and function exist
HEALTHCHECK CMD python -c "from handler import lambda_handler" || exit 1

# Set the command to your Lambda handler
CMD ["handler.lambda_handler"]