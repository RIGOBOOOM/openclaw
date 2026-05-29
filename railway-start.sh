#!/bin/sh
set -eu

export OPENCLAW_HOME="${OPENCLAW_HOME:-/data}"
export OPENCLAW_STATE_DIR="${OPENCLAW_STATE_DIR:-/data/.openclaw}"
export OPENCLAW_WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-/data/workspace}"
export OPENCLAW_CONFIG_PATH="${OPENCLAW_CONFIG_PATH:-/data/.openclaw/openclaw.json}"
export OPENCLAW_GATEWAY_PORT="${PORT:-8080}"

mkdir -p "$OPENCLAW_STATE_DIR" "$OPENCLAW_WORKSPACE_DIR"

if [ ! -f "$OPENCLAW_CONFIG_PATH" ]; then
  node <<'NODE'
const fs = require('fs');
const path = process.env.OPENCLAW_CONFIG_PATH;
const port = Number(process.env.PORT || process.env.OPENCLAW_GATEWAY_PORT || 8080);
const token = process.env.OPENCLAW_GATEWAY_TOKEN || 'change-this-token';
const model = process.env.OPENCLAW_PRIMARY_MODEL || 'anthropic/claude-sonnet-4-5';

const config = {
  gateway: {
    mode: 'local',
    bind: 'lan',
    port,
    auth: {
      mode: 'token',
      token,
    },
  },
  agents: {
    defaults: {
      workspace: process.env.OPENCLAW_WORKSPACE_DIR || '/data/workspace',
      model: {
        primary: model,
      },
    },
  },
  env: {
    ANTHROPIC_API_KEY: process.env.ANTHROPIC_API_KEY || '',
  },
};

fs.mkdirSync(require('path').dirname(path), { recursive: true });
fs.writeFileSync(path, JSON.stringify(config, null, 2));
NODE
fi

exec openclaw gateway --bind lan --port "$OPENCLAW_GATEWAY_PORT" --allow-unconfigured
