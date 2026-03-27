FROM node:22-alpine AS deps

WORKDIR /app

COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm npm ci --no-audit --no-fund

FROM node:22-alpine AS builder

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY package.json package-lock.json ./
COPY index.html ./index.html
COPY postcss.config.mjs ./postcss.config.mjs
COPY vite.config.ts ./vite.config.ts
COPY public ./public
COPY src ./src

ARG VITE_Book_an_Enterprise_Discovery_Call_Redirect_URL="https://selecttime.appointy.com/appointy85l?service=srv_01KJCES1E93X3KBEW3GS7MHBRB"
ENV VITE_Book_an_Enterprise_Discovery_Call_Redirect_URL=${VITE_Book_an_Enterprise_Discovery_Call_Redirect_URL}

RUN npm run build

FROM nginx:1.27-alpine AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/conf.d/default.conf.bak
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
