const http = require('http');
const url = require('url');

const PORT = process.env.PORT || 3000;
const RELEASE_ID = process.env.RELEASE_ID || 'blue-v1';
const APP_POOL = 'blue';

let chaosMode = false;

const server = http.createServer((req, res) => {
  const { pathname } = url.parse(req.url, true);

  // Simulate failure if chaosMode is on
  if (chaosMode && pathname !== '/chaos/stop') {
    res.statusCode = 500;
    return res.end('💥 Simulated Blue failure');
  }

  // Health check
  if (pathname === '/healthz') {
    res.statusCode = 200;
    return res.end('OK');
  }

  // Version info
  if (pathname === '/version') {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'application/json');
    res.setHeader('X-App-Pool', APP_POOL);
    res.setHeader('X-Release-Id', RELEASE_ID);
    return res.end(JSON.stringify({
      app: APP_POOL,
      version: RELEASE_ID
    }));
  }

  // Chaos mode toggle
  if (pathname === '/chaos/start') {
    chaosMode = true;
    res.statusCode = 200;
    return res.end('Chaos mode enabled for Blue');
  }

  if (pathname === '/chaos/stop') {
    chaosMode = false;
    res.statusCode = 200;
    return res.end('Chaos mode disabled for Blue');
  }

  // Default route
  res.statusCode = 200;
  res.end('💙 Blue App - Version 1');
});

server.listen(PORT, () => {
  console.log(`💙 Blue app running on port ${PORT}`);
});

