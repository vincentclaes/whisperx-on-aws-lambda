ARG FUNCTION_DIR="/function"

FROM python:3.12

ARG FUNCTION_DIR
WORKDIR ${FUNCTION_DIR}

RUN pip install \
    --target ${FUNCTION_DIR} \
        awslambdaric

RUN apt-get update && \
    apt-get install -y build-essential ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt ${LAMBDA_TASK_ROOT}
COPY lambda_function.py ${LAMBDA_TASK_ROOT}

RUN pip install -r requirements.txt

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD [ "lambda_function.lambda_handler" ]