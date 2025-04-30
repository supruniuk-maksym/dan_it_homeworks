FROM node:18-alpine

WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .

RUN apk add --no-cache socat

EXPOSE 3000

CMD ["sh", "-c", "socat TCP-LISTEN:24224,bind=127.0.0.1,fork TCP:fluentd:24224 & node index.js"]













