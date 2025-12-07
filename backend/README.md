# CP Tracker Backend

Node.js/Express backend for serving contest data to the CP Tracker Flutter app.

## Features

- Fetches contests from Codeforces, LeetCode, and CodeChef
- 10-minute caching to reduce API calls
- CORS enabled for Flutter app
- RESTful API endpoint

## Installation

```bash
cd backend
npm install
```

## Running Locally

```bash
# Development mode (with auto-reload)
npm run dev

# Production mode
npm start
```

Server will run on `http://localhost:3000`

## API Endpoints

### GET /contest/upcoming

Fetches upcoming contests from specified platforms.

**Query Parameters:**
- `platforms` (optional): JSON array of platform names

**Example:**
```bash
# All platforms
curl "http://localhost:3000/contest/upcoming"

# Specific platforms
curl "http://localhost:3000/contest/upcoming?platforms=[\"Codeforces\",\"LeetCode\"]"
```

**Response:**
```json
{
  "platforms": ["Codeforces", "LeetCode"],
  "upcoming_contests": [
    {
      "platform": "Codeforces",
      "name": "Codeforces Round #900",
      "startTime": 1732300000,
      "endTime": 1732308000,
      "duration": 120,
      "url": "https://codeforces.com/contest/1900"
    }
  ],
  "cached": false
}
```

### GET /health

Health check endpoint.

## Configuration

### Port
Set via environment variable:
```bash
PORT=3000 npm start
```

### Cache Duration
Modify `CACHE_DURATION` in `server.js` (default: 10 minutes)

## Platform Support

✅ **Codeforces** - Full support via official API
✅ **LeetCode** - Full support via GraphQL API  
✅ **CodeChef** - Full support via public API
⚠️ **AtCoder** - Requires scraping (not implemented)
⚠️ **GeeksforGeeks** - No public API (not implemented)
⚠️ **CodingNinjas** - No public API (not implemented)

## Deployment

### Local Network (for testing on device)

1. Get your computer's local IP:
```bash
# macOS/Linux
ifconfig | grep "inet "
# Look for something like 192.168.1.x
```

2. Start server:
```bash
npm start
```

3. Update Flutter app `lib/main.dart`:
```dart
final contestService = ContestService(
  baseUrl: 'http://192.168.1.x:3000/contest'  // Your local IP
);
```

### Vercel Deployment

1. Install Vercel CLI:
```bash
npm install -g vercel
```

2. Deploy:
```bash
vercel
```

3. Update Flutter app with Vercel URL

### Heroku Deployment

1. Create `Procfile`:
```
web: node server.js
```

2. Deploy:
```bash
git init
heroku create
git add .
git commit -m "Initial commit"
git push heroku main
```

## Testing

```bash
# Test health endpoint
curl http://localhost:3000/health

# Test contest endpoint
curl http://localhost:3000/contest/upcoming

# Test with specific platform
curl "http://localhost:3000/contest/upcoming?platforms=[\"Codeforces\"]"

# Pretty print JSON
curl -s http://localhost:3000/contest/upcoming | jq .
```

## Troubleshooting

### CORS Issues
Already configured with `cors` package. If issues persist, check browser console.

### API Rate Limiting
Uses 10-minute cache to prevent hitting platform APIs too frequently.

### Platform API Errors
Check console logs for specific error messages. Some platforms may have temporary issues.

## Development

### Add New Platform

1. Create fetch function in `server.js`:
```javascript
const fetchNewPlatformContests = async () => {
  // Implement fetch logic
  return contests;
};
```

2. Add to `fetchAllContests`:
```javascript
if (platforms.includes('NewPlatform')) {
  promises.push(fetchNewPlatformContests());
}
```

### Modify Cache Duration

```javascript
const CACHE_DURATION = 15 * 60 * 1000; // 15 minutes
```

## License

MIT
