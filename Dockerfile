# ---- build ----
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json tsconfig*.json ./
RUN npm install --no-audit --no-fund
COPY src ./src
COPY public ./public
RUN npm run build

# ---- runtime (no dev dependencies, non-root, read-only friendly) ----
FROM node:22-alpine
ENV NODE_ENV=production PORT=3000 DB_PATH=/data/orders.db
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/public ./public
COPY data/products.json ./data/products.json
COPY package.json ./
RUN mkdir -p /data && chown node:node /data
USER node
VOLUME /data
EXPOSE 3000
HEALTHCHECK --interval=15s --timeout=3s --retries=3 CMD wget -qO- http://127.0.0.1:3000/api/health || exit 1
CMD ["node", "--disable-warning=ExperimentalWarning", "dist/server/main.js"]
