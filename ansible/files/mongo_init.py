#!/usr/bin/env python
'''
Helper script to generate a mongo rs.initiate() query.
To be used by terraform to initiate the deployed mongo cluster.

Usage: ./mongo_init.py --rsn <replicaSetName> <List of host:port>
'''

from argparse import ArgumentParser
import json

parser = ArgumentParser()
parser.add_argument('--rsn', dest='rsn', nargs="?", default="rs0",
                    help='Provide the replSetName')
parser.add_argument("hosts", nargs="+",
                    help="Provide the mongodb hosts")
args = parser.parse_args()

init_dict = {}
init_dict["_id"] = args.rsn
init_dict["members"] = []

for index, host in enumerate(args.hosts):
    init_dict["members"].append({"_id": index, "host": host})

print("rs.initiate( " + json.dumps(init_dict, sort_keys=True) + ")")
