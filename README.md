# chat server
chat system API built using Ruby on Rails. It allows creating applications, chats, and messages, with Elasticsearch for searching messages, and Sidekiq for background job processing.

- Applications: Create and manage chat applications.
- Chats: Create and manage chats within applications.
- Messages: Send and manage messages within chats.
- Elasticsearch: Search messages within chats.
- Sidekiq: Background job processing for indexing messages in Elasticsearch.

## Setup

1. clone repo
```bash 
git clone https://github.com/baselrabia/chat-server.git
cd chat-server
```
 2. start the containers
```bash
make up 
```
3. migration and create elasticsearch index 
```bash
make migrate
make ecs_index
```

## API Endpoints
import the postman collection to access the API `chat-server.postman_collection.json`

Application Management:

- Get All Applications: Fetches a list of all created applications.
- Create Application: Creates a new application with a specified name.
- Get Application by Access Token: Retrieves a specific application using its access token.

Chat Management:

- Get Application Chats: Fetches all chats associated with a specific application.
- Create Chat: Creates a new chat under a specific application.
- Show Chat: Retrieves details of a specific chat.

Message Management:

- Get All Chat Messages: Fetches all messages within a specific chat.
- Create Message: Sends a new message within a specific chat.
- Show Message: Retrieves details of a specific message.
- Search Messages: Searches messages within a chat based on a query term.