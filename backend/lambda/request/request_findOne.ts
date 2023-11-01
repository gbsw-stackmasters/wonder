import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, GetCommand } from "@aws-sdk/lib-dynamodb";
import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";

const dynamo = new DynamoDBClient({})
const client = DynamoDBDocumentClient.from(dynamo)

export const handler = async (events: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  const { id } = events.pathParameters!

  const res = await client.send(
    new GetCommand({
      TableName: 'wonder_request',
      Key: {
        id
      }
    })
  )

  if (res.Item) {
    const response = {
      'statusCode': 200,
      'headers': {
        'Content-Type': '*/*'
      },
      'body': JSON.stringify({
        success: true,
        body: res.Item
      }),
      'isBase64Encoded': false
    }
    return response

  } else {
    const response = {
      'statusCode': 200,
      'headers': {
        'Content-Type': '*/*'
      },
      'body': JSON.stringify({
        success: false,
        error: 'not found request'
      }),
      'isBase64Encoded': false
    }
    return response
  }
}