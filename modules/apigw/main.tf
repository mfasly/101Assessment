resource "aws_api_gateway_rest_api" "apigw_rest" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "example"
      version = "1.0"
    }
    paths = {
      "/path1" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  name = var.apigw_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "apigw_deploy" {
  rest_api_id = aws_api_gateway_rest_api.apigw_rest.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.apigw_rest.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "apigw_stage" {
  deployment_id = aws_api_gateway_deployment.apigw_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.apigw_rest.id
  stage_name    = "apigw_stage"
}