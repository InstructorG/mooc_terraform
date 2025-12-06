import json
import random


def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        'body': json.dumps({'proverb': read_proverbs()})
    }


def read_proverbs():
    # Chargement de la liste des proverbes depuis le fichier
    with open('proverbs.txt', 'r', encoding='utf-8') as f:
        proverbs = [line.strip() for line in f if line.strip()]

    # Sélection aléatoire d'un proverbe
    return random.choice(proverbs)

