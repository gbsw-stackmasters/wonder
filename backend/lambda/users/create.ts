import { DynamoDBClient } from '@aws-sdk/client-dynamodb'
import { DynamoDBDocumentClient, PutCommand } from '@aws-sdk/lib-dynamodb'
import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda'
import { v4 } from 'uuid'

const dynamo = new DynamoDBClient({})
const client = DynamoDBDocumentClient.from(dynamo)

export const handler = async (events: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  const body = JSON.parse(events.body!)

  await client.send(
    new PutCommand({
      TableName: 'DynamoUsers',
      Item: {
        id: v4(),
        username: body.name,
        password: body.password
      },
    })
  )

  const response = {
    "statusCode": 200,
    "headers": {
      "Content-Type": "*/*"
    },
    "body": JSON.stringify({
      success: true,
      body: {
        username: body.name,
        password: body.password
      }
    }),
    "isBase64Encoded": false
  }

  return response
}