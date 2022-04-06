FROM node:12.22.10-slim
RUN npm install

WORKDIR /app
EXPOSE 3000
CMD [ "node", "index.js" ]
