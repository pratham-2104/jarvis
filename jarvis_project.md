# Jarvis — AI-Powered Content Creation Automation

## What is Jarvis?

Jarvis is an internal automation tool that replicates the human content creation process using AI agents. Instead of a human team researching, brainstorming, and scripting content, AI agents handle each step of the pipeline — while the user stays in control at key decision points.

The goal is to produce high-quality, on-brand social media content (reels, posts, scripts) for applications, with minimal manual effort.

---

## How It Works

The pipeline follows the same steps a human content team would take — research, ideation, scripting — but each role is handled by a dedicated AI agent. All agents communicate through a central orchestrator, never directly with each other.

### Pipeline Overview

```
App Workspace (files, brand data)
         ↓
  [Research Agent]
  Understands the app + finds trending content ideas
         ↓
  [Idea Generation Agent]
  Selects or generates the best content idea
         ↓
       USER GATE
  ✅ Approved → continue
  ❌ Feedback → loop back to Idea Generation Agent
         ↓
  [Script Agent]
  Writes the full content script using brand guidelines
         ↓
       USER GATE
  ✅ Approved → done
  ❌ Feedback → loop back (to Script Agent or earlier)
         ↓
  [Content Creation Agent] ← Phase 2 (not in initial build)
  Generates actual reel/post based on the script
         ↓
       USER GATE
  ✅ Approved → publish-ready
  ❌ Feedback → loop back
```

---

## Agents

### 1. Research Agent

**Responsibility:** Understand the application and find relevant, trending content ideas.

**Inputs:**
- App knowledge files from the workspace (user flows, feature docs, how the app works)
- Application name / context

**What it does:**
- Reads and understands the app from uploaded documents
- Uses Tavily to search for trending content ideas related to the app's category/niche
- Looks at what type of content is performing well for similar apps

**Output:**
- App summary (what it is, who it's for, key features, tone)
- List of trending content angles and ideas with context

---

### 2. Idea Generation Agent

**Responsibility:** Take research output and produce a single, well-defined content idea to move forward with.

**Inputs:**
- Output from Research Agent (app summary + trending ideas)
- Content history database (what has already been created for this app — to avoid repetition)

**What it does:**
- Analyses the research
- Selects the strongest idea OR generates a new one based on gaps
- Checks against content history to ensure no repeats
- Structures the idea clearly

**Output:**
- Content idea
- Target audience
- Platform (Instagram Reel, YouTube Short, etc.)
- Tone / angle
- Key message
- Why this idea works

**Gate:** User reviews the idea. If approved, pipeline continues. If not, user gives feedback and agent loops to generate a new idea.

---

### 3. Script Agent

**Responsibility:** Turn the approved idea into a complete, ready-to-use content script.

**Inputs:**
- Approved idea output from Idea Generation Agent
- Brand data from workspace (fonts, colors, tone of voice, visual style, CTA preferences)

**What it does:**
- Writes the hook, body, and CTA of the script
- Follows brand guidelines for tone and language
- Formats the script clearly (shot directions, text overlays, voiceover, etc.)

**Output:**
- Full content script
- Shot list or scene breakdown
- Caption + hashtags
- Any on-screen text suggestions following brand fonts/colors

**Gate:** User reviews the script. If approved, pipeline is complete (for Phase 1). If not, user gives feedback and agent refines or loops back further.

---

### 4. Content Creation Agent *(Phase 2 — not in initial build)*

**Responsibility:** Generate the actual visual content (reel, post, graphic) based on the approved script.

**Inputs:**
- Approved script from Script Agent
- Brand data (colors, fonts, visual style)

**What it does:**
- Generates video, reel, or static post based on the script
- Applies brand visual language

**Output:**
- Ready-to-use content file

**Gate:** User reviews the content. Approved → publish-ready. Rejected → feedback loop.

---

## Orchestrator

The orchestrator is the central brain of Jarvis. Every agent communicates only through the orchestrator — no agent talks directly to another.

**Responsibilities:**
- Receives user input (which app, what to create)
- Loads the correct application workspace
- Calls agents in sequence
- Manages user gates — pauses pipeline, collects feedback, decides where to loop back
- Passes context and history between agents
- Tracks state across the full pipeline run

**Why this architecture:**
- Predictable and debuggable — one central point of control
- Easy to add or modify agents without breaking the chain
- Loops and feedback are handled cleanly without agents needing to know about each other

---

## Application Workspaces

Each application has its own workspace containing all the context agents need.

```
/workspaces
  /app-name
    /knowledge      → docs about the app (user flows, features, how it works)
    /brand          → brand guidelines (colors, fonts, tone, CTA style)
    /history        → record of all ideas and scripts generated so far
```

- **Knowledge files** are used by the Research Agent to understand the app
- **Brand files** are used by the Script Agent to write on-brand content
- **History** is used by the Idea Generation Agent to avoid repeating content

Workspace files are managed manually — someone drops the relevant files into the correct folder when setting up a new app or updating existing content. No upload UI is needed. When starting a pipeline run, the user selects which application workspace to use and the orchestrator loads that workspace and injects the right context into each agent.

---

## User's Role

The user is not removed from the process — they are kept in control at every creative decision point.

| Stage | User Action |
|---|---|
| Start | Select application workspace, initiate pipeline |
| After Idea Generation | Approve idea or give feedback |
| After Script Writing | Approve script or give feedback |
| After Content Creation *(Phase 2)* | Approve content or give feedback |

Feedback at any gate is passed back to the orchestrator, which decides which agent to re-invoke and with what context.

---

## Tools & Technology

| Component | Tool |
|---|---|
| Trend Research | Tavily API |
| Agent Intelligence | LLM |
| Orchestrator | Java |
| File Storage | Manual folder drop per workspace |
| Content History | JSON / SQLite per workspace |

---

## Summary

Jarvis automates the content creation process by replacing the human team with AI agents, while keeping the user in control at every key decision. The pipeline mirrors exactly how a human team works — research, ideate, script, create — with a clean orchestrator managing the flow and feedback loops ensuring quality at every step.
