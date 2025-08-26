{
  "swagger": "2.0",
  "info": {
    "title": "${api_title}",
    "version": "1.0",
    "description": "Import from Function App"
  },
  "host": "${apim_hostname}",
  "basePath": "/${base_path}",
  "schemes": ["https"],
  "paths": {
    "/http_trigger": {
      "post": {
        "operationId": "http-trigger",
        "summary": "HTTP trigger endpoint",
        "responses": {
          "200": {
            "description": "Success response from Function App"
          }
        }
      }
    }
  }
}