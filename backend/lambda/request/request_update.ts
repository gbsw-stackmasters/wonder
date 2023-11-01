import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, GetCommand, UpdateCommand } from "@aws-sdk/lib-dynamodb";
import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";

const dynamo = new DynamoDBClient({})
const client = DynamoDBDocumentClient.from(dynamo)

export const handler = async (events: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  const body = JSON.parse(events.body!)

  await client.send(
    new UpdateCommand({
      TableName: 'wonder_request',
      Key: { 
        id: body.id
       },
      UpdateExpression: 'set likes = :likes',
      ExpressionAttributeValues: {
        ':likes': body.likes,
      }
    })
  )
  await client.send(
    new UpdateCommand({
      TableName: 'wonder_request',
      Key: { 
        id: body.id
       },
      UpdateExpression: 'set success = :success',
      ExpressionAttributeValues: {
        ':success': body.success
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
        likes: body.likes,
        success: body.success
      }
    }),
    "isBase64Encoded": false
  }

  return response
}