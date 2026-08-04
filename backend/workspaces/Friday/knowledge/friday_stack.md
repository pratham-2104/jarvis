# FRIDAY — Content Pipeline · Java Quarkus Stack

Multi-agent AI content pipeline · Local · Text input only

---

## AI Models

Single model running locally via Ollama, serving three agents with different system prompts. Only one agent runs at a time, keeping peak memory usage around 9 GB.

| Model | Purpose | Size |
|---|---|---|
| `qwen3:14b` | Single model powering all three agents | ~9 GB |
| `nomic-embed-text` | Generates embeddings for pgvector similarity search | ~274 MB |

## Agents

Three agents powered by the same model, each with a dedicated system prompt and context.

| Agent | Role |
|---|---|
| Agent 1 — Researcher | Finds latest trending content via Tavily web search |
| Agent 2 — Strategist | Compares ideas against past posts, picks the best unused one |
| Agent 3 — Creator | Generates final content based on the chosen idea |

---

## Infrastructure

| Tool | Purpose |
|---|---|
| **Docker** | Runs PostgreSQL container locally |
| **PostgreSQL 16** | Main database — pipeline state and run history |
| **pgvector extension** | Vector similarity search inside Postgres |
| **Ollama** | Local runtime for all AI models |

---

## Java Libraries

| Library | Purpose |
|---|---|
| `quarkus-rest` | REST API server — handles text input endpoint |
| `quarkus-reactive-pg-client` | Async non-blocking PostgreSQL driver |
| `quarkus-hibernate-reactive-panache` | ORM layer for pipeline state and run history |
| `pgvector-java` | pgvector type support for Java |
| `quarkus-jackson` | JSON parsing and serialization |
| `Mutiny` | Reactive async layer — built into Quarkus |
| `langchain4j-ollama` | LangChain4j integration for Ollama model calls |
| `langchain4j-core` | Core LangChain4j abstractions — prompts, responses, chains |

---

## Build Tool

| Tool | Purpose |
|---|---|
| **Maven** | Dependency management and project build |

---

## Java Standard Library

No external dependency needed · included with Java:

`java.util.concurrent.Semaphore` · `java.util.List` · `java.util.Map` · `java.util.Optional` · `java.time`

---

## External Services

| Service | Purpose | Cost |
|---|---|---|
| **Tavily** | Web search for M1 to find trending content | 1000 searches / month free · permanent |

---

## Summary

| | |
|---|---|
| Total Java libraries | 8 |
| External API keys | 1 (Tavily) |
| Cloud dependencies | 0 |
| Databases | 1 (PostgreSQL + pgvector · single Docker container) |
| Model in RAM | 1 — qwen3:14b (~9 GB) |
| Runtime mode | JVM |

**Everything runs on your local machine · Zero ongoing cost.**
