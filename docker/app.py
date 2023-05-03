from flask import Flask
import boto3
import os


app = Flask(__name__)

# Initialize the DynamoDB client
dynamodb = boto3.resource('dynamodb',
                          region_name=os.environ['AWS_REGION'],
                          aws_access_key_id=os.environ['AWS_ACCESS_KEY_ID'],
                          aws_secret_access_key=os.environ['AWS_SECRET_ACCESS_KEY'])


@app.route("/")
def index():
    # Connect to the "dynamodb01" DynamoDB table
    table_name = 'dynamodb01'
    table = dynamodb.Table(table_name)

    # Read all items from the table
    response = table.scan()
    items = response.get("Items", [])
    
    # Build an HTML table with the items
    style = "\"border: 1px solid black; border-radius: 10px;\""
    table_html = "<html>\n<head>\n  <title>{}</title>\n</head>\n<body>\n".format(table_name)
    table_html += "<table style={}>\n".format(style)
    table_html += "<tr>\n  <th style={}>count</th>\n  <th style={}>key</th>\n  <th style={}>value</th>\n</tr>\n".format(style, style, style)
    for count, item in enumerate(items):
        for key, value in item.items():
            table_html += "<tr>\n  <td style={}>{}</td>\n  <td style={}>{}</td>\n  <td style={}>{}</td></tr>\n".format(style, count, style, key, style, value)
    table_html += "</body>\n</table>\n</html>\n"

    # Return the HTML table as the response
    return table_html
