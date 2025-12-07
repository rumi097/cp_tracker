const express = require('express');
const cors = require('cors');
const axios = require('axios');
const cheerio = require('cheerio');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// In-memory cache to avoid hitting APIs too frequently
let contestCache = null;
let cacheTimestamp = null;
const CACHE_DURATION = 10 * 60 * 1000; // 10 minutes

// Platform fetchers
const fetchCodeforcesContests = async () => {
  try {
    const response = await axios.get('https://codeforces.com/api/contest.list');
    const data = response.data.result || [];
    
    const contests = [];
    data.forEach((element) => {
      if (element.phase === 'BEFORE' || element.phase === 'CODING') {
        const startTime = element.startTimeSeconds;
        const duration = Math.floor(element.durationSeconds / 60);
        const endTime = startTime + element.durationSeconds;
        
        contests.push({
          platform: 'Codeforces',
          name: element.name || 'Codeforces Contest',
          startTime: startTime,
          endTime: endTime,
          duration: duration,
          url: `https://codeforces.com/contest/${element.id}`
        });
      }
    });
    
    console.log(`Fetched ${contests.length} Codeforces contests`);
    return contests;
  } catch (error) {
    console.error('Codeforces fetch error:', error.message);
    return [];
  }
};

const fetchLeetCodeContests = async () => {
  try {
    const response = await axios.post('https://leetcode.com/graphql', {
      query: `{
        topTwoContests {
          title
          startTime
          duration
          titleSlug
        }
      }`
    }, {
      headers: { 'Content-Type': 'application/json' }
    });
    
    const data = response.data?.data?.topTwoContests || [];
    const contests = [];
    
    data.forEach((element) => {
      const startTime = Math.floor(element.startTime);
      const duration = Math.floor(element.duration / 60);
      const endTime = startTime + element.duration;
      
      contests.push({
        platform: 'LeetCode',
        name: element.title || 'LeetCode Contest',
        startTime: startTime,
        endTime: endTime,
        duration: duration,
        url: `https://leetcode.com/contest/${element.titleSlug}`
      });
    });
    
    console.log(`Fetched ${contests.length} LeetCode contests`);
    return contests;
  } catch (error) {
    console.error('LeetCode fetch error:', error.message);
    return [];
  }
};

const fetchCodeChefContests = async () => {
  try {
    const response = await axios.get(
      'https://www.codechef.com/api/list/contests/all?sort_by=START&sorting_order=asc&offset=0&mode=all'
    );
    
    const data = response.data;
    let allContests = [];
    
    if (data?.present_contests) allContests = [...allContests, ...data.present_contests];
    if (data?.future_contests) allContests = [...allContests, ...data.future_contests];
    
    const contests = [];
    allContests.forEach((element) => {
      const startTime = Math.floor(new Date(element.contest_start_date_iso).getTime() / 1000);
      const endTime = Math.floor(new Date(element.contest_end_date_iso).getTime() / 1000);
      const duration = element.duration || 120;
      
      contests.push({
        platform: 'CodeChef',
        name: element.contest_name || 'CodeChef Contest',
        startTime: startTime,
        endTime: endTime,
        duration: duration,
        url: `https://www.codechef.com/${element.contest_code}`
      });
    });
    
    console.log(`Fetched ${contests.length} CodeChef contests`);
    return contests;
  } catch (error) {
    console.error('CodeChef fetch error:', error.message);
    return [];
  }
};

