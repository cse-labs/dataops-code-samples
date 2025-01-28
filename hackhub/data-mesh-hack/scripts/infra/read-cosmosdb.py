import argparse
import ast
import json
from azure.cosmos import CosmosClient

parser = argparse.ArgumentParser(description="Argument Parser", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("cosmosdb_endpoint", help="CosmosDB Endpoint URL")
parser.add_argument("cosmosdb_key", help="CosmosDB Account Key")
parser.add_argument("-d", "--database_name", help="CosmosDB Database Name", default="southridge")
parser.add_argument("-c", "--container_name", help="CosmosDB Container Name", default="movies")
parser.add_argument("-f", "--file_name", help="Output file name", default="./data/southridge/movies_southridge-V2.json")
parser.add_argument("-k", "--partition_key", help="Debug mode", default="/genre")

args = parser.parse_args()
config = vars(args)

endpoint = config["cosmosdb_endpoint"]
key = config["cosmosdb_key"]
database = config["database_name"]
container = config["container_name"]
file_name = config["file_name"]
part_key = config["partition_key"]

writer = open(file_name, "w")
# Initialize the Cosmos DB client
client = CosmosClient(endpoint, key)

# Create or get the database
db = client.create_database_if_not_exists(id=database)

# Create or get the container (collection)
con = db.create_container_if_not_exists(
    id=container,
    partition_key=part_key
)

item = con.query_items(
    query = "SELECT c.id, c.actors, c.availabilityDate, c.genre, c.rating, c.releaseYear, c.runtime, c.streamingAvailabilityDate, c.tier, c.title, c.synopsis FROM c",
    enable_cross_partition_query=True
)

print(json.dumps(list(item)), file=writer)
