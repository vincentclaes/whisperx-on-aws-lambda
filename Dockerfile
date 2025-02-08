FROM public.ecr.aws/lambda/python:3.12

RUN dnf -y install git wget tar xz
# Static Build of ffmpeg (open source - go through it if concerned!)
RUN wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz && tar xvf ffmpeg-release-amd64-static.tar.xz && mv ffmpeg-*-amd64-static/ffmpeg /usr/bin/ffmpeg && rm -Rf ffmpeg*
RUN pip install --no-cache-dir setuptools-rust uv

COPY requirements.txt ${LAMBDA_TASK_ROOT}
COPY lambda_function.py ${LAMBDA_TASK_ROOT}

RUN uv pip install --system -r requirements.txt --verbose

CMD [ "lambda_function.lambda_handler" ]