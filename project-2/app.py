#!/usr/bin/env python3
import json
import random

from flask import Flask  # https://flask.palletsprojects.com/en/1.1.x/
from flask import jsonify
from flask import request

from flask_cors import CORS  # https://flask-cors.readthedocs.io/en/latest

import pymongo  # https://api.mongodb.com/python/current
from pymongo import MongoClient
from bson.objectid import ObjectId

from faker import Faker  # https://faker.readthedocs.io/en/stable/index.html
from faker.providers import internet
from faker.providers import lorem

app = Flask(__name__)
CORS(app)

@app.route('/articles/<id>/comments', methods=['POST'])
def comment(id):
    article = db.articles.find_one({"_id": ObjectId(id)})
    article["_id"] = str(article["_id"])

    db.articles.update_one({"_id": ObjectId(id)}, {"$push": { "comments": request.json["comment"] }})

    article = db.articles.find_one({"_id": ObjectId(id)})
    article["_id"] = str(article["_id"])

    return jsonify(article)


@app.route('/articles')
def articles():
    articles = []
    for article in db.articles.find().sort("_id", pymongo.DESCENDING).limit(10):
        article["_id"] = str(article["_id"])
        articles.append(article)
    return jsonify(articles)

@app.route('/map_reduce_1')
def mapreduce1():
    map = "function(){ emit( this.comments.length, 1 ); }"
    reduce = "function(key, value){ return Array.sum(value); }"
    out = "mapreduce1"

    db.articles.map_reduce(map, reduce, out)

    results = []
    for result in db.mapreduce1.find():
        results.append(result)

    return jsonify(results)


@app.route('/map_reduce_2')
def mapreduce2():
    map = "function(){ emit( this.comments.length > 0 ? 1 : 0, 1 ); }"
    reduce = "function(key, value){ return Array.sum(value); }"
    finalize = f"function(key, reducedVal){{ return reducedVal/{db.articles.count_documents({})}; }}"
    out = "mapreduce2"

    db.articles.map_reduce(map, reduce, out, finalize=finalize)

    results = []
    for result in db.mapreduce2.find():
        results.append(result)

    return jsonify(results)


if __name__ == '__main__':
    global db

    client = MongoClient()
    db = client.cnn

    fake = Faker()
    fake.add_provider(internet)
    fake.add_provider(lorem)

    #NUM = 5
    NUM = 10000
    if db.articles.count_documents({}) < NUM:
        for _ in range(NUM):
            article = {
                "title": fake.sentence(nb_words=random.randint(5, 10)),
                "text": fake.paragraph(nb_sentences=random.randint(50, 100)),
                "author": fake.name(),
                "image": fake.image_url(width=200, height=100),
                "comments": [fake.paragraph() for _ in range(random.randint(0, 5))]
            }
            #"comments": [fake.paragraph() for _ in range(random.randint(0, 20))]
            db.articles.insert_one(article)

    app.run()