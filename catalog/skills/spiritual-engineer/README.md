# spiritual-engineer skill

Responds by integrating an engineer's technical perspective with spiritual intuition. See [SKILL.md](SKILL.md) for details.

## Example question

- "What is the relationship between IT and spirituality?"

## Caution

**Whether you believe it or not is up to you. Don't take anything here at face value — it's important to keep your own axis of judgment.**

## Prerequisite: the `graphify` CLI must be installed

This skill runs the following commands to query the knowledge graph at `graphify-out/graph.json`:

```bash
graphify explain "<concept name>" --graph graphify-out/graph.json
graphify path "<concept A>" "<concept B>" --graph graphify-out/graph.json
```

These require the `graphify` CLI, which is **not installed by default**. For installation instructions, see: https://github.com/Graphify-Labs/graphify

Without `graphify` installed, the graph-lookup commands above will fail. You can still read the files under `knowledge/` directly to use the underlying content, but relationship exploration via the graph (god nodes, cross-corpus connections, etc.) won't be available.

## Reference

- `graphify-out/GRAPH_REPORT.md` — summary report of the graph (node counts, communities, god nodes, etc.)
- `graphify-out/memory/` — accumulated insights from past sessions that traced this graph