const fetchAtCoderContests = async () => {
  try {
    const ATCODER_BASE_URL = 'https://atcoder.jp';
    const ATCODER_CONTESTS_PAGE = 'https://atcoder.jp/contests/';
    
    const { data: markup } = await axios.get(ATCODER_CONTESTS_PAGE);
    const $ = cheerio.load(markup);
    
    const contests = [];
    
    const parseTable = (tbody) => {
      tbody.find('tr').each((index, element) => {
        const trElement = $(element);
        
        const startTimeHref = trElement.find('td').eq(0).find('a').attr('href');
        if (!startTimeHref) return;
        
        const startTimeIso = startTimeHref.split('=')[1].split('&')[0];
        const formattedStartTimeIso = `${startTimeIso.substring(0, 4)}-${startTimeIso.substring(4, 6)}-${startTimeIso.substring(6, 8)}T${startTimeIso.substring(9, 11)}:${startTimeIso.substring(11)}`;
        
        const contestLink = trElement.find('td').eq(1).find('a').attr('href');
        const contestName = trElement.find('td').eq(1).text().replace(/[ⒶⒽ◉]/g, '').trim();
        const duration = trElement.find('td').eq(2).text().trim();
        
        const [hours, minutes] = duration.split(':');
        const durationMinutes = Number(hours) * 60 + Number(minutes);
        
        const startTimeJST = new Date(formattedStartTimeIso);
        const startTime = Math.floor((startTimeJST.getTime() - (9 * 60 * 60 * 1000)) / 1000); // To UTC in seconds
        const endTime = startTime + durationMinutes * 60;
        
        contests.push({
          platform: 'AtCoder',
          name: contestName,
          startTime: startTime,
          endTime: endTime,
          duration: durationMinutes,
          url: ATCODER_BASE_URL + (contestLink || '')
        });
      });
    };
    
    // Parse active contests
    const tBodyActive = $('#contest-table-action').find('tbody');
    parseTable(tBodyActive);
    
    // Parse upcoming contests
    const tbodyUpcoming = $('#contest-table-upcoming').find('tbody');
    parseTable(tbodyUpcoming);
    
    console.log(`Fetched ${contests.length} AtCoder contests`);
    return contests;
  } catch (error) {
    console.error('AtCoder fetch error:', error.message);
    return [];
  }
};

const fetchGeeksforGeeksContests = async () => {
  try {
    // GfG doesn't have a public API, would require scraping
    console.log('GeeksforGeeks fetch: API not available, returning empty');
    return [];
  } catch (error) {
    console.error('GeeksforGeeks fetch error:', error.message);
    return [];
  }
};

const fetchCodingNinjasContests = async () => {
  try {
    // CodingNinjas API varies, simplified
    console.log('CodingNinjas fetch: API not available, returning empty');
    return [];
  } catch (error) {
    console.error('CodingNinjas fetch error:', error.message);
    return [];
  }
};

// Main contest fetcher
const fetchAllContests = async (platforms) => {
  const promises = [];
  
  if (platforms.includes('Codeforces')) promises.push(fetchCodeforcesContests());
  if (platforms.includes('LeetCode')) promises.push(fetchLeetCodeContests());
  if (platforms.includes('CodeChef')) promises.push(fetchCodeChefContests());
  if (platforms.includes('AtCoder')) promises.push(fetchAtCoderContests());
  if (platforms.includes('GeeksforGeeks')) promises.push(fetchGeeksforGeeksContests());
  if (platforms.includes('CodingNinjas')) promises.push(fetchCodingNinjasContests());
  
  const results = await Promise.all(promises);
  const allContests = results.flat();
  
  // Filter contests with duration <= 15 days (in minutes)
  const DURATION_LIMIT = 15 * 24 * 60;
  const filtered = allContests.filter(c => c.duration <= DURATION_LIMIT);
  
  // Sort by start time
  filtered.sort((a, b) => a.startTime - b.startTime);
  
  return filtered;
};

