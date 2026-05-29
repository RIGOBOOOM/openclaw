#!/bin/sh
set -eu

export OPENCLAW_HOME="${OPENCLAW_HOME:-/data}"
export OPENCLAW_STATE_DIR="${OPENCLAW_STATE_DIR:-/data/.openclaw}"
export OPENCLAW_WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-/data/workspace}"
export OPENCLAW_CONFIG_PATH="${OPENCLAW_CONFIG_PATH:-/data/.openclaw/openclaw.json}"
export OPENCLAW_GATEWAY_PORT="${PORT:-8080}"

mkdir -p "$OPENCLAW_STATE_DIR" "$OPENCLAW_WORKSPACE_DIR"

if [ ! -f "$OPENCLAW_CONFIG_PATH" ]; then
  touch "$OPENCLAW_CONFIG_PATH"
fi

node <<'NODE'
const fs = require('fs');
const path = process.env.OPENCLAW_CONFIG_PATH;
const port = Number(process.env.PORT || process.env.OPENCLAW_GATEWAY_PORT || 8080);
const token = process.env.OPENCLAW_GATEWAY_TOKEN || 'change-this-token';
const model = process.env.OPENCLAW_PRIMARY_MODEL || 'anthropic/claude-sonnet-4-5';
const publicOrigin =
  process.env.OPENCLAW_PUBLIC_ORIGIN ||
  (process.env.RAILWAY_PUBLIC_DOMAIN ? `https://${process.env.RAILWAY_PUBLIC_DOMAIN}` : '');

let config = {};
try {
  const raw = fs.readFileSync(path, 'utf8').trim();
  if (raw) config = JSON.parse(raw);
} catch {
  config = {};
}

const allowedOrigins = [
  'http://localhost:8080',
  'http://127.0.0.1:8080',
  publicOrigin,
].filter(Boolean);

config.gateway = {
  ...(config.gateway || {}),
  mode: 'local',
  bind: 'lan',
  port,
  auth: {
    ...((config.gateway || {}).auth || {}),
    mode: 'token',
    token,
  },
  controlUi: {
    ...((config.gateway || {}).controlUi || {}),
    allowInsecureAuth: true,
    allowedOrigins: [...new Set([
      ...(((config.gateway || {}).controlUi || {}).allowedOrigins || []),
      ...allowedOrigins,
    ])],
  },
};

config.agents = {
  ...(config.agents || {}),
  defaults: {
    ...(((config.agents || {}).defaults) || {}),
    workspace: process.env.OPENCLAW_WORKSPACE_DIR || '/data/workspace',
    model: {
      ...((((config.agents || {}).defaults || {}).model) || {}),
      primary: model,
    },
  },
};

config.env = {
  ...(config.env || {}),
  ANTHROPIC_API_KEY: process.env.ANTHROPIC_API_KEY || '',
};

fs.mkdirSync(require('path').dirname(path), { recursive: true });
fs.writeFileSync(path, JSON.stringify(config, null, 2));
NODE

exec openclaw gateway --bind lan --port "$OPENCLAW_GATEWAY_PORT" --allow-unconfigured
