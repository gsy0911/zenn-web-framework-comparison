import fastify from 'fastify';
import cors from '@fastify/cors';

const app = fastify({ logger: true });

// Get PREFIX from environment variable, similar to other implementations
const prefix = process.env.PREFIX || '';

// Register CORS plugin
app.register(cors, {
  origin: true
});

// Health check endpoint
app.get(`${prefix}/healthcheck`, async (request, reply) => {
  return { status: 'success' };
});

// User endpoint - main endpoint used in benchmarks
app.get(`${prefix}/user`, async (request, reply) => {
  return { status: 'success' };
});

// Start server
const start = async () => {
  try {
    await app.listen({ port: 8080, host: '0.0.0.0' });
    console.log(`Fastify server running on http://0.0.0.0:8080`);
    if (prefix) {
      console.log(`Global prefix: ${prefix}`);
    }
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
};

start();