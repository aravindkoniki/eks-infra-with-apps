FROM node:18-alpine

WORKDIR /app

# Copy package.json first to leverage Docker layer caching
COPY package.json .

# Install dependencies
RUN npm install

# Copy application files
COPY server.js .
COPY public ./public

# Create a non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Change ownership of the app directory
RUN chown -R nextjs:nodejs /app
USER nextjs

EXPOSE 8080
CMD ["node", "server.js"]