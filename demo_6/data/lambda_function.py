import json


def lambda_handler(event, context):
    print(event)
    return {
        'statusCode': 200,
        'body': json.dumps('RECEIVED NOTIFICATION FROM EVENT'),
        'event': json.dumps(event)
    }