FROM ghcr.io/openclaw/openclaw:latest

ENV NODE_ENV=production
ENV OPENCLAW_HOME=/data
ENV OPENCLAW_STATE_DIR=/data/.openclaw
ENV OPENCLAW_WORKSPACE_DIR=/data/workspace
ENV OPENCLAW_CONFIG_PATH=/data/.openclaw/openclaw.json

EXPOSE 8080

COPY railway-start.sh /usr/local/bin/openclaw-railway-start
RUN chmod +x /usr/local/bin/openclaw-railway-start

CMD ["openclaw-railway-start"]
