# Build stage
FROM node:22-alpine AS builder

WORKDIR /opt/app

# Copy package files and install dependencies
COPY package.json ./
RUN npm install

# Copy source code and build
COPY ./ .
RUN npm run build

# Production stage
FROM node:22-alpine AS production

WORKDIR /opt/app

# Copy package.json and install only production dependencies
COPY package.json ./
RUN npm install --only=production && npm cache clean --force

# Copy built application from builder stage
COPY --from=builder /opt/app/dist ./dist

# Create non-root user
RUN adduser -D expressuser
RUN mkdir -p /opt/app/tmp \
 && chown -R expressuser:expressuser /opt/app/tmp \
 && chmod -R 777 /opt/app/tmp

USER expressuser

EXPOSE 8080

CMD ["npm", "run", "start:prod"]