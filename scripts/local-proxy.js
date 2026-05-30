#!/usr/bin/env node
// Local CORS proxy for development. Forwards requests to api.beens.kr.
// Usage: node scripts/local-proxy.js
// Then run Flutter: flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080

const http = require('http');
const https = require('https');

const TARGET_HOST = 'api.beens.kr';
const PORT = 8080;

const server = http.createServer((req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const options = {
    hostname: TARGET_HOST,
    port: 443,
    path: req.url,
    method: req.method,
    headers: { ...req.headers, host: TARGET_HOST },
  };

  const proxy = https.request(options, (proxyRes) => {
    const headers = { ...proxyRes.headers };
    delete headers['access-control-allow-origin'];
    res.writeHead(proxyRes.statusCode, headers);
    proxyRes.pipe(res, { end: true });
  });

  proxy.on('error', (err) => {
    console.error(`[proxy error] ${err.message}`);
    res.writeHead(502);
    res.end('Bad Gateway');
  });

  req.pipe(proxy, { end: true });
});

server.listen(PORT, () => {
  console.log(`Proxy → https://${TARGET_HOST}  (listening on http://localhost:${PORT})`);
  console.log(`flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:${PORT}`);
});
