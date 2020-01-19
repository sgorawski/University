FROM python:3-alpine

COPY . /

RUN pip install -r requirements.txt

EXPOSE 8000

ENV MSG default

ENTRYPOINT ["gunicorn"]
CMD ["app:app", "-b", "0.0.0.0:8000"]