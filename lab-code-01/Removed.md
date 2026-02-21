# Open Search was Removed from Docker Compose

```yaml
  # ---
  # --- NEW: OpenSearch (optional but integrated cleanly) ---
  # ---

  opensearch:
    image: opensearchproject/opensearch:2.17.0
    container_name: opensearch
    environment:
      - discovery.type=single-node
      - DISABLE_SECURITY_PLUGIN=true
      - OPENSEARCH_JAVA_OPTS=-Xms1g -Xmx1g
      - USER_AGENT=Mozilla/5.0 (compatible; OpenWebUI)
    ports:
      - "9200:9200"
    volumes:
      - ${BASE_DIR}/opensearch/data:/usr/share/opensearch/data
    restart: unless-stopped

  opensearch-dashboards:
    image: opensearchproject/opensearch-dashboards:2.17.0
    container_name: opensearch-dashboards
    environment:
      - OPENSEARCH_HOSTS=http://opensearch:9200
      - DISABLE_SECURITY_DASHBOARDS_PLUGIN=true
    ports:
      - "5601:5601"
    depends_on:
      - opensearch
    restart: unless-stopped
```

Open Search is an exterprise level indexing tool, it is not required by me.
