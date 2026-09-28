# syntax=docker/dockerfile:1.7
FROM node:24.15.0-alpine@sha256:d1b3b4da11eefd5941e7f0b9cf17783fc99d9c6fc34884a665f40a06dbdfc94f AS dependencies
WORKDIR /workspace
COPY package.json package-lock.json ./
COPY apps/api/package.json apps/api/package.json
COPY apps/admin/package.json apps/admin/package.json
RUN npm ci --workspace @servipronto/api --include-workspace-root

FROM dependencies AS development
COPY apps/api apps/api
WORKDIR /workspace/apps/api
RUN npm run db:generate
EXPOSE 3000
CMD ["sh", "-c", "npm run db:deploy && npm run db:seed && npm run start:dev"]

FROM dependencies AS build
COPY apps/api apps/api
WORKDIR /workspace/apps/api
RUN npm run db:generate && npm run build

FROM node:24.15.0-alpine@sha256:d1b3b4da11eefd5941e7f0b9cf17783fc99d9c6fc34884a665f40a06dbdfc94f AS production
ENV NODE_ENV=production
WORKDIR /workspace
COPY package.json package-lock.json ./
COPY apps/api/package.json apps/api/package.json
COPY apps/admin/package.json apps/admin/package.json
RUN npm ci --omit=dev --workspace @servipronto/api --include-workspace-root && npm cache clean --force
COPY --from=build /workspace/node_modules/.prisma /workspace/node_modules/.prisma
COPY --from=build /workspace/apps/api/dist apps/api/dist
COPY --from=build /workspace/apps/api/prisma apps/api/prisma
WORKDIR /workspace/apps/api
EXPOSE 3000
CMD ["node", "dist/main.js"]