// API Routes
app.get('/contest/upcoming', async (req, res) => {
  try {
    // Parse platforms query parameter
    let platforms;
    try {
      platforms = req.query.platforms 
        ? JSON.parse(req.query.platforms)
        : ['Codeforces', 'LeetCode', 'CodeChef', 'AtCoder', 'GeeksforGeeks', 'CodingNinjas'];
    } catch (e) {
      platforms = ['Codeforces', 'LeetCode', 'CodeChef', 'AtCoder', 'GeeksforGeeks', 'CodingNinjas'];
    }
    
    // Validate platforms array
    if (!Array.isArray(platforms)) {
      platforms = ['Codeforces', 'LeetCode', 'CodeChef', 'AtCoder', 'GeeksforGeeks', 'CodingNinjas'];
    }
    
    // Check cache
    const now = Date.now();
    if (contestCache && cacheTimestamp && (now - cacheTimestamp) < CACHE_DURATION) {
      console.log('Returning cached contests');
      // Filter cached contests by requested platforms
      const filtered = contestCache.filter(c => platforms.includes(c.platform));
      return res.json({
        platforms: platforms,
        upcoming_contests: filtered,
        cached: true
      });
    }
    
    // Fetch fresh data
    console.log(`Fetching contests for platforms: ${platforms.join(', ')}`);
    const contests = await fetchAllContests(platforms);
    
    // Update cache
    contestCache = contests;
    cacheTimestamp = now;
    
    res.json({
      platforms: platforms,
      upcoming_contests: contests,
      cached: false
    });
  } catch (error) {
    console.error('Error in /contest/upcoming:', error);
    res.status(500).json({
      platforms: [],
      upcoming_contests: [],
      error: 'Failed to fetch contests'
    });
  }
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Get user submissions from Codeforces
app.get('/api/submissions/codeforces/:username', async (req, res) => {
  try {
    const { username } = req.params;
    const response = await axios.get(`https://codeforces.com/api/user.status?handle=${username}&from=1&count=100`);
    
    if (response.data.status !== 'OK') {
      return res.status(400).json({ error: 'Invalid username or API error' });
    }
    
    const submissions = response.data.result || [];
    const acceptedToday = submissions.filter(sub => {
      const submissionDate = new Date(sub.creationTimeSeconds * 1000);
      const today = new Date();
      return sub.verdict === 'OK' && 
             submissionDate.toDateString() === today.toDateString();
    });
    
    res.json({
      platform: 'Codeforces',
      username,
      todayCount: acceptedToday.length,
      recentAccepted: acceptedToday.slice(0, 10).map(sub => ({
        problemName: sub.problem?.name || 'Unknown',
        problemId: `${sub.problem?.contestId || ''}${sub.problem?.index || ''}`,
        timestamp: sub.creationTimeSeconds
      }))
    });
  } catch (error) {
    console.error('Codeforces submission error:', error.message);
    res.status(500).json({ error: 'Failed to fetch submissions' });
  }
});

// Get user submissions from LeetCode
app.get('/api/submissions/leetcode/:username', async (req, res) => {
  try {
    const { username } = req.params;
    const query = `
      query getUserProfile($username: String!) {
        matchedUser(username: $username) {
          submitStats {
            acSubmissionNum {
              difficulty
              count
            }
          }
          recentSubmissionList(limit: 20) {
            title
            titleSlug
            timestamp
            statusDisplay
          }
        }
      }
    `;
    
    const response = await axios.post('https://leetcode.com/graphql', {
      query,
      variables: { username }
    });
    
    const userData = response.data?.data?.matchedUser;
    if (!userData) {
      return res.status(400).json({ error: 'Invalid username' });
    }
    
    const recentSubmissions = userData.recentSubmissionList || [];
    const todayAccepted = recentSubmissions.filter(sub => {
      const submissionDate = new Date(parseInt(sub.timestamp) * 1000);
      const today = new Date();
      return sub.statusDisplay === 'Accepted' && 
             submissionDate.toDateString() === today.toDateString();
    });
    
    res.json({
      platform: 'LeetCode',
      username,
      todayCount: todayAccepted.length,
      recentAccepted: todayAccepted.map(sub => ({
        problemName: sub.title,
        problemId: sub.titleSlug,
        timestamp: parseInt(sub.timestamp)
      }))
    });
  } catch (error) {
    console.error('LeetCode submission error:', error.message);
    res.status(500).json({ error: 'Failed to fetch submissions' });
  }
});

// Get user submissions from CodeChef
app.get('/api/submissions/codechef/:username', async (req, res) => {
  try {
    const { username } = req.params;
    // Note: CodeChef doesn't have a public API for submissions
    // You'll need to use web scraping or official API with authentication
    res.json({
      platform: 'CodeChef',
      username,
      todayCount: 0,
      recentAccepted: [],
      note: 'CodeChef API requires authentication. Manual logging recommended.'
    });
  } catch (error) {
    console.error('CodeChef submission error:', error.message);
    res.status(500).json({ error: 'Failed to fetch submissions' });
  }
});

// Get user submissions from AtCoder
app.get('/api/submissions/atcoder/:username', async (req, res) => {
  try {
    const { username } = req.params;
    const response = await axios.get(`https://kenkoooo.com/atcoder/atcoder-api/v3/user/submissions?user=${username}&from_second=${Math.floor(Date.now() / 1000) - 86400}`);
    
    const submissions = response.data || [];
    const todayAccepted = submissions.filter(sub => {
      const submissionDate = new Date(sub.epoch_second * 1000);
      const today = new Date();
      return sub.result === 'AC' && 
             submissionDate.toDateString() === today.toDateString();
    });
    
    res.json({
      platform: 'AtCoder',
      username,
      todayCount: todayAccepted.length,
      recentAccepted: todayAccepted.slice(0, 10).map(sub => ({
        problemName: sub.problem_id,
        problemId: sub.problem_id,
        timestamp: sub.epoch_second
      }))
    });
  } catch (error) {
    console.error('AtCoder submission error:', error.message);
    res.status(500).json({ error: 'Failed to fetch submissions' });
  }
});

// Root route
app.get('/', (req, res) => {
  res.json({
    message: 'CP Tracker Contest API',
    endpoints: {
      '/contest/upcoming': 'Get upcoming contests',
      '/api/submissions/codeforces/:username': 'Get Codeforces submissions',
      '/api/submissions/leetcode/:username': 'Get LeetCode submissions',
      '/api/submissions/codechef/:username': 'Get CodeChef submissions',
      '/api/submissions/atcoder/:username': 'Get AtCoder submissions',
      '/api/stats/codeforces/:username': 'Get Codeforces total stats',
      '/api/stats/leetcode/:username': 'Get LeetCode total stats',
      '/api/stats/atcoder/:username': 'Get AtCoder total stats',
      '/api/stats/codechef/:username': 'Get CodeChef total stats',
      '/health': 'Health check'
    }
  });
});

// Get Codeforces total stats
app.get('/api/stats/codeforces/:username', async (req, res) => {
  try {
    const { username } = req.params;
    const response = await axios.get(`https://codeforces.com/api/user.status?handle=${username}`);
    
    if (response.data.status !== 'OK') {
      return res.status(400).json({ error: 'Invalid username or API error' });
    }
    
    const submissions = response.data.result || [];
    const uniqueSolved = new Set();
    
    submissions.forEach(sub => {
      if (sub.verdict === 'OK') {
        const problemId = `${sub.problem.contestId}-${sub.problem.index}`;
        uniqueSolved.add(problemId);
      }
    });
    
    res.json({
      platform: 'Codeforces',
      username,
      totalSolved: uniqueSolved.size,
      totalSubmissions: submissions.length,
      note: 'Count from rated contests only (API limitation - does not include practice/gym)'
    });
  } catch (error) {
    console.error('Codeforces stats error:', error.message);
    res.status(500).json({ error: 'Failed to fetch stats', totalSolved: 0 });
  }
});

// Get LeetCode total stats
app.get('/api/stats/leetcode/:username', async (req, res) => {
  try {
    const { username } = req.params;
    const query = `
      query getUserProfile($username: String!) {
        matchedUser(username: $username) {
          submitStats {
            acSubmissionNum {
              difficulty
              count
            }
          }
        }
      }
    `;
    
    const response = await axios.post('https://leetcode.com/graphql', {
      query,
      variables: { username }
    });
    
    const userData = response.data?.data?.matchedUser;
    if (!userData) {
      return res.status(400).json({ error: 'Invalid username', totalSolved: 0 });
    }
    
    const acStats = userData.submitStats?.acSubmissionNum || [];
    // Filter out "All" to avoid double counting (All = Easy + Medium + Hard)
    const breakdown = acStats.filter(stat => stat.difficulty !== 'All');
    const totalSolved = breakdown.reduce((sum, stat) => sum + (stat.count || 0), 0);
    
    res.json({
      platform: 'LeetCode',
      username,
      totalSolved: totalSolved,
      breakdown: acStats // Keep all entries for display including "All"
    });
  } catch (error) {
    console.error('LeetCode stats error:', error.message);
    res.status(500).json({ error: 'Failed to fetch stats', totalSolved: 0 });
  }
});

// Get AtCoder total stats
app.get('/api/stats/atcoder/:username', async (req, res) => {
  try {
    const { username } = req.params;
    
    // Scrape AtCoder user page
    const response = await axios.get(`https://atcoder.jp/users/${username}`, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      }
    });
    
    const $ = cheerio.load(response.data);
    
    // Find the table with user statistics
    let totalSolved = 0;
    $('table').each((i, table) => {
      const headerText = $(table).find('th').first().text().trim();
      if (headerText.includes('Rated Point Sum')) {
        // Find the "Submissions" row
        $(table).find('tr').each((j, row) => {
          const label = $(row).find('th').text().trim();
          if (label === 'Submissions') {
            const value = $(row).find('td').text().trim();
            const match = value.match(/(\d+)\s*\((\d+)\s*solved\)/);
            if (match) {
              totalSolved = parseInt(match[2]);
            }
          }
        });
      }
    });
    
    res.json({
      platform: 'AtCoder',
      username,
      totalSolved: totalSolved,
    });
  } catch (error) {
    console.error('AtCoder stats error:', error.message);
    res.json({
      platform: 'AtCoder',
      username: req.params.username,
      totalSolved: 0,
      note: 'Unable to fetch AtCoder stats'
    });
  }
});

