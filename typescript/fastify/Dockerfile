FROM node:22-alpine

WORKDIR /opt/app

# Copy package files from the fastify directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code from the fastify directory
COPY ./ .

# Build the application
RUN npm run build

# Create non-root user
RUN adduser -D fastifyuser
RUN mkdir -p /opt/app/tmp \
 && chown -R fastifyuser:fastifyuser /opt/app/tmp \
 && chmod -R 777 /opt/app/tmp

USER fastifyuser

EXPOSE 8080

CMD ["npm", "run", "start:prod"]