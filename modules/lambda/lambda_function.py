import os
import json
import requests
from kafka import KafkaProducer

def lambda_handler(event, context):
  # Get environment variables
  bootstrap_servers = os.environ['KAFKA_BOOTSTRAP_SERVERS'].split(',')
  topic = os.environ['KAFKA_TOPIC']
  api_endpoint = os.environ['API_ENDPOINT']

  # Fetch data from the StockMarket API
  response = requests.get(api_endpoint)
  if response.status_code == 200:
    stock_data = response.json()
  else:
    raise Exception(f"Failed to fetch data from API: {response.status_code}")

  # Create Kafka producer
  producer = KafkaProducer(
    bootstrap_servers=bootstrap_servers,
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
  )

  # Send data to Kafka topic
  for stock in stock_data:
    producer.send(topic, value=stock)

  producer.flush()

  return {
    'statusCode': 200,
    'body': json.dumps('Data sent to Kafka successfully')
  }
