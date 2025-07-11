FROM node:18-bullseye AS builder

WORKDIR /opt/app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:18-bullseye-slim AS production

WORKDIR /opt/app

# Install only production dependencies
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copy built application from builder stage
COPY --from=builder /opt/app/dist ./dist

# Create non-root user
RUN useradd -m nestjsuser
RUN mkdir -p /opt/app/tmp \
 && chown -R nestjsuser:nestjsuser /opt/app/tmp \
 && chmod -R 777 /opt/app/tmp

USER nestjsuser

EXPOSE 8080

CMD ["npm", "run", "start:prod"]