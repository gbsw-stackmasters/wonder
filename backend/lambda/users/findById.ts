import { DynamoDBClient, QueryCommand }  from '@aws-sdk/client-dynamodb'
import { DynamoDBDocumentClient } from '@aws-sdk/lib-dynamodb'
import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda'

const dynamo = new DynamoDBClient({})
const client = DynamoDBDocumentClient.from(dynamo)

export const handler = async (events: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  const { id } = events.pathParameters!

  const res = await client.send(
    new QueryCommand({
      TableName: 'DynamoUsers',
      KeyConditionExpression: 'username = :username',
      ExpressionAttributeValues: {
        ':username': { S: id! }
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
      body: JSON.stringify(res)
    }),
    "isBase64Encoded": false
  } 
  return response

  // const data = await client.send(
  //   new GetCommand({
  //     TableName: "DynamoUsers",
  //     Key: {
  //       id
  //     }
  //   })
  // )

  // const response = {
  //   "statusCode": 200,
  //   "headers": {
  //     "Content-Type": "*/*"
  //   },
  //   "body": JSON.stringify(data.Item),
  //   "isBase64Encoded": false
  // }

  // return response;
}