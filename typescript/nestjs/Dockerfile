FROM node:22-alpine

WORKDIR /opt/app

# Copy package files from the nestjs directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code from the nestjs directory
COPY ./ .

# Build the application
RUN npm run build

# Create non-root user
RUN adduser -D nestjsuser
RUN mkdir -p /opt/app/tmp \
 && chown -R nestjsuser:nestjsuser /opt/app/tmp \
 && chmod -R 777 /opt/app/tmp

USER nestjsuser

EXPOSE 8080

CMD ["npm", "run", "start:prod"]
