# Backend Integration Guide

## Quick Backend Setup

The app requires a contest API endpoint. You can use the provided `contest-notifier-extension-main` backend or create your own.

## Using Provided Backend

### Option 1: Deploy to Vercel (Recommended)

The reference backend is already configured for Vercel deployment:

```bash
cd /Users/aliazgorrumi/Development/contest-notifier-extension-main/backend
npm install
vercel deploy
```

After deployment, update `lib/main.dart`:
```dart
final contestService = ContestService(
  baseUrl: 'https://your-app.vercel.app/contest'
);
```

### Option 2: Run Locally for Testing

```bash
cd /Users/aliazgorrumi/Development/contest-notifier-extension-main/backend
npm install
npm run dev
```

Update `lib/main.dart`:
```dart
final contestService = ContestService(
  baseUrl: 'http://localhost:3000/contest'  // or your local IP
);
```

**Note**: For local testing on physical device, replace `localhost` with your computer's local IP address (e.g., `http://192.168.1.100:3000/contest`).

## API Endpoint Specification

### GET /contest/upcoming

**Query Parameters:**
- `platforms` (optional): JSON array of platform names to filter

**Example Requests:**
```
GET /contest/upcoming
GET /contest/upcoming?platforms=["Codeforces","LeetCode"]
```

**Response Format:**
```json
{
  "platforms": ["Codeforces", "LeetCode", "CodeChef"],
  "upcoming_contests": [
    {
      "platform": "Codeforces",
      "name": "Codeforces Round #900",
      "startTime": 1732300000,
      "endTime": 1732308000,
      "duration": 120,
      "url": "https://codeforces.com/contest/1900"
    },
    {
      "platform": "LeetCode",
      "name": "Weekly Contest 370",
      "startTime": 1732320000,
      "endTime": 1732325400,
      "duration": 90,
      "url": "https://leetcode.com/contest/weekly-370"
    }
  ]
}
```

**Field Specifications:**
- `platform`: String - One of: "Codeforces", "LeetCode", "CodeChef", "AtCoder", "GeeksforGeeks", "CodingNinjas"
- `name`: String - Contest title
- `startTime`: Number - Unix timestamp in **seconds** (not milliseconds!)
- `endTime`: Number - Unix timestamp in **seconds**
- `duration`: Number - Duration in **minutes**
- `url`: String (optional) - Direct link to contest

## Custom Backend Implementation

### Node.js/Express Example

```javascript
// server.js
const express = require('express');
const app = express();

app.get('/contest/upcoming', async (req, res) => {
  try {
    // Parse platforms filter
    let platforms = req.query.platforms 
      ? JSON.parse(req.query.platforms) 
      : ['Codeforces', 'LeetCode', 'CodeChef', 'AtCoder', 'GeeksforGeeks', 'CodingNinjas'];
    
    // Fetch contests from your sources
    const contests = await fetchContestsFromAPIs(platforms);
    
    // Filter by duration (optional - backend does this in reference)
    const filtered = contests.filter(c => c.duration <= 15 * 24 * 60);
    
    // Sort by start time
    filtered.sort((a, b) => a.startTime - b.startTime);
    
    res.json({
      platforms: platforms,
      upcoming_contests: filtered
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(3000);
```

### Python/Flask Example

```python
from flask import Flask, request, jsonify
import time

app = Flask(__name__)

@app.route('/contest/upcoming')
def upcoming_contests():
    platforms_param = request.args.get('platforms')
    platforms = json.loads(platforms_param) if platforms_param else [
        'Codeforces', 'LeetCode', 'CodeChef', 'AtCoder', 
        'GeeksforGeeks', 'CodingNinjas'
    ]
    
    contests = fetch_contests_from_apis(platforms)
    filtered = [c for c in contests if c['duration'] <= 15 * 24 * 60]
    filtered.sort(key=lambda x: x['startTime'])
    
    return jsonify({
        'platforms': platforms,
        'upcoming_contests': filtered
    })

if __name__ == '__main__':
    app.run(port=3000)
```

## Platform-Specific Contest Sources

### Codeforces
API: `https://codeforces.com/api/contest.list`
```javascript
const response = await fetch('https://codeforces.com/api/contest.list');
const data = await response.json();
const upcoming = data.result.filter(c => c.phase === 'BEFORE');
```

### LeetCode
API: `https://leetcode.com/graphql`
```javascript
const query = `{
  allContests {
    title
    titleSlug
    startTime
    duration
  }
}`;
```

### CodeChef
Check: `https://www.codechef.com/api/list/contests/all`

### AtCoder
Scrape: `https://atcoder.jp/contests/`

### GeeksforGeeks
Check: Their events/contests page

### CodingNinjas
API varies - check their platform docs

## Testing Your Backend

### cURL Test
```bash
curl "http://localhost:3000/contest/upcoming?platforms=%5B%22Codeforces%22%5D"
```

### Expected Output
```json
{
  "platforms": ["Codeforces"],
  "upcoming_contests": [...]
}
```

### Flutter App Test
1. Update `lib/main.dart` with your URL
2. Run `flutter run`
3. Navigate to Contests tab
4. Tap refresh button
5. Check for contests appearing

## CORS Configuration

If testing from web, enable CORS:

```javascript
// Express
const cors = require('cors');
app.use(cors());

// Or manually
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  next();
});
```

## Caching Recommendations

Cache contest data to avoid rate limits:

```javascript
let cache = null;
let cacheTime = null;
const CACHE_DURATION = 10 * 60 * 1000; // 10 minutes

app.get('/contest/upcoming', async (req, res) => {
  const now = Date.now();
  if (cache && cacheTime && (now - cacheTime) < CACHE_DURATION) {
    return res.json(cache);
  }
  
  // Fetch fresh data
  const data = await fetchContests();
  cache = data;
  cacheTime = now;
  res.json(data);
});
```

## Error Handling

Handle errors gracefully:

```javascript
app.get('/contest/upcoming', async (req, res) => {
  try {
    // ... fetch logic
  } catch (error) {
    console.error('Contest fetch error:', error);
    res.status(500).json({
      platforms: [],
      upcoming_contests: [],
      error: 'Failed to fetch contests'
    });
  }
});
```

## Production Deployment

### Vercel (Serverless)
```bash
vercel deploy --prod
```

### Heroku
```bash
git push heroku main
```

### AWS Lambda
Use serverless framework or AWS SAM

### DigitalOcean App Platform
Connect GitHub repo and deploy

## Security Considerations

1. **Rate Limiting**: Prevent abuse
```javascript
const rateLimit = require('express-rate-limit');
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100
});
app.use('/contest', limiter);
```

2. **Input Validation**: Sanitize platforms parameter
```javascript
const validPlatforms = new Set([
  'Codeforces', 'LeetCode', 'CodeChef', 
  'AtCoder', 'GeeksforGeeks', 'CodingNinjas'
]);

const platforms = JSON.parse(req.query.platforms).filter(
  p => validPlatforms.has(p)
);
```

3. **HTTPS Only**: Use SSL certificates in production

## Monitoring

Track API health:
- Response times
- Error rates  
- Platform availability
- Cache hit rates

## Troubleshooting

### "Failed to fetch contests"
- Check backend URL in app
- Verify backend is running
- Check network connectivity
- Verify API response format

### "Contest data outdated"
- Clear cache on backend
- Force refresh in app
- Check platform API status

### "Some platforms missing"
- Verify platform API is available
- Check platform name spelling
- Review backend logs

---

**Recommendation**: Start with the provided reference backend deployed to Vercel for quickest setup. Customize later as needed.
