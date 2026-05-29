# OpenClaw personal en Railway

Esta rama existe para usar OpenClaw desde Android sin compilar el proyecto completo.

## Railway

1. Crear servicio desde GitHub usando esta rama: `railway-personal`.
2. Agregar un Volume montado en `/data`.
3. Activar Public Networking en puerto `8080`.
4. Agregar variables:

```env
PORT=8080
SETUP_PASSWORD=CAMBIA_ESTA_CLAVE
OPENCLAW_GATEWAY_TOKEN=CAMBIA_ESTE_TOKEN_LARGO
OPENCLAW_HOME=/data
OPENCLAW_STATE_DIR=/data/.openclaw
OPENCLAW_WORKSPACE_DIR=/data/workspace
OPENCLAW_CONFIG_PATH=/data/.openclaw/openclaw.json
ANTHROPIC_API_KEY=sk-ant-...
```

5. Abrir:

```text
https://TU-DOMINIO.up.railway.app/setup
```

## Por que esta rama

El Dockerfile oficial compila OpenClaw desde fuente y puede fallar en Railway por BuildKit, memoria, pnpm, Bun o dependencias nativas. Esta rama usa la imagen preconstruida `ghcr.io/openclaw/openclaw:latest` y solo arranca el gateway con `--bind lan`, que es lo que Railway necesita.