// Get CodeChef total stats
app.get('/api/stats/codechef/:username', async (req, res) => {
  try {
    const { username } = req.params;
    
    // Scrape CodeChef user page
    const response = await axios.get(`https://www.codechef.com/users/${username}`, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      }
    });
    
    const $ = cheerio.load(response.data);
    
    // Find the "Fully Solved" section
    let totalSolved = 0;
    $('.rating-data-section').each((i, section) => {
      const header = $(section).find('h5').text().trim();
      if (header.includes('Fully Solved')) {
        const value = $(section).find('.rating-number').text().trim();
        totalSolved = parseInt(value) || 0;
      }
    });
    
    // Alternative: Look for problems solved in header-text-value
    if (totalSolved === 0) {
      $('.problems-solved .header-text-value').each((i, elem) => {
        const text = $(elem).text().trim();
        const num = parseInt(text);
        if (!isNaN(num) && num > totalSolved) {
          totalSolved = num;
        }
      });
    }
    
    res.json({
      platform: 'CodeChef',
      username,
      totalSolved: totalSolved,
    });
  } catch (error) {
    console.error('CodeChef stats error:', error.message);
    res.json({
      platform: 'CodeChef',
      username: req.params.username,
      totalSolved: 0,
      note: 'Unable to fetch CodeChef stats'
    });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 CP Tracker Backend running on http://localhost:${PORT}`);
  console.log(`📊 Contest API: http://localhost:${PORT}/contest/upcoming`);
});

module.exports = app;
