FROM ghcr.io/openclaw/openclaw:latest

USER root

ENV NODE_ENV=production
ENV OPENCLAW_HOME=/data
ENV OPENCLAW_STATE_DIR=/data/.openclaw
ENV OPENCLAW_WORKSPACE_DIR=/data/workspace
ENV OPENCLAW_CONFIG_PATH=/data/.openclaw/openclaw.json

EXPOSE 8080

COPY railway-start.sh /tmp/openclaw-railway-start.sh

CMD ["sh", "/tmp/openclaw-railway-start.sh"]
