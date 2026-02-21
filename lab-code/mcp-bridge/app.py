from fastapi import FastAPI
from hybrid_retriever import hybrid_search

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/hybrid-search")
def do_hybrid_search(payload: dict):
    query = payload["query"]
    vector = payload["vector"]
    collection = payload.get("collection", "documents")
    k = payload.get("k", 5)

    results = hybrid_search(query, vector, collection, k)
    return {"results": results}
