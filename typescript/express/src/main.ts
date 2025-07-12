import express from 'express';
import cors from 'cors';

const app = express();

// Get PREFIX from environment variable, similar to other implementations
const prefix = process.env.PREFIX || '';

// Enable CORS for cross-origin requests
app.use(cors());

// JSON middleware
app.use(express.json());

// Health check endpoint
app.get(`${prefix}/healthcheck`, (req, res) => {
  res.json({ status: 'success' });
});

// User endpoint - main endpoint used in benchmarks
app.get(`${prefix}/user`, (req, res) => {
  res.json({ status: 'success' });
});

// Start server
const port = 8080;
const host = '0.0.0.0';

app.listen(port, host, () => {
  console.log(`Express server running on http://${host}:${port}`);
  if (prefix) {
    console.log(`Global prefix: ${prefix}`);
  }
});