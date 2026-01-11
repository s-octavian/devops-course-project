FROM python:3.12

WORKDIR /app

COPY requirements.txt .
COPY app.py .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

ENV SERVICE_ID="Unknown"
ENV FLASK_RUN_PORT=5000

CMD ["python", "app.py"]