const http = require('http');
const url = require('url');

const PORT = process.env.PORT || 3000;
const RELEASE_ID = process.env.RELEASE_ID || 'green-v1';
const APP_POOL = 'green';

let chaosMode = false;

const server = http.createServer((req, res) => {
  const { pathname } = url.parse(req.url, true);

  if (chaosMode && pathname !== '/chaos/stop') {
    res.statusCode = 500;
    return res.end('💥 Simulated Green failure');
  }

  if (pathname === '/healthz') {
    res.statusCode = 200;
    return res.end('OK');
  }

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

  if (pathname === '/chaos/start') {
    chaosMode = true;
    res.statusCode = 200;
    return res.end('Chaos mode enabled for Green');
  }

  if (pathname === '/chaos/stop') {
    chaosMode = false;
    res.statusCode = 200;
    return res.end('Chaos mode disabled for Green');
  }

  res.statusCode = 200;
  res.end('💚 Green App - Version 1');
});

server.listen(PORT, () => {
  console.log(`💚 Green app running on port ${PORT}`);
});


