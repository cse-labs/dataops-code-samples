import argparse
from azure.cosmos import CosmosClient

parser = argparse.ArgumentParser(description="Argument Parser", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("cosmosdb-endpoint", help="CosmosDB Endpoint URL")
parser.add_argument("cosmosdb-key", help="CosmosDB Account Key")
parser.add_argument("database-name", help="CosmosDB Database Name")
parser.add_argument("container-name", help="CosmosDB Container Name")
parser.add_argument("file-name", help="JSON File Name")

args = parser.parse_args()
config = vars(args)

# Replace these with your actual Cosmos DB account credentials
endpoint = config['cosmosdb-endpoint']
key = config['cosmosdb-key']
database = config['database-name']
container = config['container-name']
file_name = config['file-name']

def read_json_file(file_path):
    import json
    with open(file_path, 'r') as file:
        data = json.load(file)
    return data

def write_to_cosmosdb(data):
    # Initialize the Cosmos DB client
    client = CosmosClient(endpoint, key)

    # Create or get the database
    db = client.create_database_if_not_exists(id=database)

    # Create or get the container (collection)
    con = db.create_container_if_not_exists(
        id=container,
        partition_key="/genre"
    )

    # Iterate through the data and insert into Cosmos DB
    i = 0
    for item in data:
        con.upsert_item(body=item)
        i += 1
        if (i%250 == 0):
            print("[I] Modified {} items".format(i))
    print("[I] Modified {} items".format(i))

# Read the JSON data from the file
print("[I] Reading JSON data from file: {}".format(file_name))
json_data = read_json_file(file_name)

# Write the JSON data to Cosmos DB
print("[I] Writing JSON data to Cosmos DB")
write_to_cosmosdb(json_data)
