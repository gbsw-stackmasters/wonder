import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, PutCommand } from "@aws-sdk/lib-dynamodb";
import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { v4 } from 'uuid'

const dynamo = new DynamoDBClient({})
const client = DynamoDBDocumentClient.from(dynamo)

export const handler = async (events: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  const body = JSON.parse(events.body!)

  await client.send(
    new PutCommand({
      TableName: 'wonder_request',
      Item: {
        id: v4(),
        title: body.title,
        content: body.content,
        tag: body.tag,
        likes: 0,
        success: 0
      }
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
        title: body.title,
        content: body.content,
        tag: body.tag,
        likes: 0,
        success: 0
      }
    }),
    "isBase64Encoded": false
  }

  return response
}