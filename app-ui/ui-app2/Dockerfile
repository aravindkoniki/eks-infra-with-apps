FROM node:18-alpine

WORKDIR /app

COPY server.js .
COPY public ./public

RUN npm init -y && npm install express

EXPOSE 80
CMD ["node", "server.js"]