<!-- 0669c493-8220-4390-ae3a-552442be7676 -->
---
todos:
  - id: "live-plan"
    content: "Write the independent Rails and Cursor cloud plan to screensteps-live/es-dev-plan.md"
    status: pending
  - id: "docker-plan"
    content: "Write the independent local service-provider plan to screensteps-dev-docker/es-dev-plan.md"
    status: pending
isProject: false
---
# Elasticsearch Development Plans

## `screensteps-live`
Create [`es-dev-plan.md`](/Users/drewprice/Documents/dev/screensteps/screensteps-live/es-dev-plan.md) covering:
- Add `ELASTICSEARCH_URL` and optional `ELASTICSEARCH_ANALYTICS_URL` for development/test, defaulting to local HTTP.
- Preserve the existing staging/production credentials, TLS, and client configuration paths unchanged.
- Remove development and Cursor cloud dependence on generated `config/elasticsearch.yml`, including updates to `script/setup`, `script/cloud/start_services.sh`, README, and `AGENTS.md`.
- Define migration compatibility for existing ignored YAML files and verification for host-based development, Cursor cloud, search/indexing, analytics, and index templates.

## `screensteps-dev-docker`
Create [`es-dev-plan.md`](/Users/drewprice/Documents/dev/screensteps/screensteps-dev-docker/es-dev-plan.md) covering:
- Treat the repository as an independent optional provider of MySQL and Elasticsearch services.
- Disable Elasticsearch security for local use, bind published Elasticsearch access to localhost, retain version pinning, persistence, resource limits, and health checks.
- Convert health checks and optional Kibana connectivity to HTTP.
- Remove credential rotation, certificate extraction, fingerprint synchronization, and all mutation of `screensteps-live` files.
- Expose connection details through documentation/environment output only, while retaining host and container usage instructions and validating service isolation.

The two documents will explicitly define the repository boundary: `screensteps-live` consumes a URL; `screensteps-dev-docker` provides one possible server implementation.