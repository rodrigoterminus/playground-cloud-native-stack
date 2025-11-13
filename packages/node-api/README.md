# Node.js API

A simple Nest.js API server with a root endpoint that returns a JSON hello world response.

## Prerequisites

- Node.js 20+
- npm

## Installation

```bash
npm install
```

## Running the Application

### Development Mode
```bash
npm run start:dev
```

### Production Mode
```bash
npm run build
npm run start:prod
```

The API will be available at `http://localhost:3000`.

## Docker

### Build the Image
```bash
docker build -t node-api .
```

### Run the Container
```bash
docker run -p 3000:3000 node-api
```

## API Endpoints

- `GET /` - Returns a hello world JSON response

Example response:
```json
{
  "message": "Hello World",
  "timestamp": "2025-11-13T12:00:00.000Z",
  "service": "node-api"
}
```
