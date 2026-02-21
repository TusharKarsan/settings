import requests
from qdrant_client import QdrantClient

OS_URL = "http://opensearch:9200"
QDRANT_URL = "http://qdrant:6333"

qdrant = QdrantClient(url=QDRANT_URL)

def hybrid_search(query, vector, collection="documents", k=5):
    # --- 1. Vector search (semantic) ---
    qdrant_hits = qdrant.search(
        collection_name=collection,
        query_vector=vector,
        limit=k
    )

    # --- 2. Keyword search (BM25) ---
    os_query = {
        "size": k,
        "query": {
            "multi_match": {
                "query": query,
                "fields": ["content"]
            }
        }
    }

    os_hits = requests.post(
        f"{OS_URL}/{collection}/_search",
        json=os_query
    ).json()["hits"]["hits"]

    # --- 3. Merge + rerank ---
    merged = {}

    for h in qdrant_hits:
        merged[h.id] = {
            "content": h.payload["content"],
            "score": float(h.score) * 1.0  # semantic weight
        }

    for h in os_hits:
        doc_id = h["_id"]
        score = float(h["_score"]) * 0.7  # keyword weight
        if doc_id in merged:
            merged[doc_id]["score"] += score
        else:
            merged[doc_id] = {
                "content": h["_source"]["content"],
                "score": score
            }

    # Sort by combined score
    ranked = sorted(merged.values(), key=lambda x: x["score"], reverse=True)
    return ranked[:k]
    