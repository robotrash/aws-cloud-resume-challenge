import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('crc-viewcount-db')

def handler(event, context):
    response = table.get_item(Key={'id': '1'})
    views = response['Item']['views']
    views += 1  # Increment by one 
    # Update views value in the table where id = 0 
    response = table.put_item(Item={
        'id' : '1',   
        'views' : views
    })
    # Retun the count of views value
    return views