FROM ghcr.io/openclaw/openclaw:latest

ENV NODE_ENV=production
ENV OPENCLAW_HOME=/data
ENV OPENCLAW_STATE_DIR=/data/.openclaw
ENV OPENCLAW_WORKSPACE_DIR=/data/workspace
ENV OPENCLAW_CONFIG_PATH=/data/.openclaw/openclaw.json

EXPOSE 8080

CMD ["sh", "-c", "mkdir -p \"$OPENCLAW_STATE_DIR\" \"$OPENCLAW_WORKSPACE_DIR\" && openclaw gateway --bind lan --port ${PORT:-8080} --allow-unconfigured"]
