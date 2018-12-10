#!/usr/bin/env python3
'''
Helper script to generate a mongo rs.initiate() query.
To be used by terraform to initiate the deployed mongo cluster.

usage: mongo_init.py [-h] [--host HOST] [--port int] [--rsn [RSN]]
                     members [members ...]
'''

from argparse import ArgumentParser
from pymongo import MongoClient

parser = ArgumentParser()
parser.add_argument('--host', action='store',
                    help='Provide the target mongod host')
parser.add_argument('--port', action='store', default='27017', metavar='int',
                    type=int, help='Provide the target mongod port')
parser.add_argument('--rsn', action='store', nargs="?",
                    default="rs0", help='Provide the replica set name')
parser.add_argument('members', nargs="+",
                    help="Provide the list of replica set members as "
                         "HOST:PORT")
args = parser.parse_args()

config = {}
config["_id"] = args.rsn
config["members"] = []

for index, member in enumerate(args.members):
    config["members"].append({"_id": index, "host": member})

c = MongoClient(args.host, args.port)
c.admin.command("replSetInitiate", config)
