FROM node:24-bookworm

WORKDIR /app

RUN apt-get update && apt-get install -y 
git 
curl 
python3 
build-essential 
ca-certificates 
openssl

RUN npm install -g pnpm

COPY . .

RUN NODE_OPTIONS=--max-old-space-size=2048 pnpm install --frozen-lockfile

RUN pnpm build:docker || true
RUN pnpm ui:build || true
RUN pnpm qa:lab:build || true

EXPOSE 18789

CMD ["node", "openclaw.mjs", "gateway", "--bind", "0.0.0.0"]