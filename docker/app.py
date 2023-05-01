from flask import Flask
import boto3


app = Flask(__name__)

# Initialize the DynamoDB client
dynamodb = boto3.resource('dynamodb')


@app.route("/")
def index():
    # Connect to the "my-table" DynamoDB table
    table = dynamodb.Table('DYNAMODB01')

    # Read all items from the table
    response = table.scan()
    items = response.get("Items", [])

    # Build an HTML table with the items
    table_html = "<table>"
    for item in items:
        key = item.get("key", "")
        value = item.get("value", "")
        table_html += "<tr><td>{}</td><td>{}</td></tr>".format(key, value)
    table_html += "</table>"

    # Return the HTML table as the response
    return table_html

