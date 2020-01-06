#!/usr/bin/env python3
import json
import random

from flask import Flask  # https://www.fullstackpython.com/flask.html
from flask import jsonify

from flask_cors import CORS  # https://flask-cors.readthedocs.io/en/latest

import pymongo  # https://api.mongodb.com/python/current
from pymongo import MongoClient

from faker import Faker  # https://faker.readthedocs.io/en/stable/index.html
from faker.providers import internet
from faker.providers import lorem

app = Flask(__name__)
CORS(app)

@app.route('/articles')
def articles():
    articles = []
    for article in db.articles.find().sort("_id", pymongo.DESCENDING).limit(10):
        article["_id"] = str(article["_id"])
        articles.append(article)
    return jsonify(articles)

if __name__ == '__main__':
    global db

    client = MongoClient()
    db = client.cnn

    fake = Faker()
    fake.add_provider(internet)
    fake.add_provider(lorem)
    for _ in range(10):
        article = {
            "title": fake.sentence(nb_words=random.randint(5, 10)),
            "text": fake.paragraph(nb_sentences=random.randint(50, 100)),
            "author": fake.name(),
            "image": fake.image_url(width=200, height=100)
        }
        db.articles.insert(article)

    app.run()