# Somedaze UX Design Language

This document translates the product philosophy into a practical UX system. Every design decision should trace back to one of the six product-defining areas below.

## 1. Philosophy

These principles are the filter for product, UX, content, and motion decisions. When a design question comes up, resolve it through these principles instead of preference.

### Guided

The product should gently help people move forward when they are stuck.

- Design should suggest the next smallest useful step.
- Guidance should feel timely, not constant.
- The interface should reduce decision fatigue, not add more choices.
- Guided moments should support action, not interrupt it.

Use this principle when deciding:

- whether to offer a prompt or stay quiet
- whether a flow needs structure
- whether an empty state should suggest a next step

### Warm

The product should feel human, calm, and emotionally safe.

- Copy should feel kind without sounding performative.
- Visual choices should reduce tension, not dramatize it.
- Feedback should acknowledge effort without turning progress into pressure.
- The product should feel like companionship, not evaluation.

Use this principle when deciding:

- how success, missed days, or low-energy states are expressed
- whether feedback sounds clinical, cheerful, or grounded
- how much emotional language is appropriate

### Incomplete Is Valid

Partial participation still counts. A skipped or lighter day is not failure.

- The system must never frame imperfection as a broken streak of worth.
- Reduced effort, changed plans, and pauses are all legitimate outcomes.
- UX should normalize fluctuation instead of punishing it.
- Progress should be represented as continuity of care, not uninterrupted perfection.

Use this principle when deciding:

- whether to label something as missed, skipped, failed, or paused
- whether a user can save partial progress
- how tracking states appear in UI

### Small As Default

The default interaction should be manageable even on low-capacity days.

- Start with one action, one choice, or one question.
- Keep cognitive load low at every step.
- Let users expand only when they want more depth.
- The smallest version of the experience should still feel complete.

Use this principle when deciding:

- how much to show on a screen
- whether a flow should be multi-step
- whether onboarding, reflection, or planning needs to be shorter

### Principle Test

Before shipping a UX decision, ask:

1. Does this guide without crowding?
2. Does this feel warm rather than corrective?
3. Does this respect incomplete participation as valid?
4. Is the smallest version still useful?

If the answer is no to any of these, the design needs revision.

## 2. Voice & Tone

The voice should create space rather than pressure. The most important copy rule in this system is:

**Questions open space. Statements close it.**

Use questions when the user may feel uncertainty, guilt, resistance, or emotional friction. Avoid definitive statements that sound evaluative or prescriptive.

### Core Voice Attributes

- Gentle, not fragile
- Clear, not clinical
- Warm, not overly familiar
- Calm, not cheerful on command
- Supportive, not congratulatory by default

### Copy Rules

- Prefer invitations over directives.
- Prefer neutral language over performance language.
- Avoid guilt-loaded framing.
- Never imply the user has failed the product.
- Acknowledge effort without assigning moral value to consistency.

### Rewrite Direction

#### When the user misses a day

Instead of:

- You broke your streak.
- You missed yesterday.
- Time to get back on track.

Use:

- Want to pick this back up today?
- Yesterday stayed open. How does today feel?
- Ready for a small restart?

#### When the user has low energy

Instead of:

- Let’s be productive anyway.
- You can still do more.
- Don’t give up now.

Use:

- What feels doable today?
- Want to choose the lighter version?
- Is today a full, partial, or rest day?

#### When the user completes something

Instead of:

- Amazing job.
- You crushed it.
- Perfect consistency.

Use:

- That counts.
- You showed up today.
- Want to leave a note about how it felt?

#### When the user skips

Instead of:

- Skipped
- Missed
- Incomplete

Use:

- Left open
- Skipped today
- Not today

#### When prompting reflection

Instead of:

- Tell us why you failed.
- What went wrong?
- Explain the problem.

Use:

- Want to name what today felt like?
- Was anything getting in the way?
- What would make this easier next time?

## 3. Color System

Color should lower emotional pressure, not intensify it.

### Primary Rule

**Skipped is gray, not red.**

Red implies failure, warning, or wrongdoing. Gray communicates neutrality. This is one of the most important color choices in the system because it directly protects users from perfectionist framing.

### Emotional Color Roles

- Warm neutral: the base of the interface; calm, soft, stable
- Gentle accent: used for active guidance and selected states
- Success tone: quiet confirmation, never loud celebration
- Gray neutral: skipped, paused, optional, secondary, or unfilled states
- Red reserve: only for actual destructive or high-risk actions, never for missed habits or incomplete participation

### State Color Guidance

- Completed: calm success tone
- Partial: softer version of the success/accent family
- Skipped: neutral gray
- Active prompt: warm accent
- Secondary metadata: muted neutral
- Error or destructive action: reserved red

### Color Principles

- Avoid high-contrast alarm combinations for everyday tracking states.
- Never encode emotional judgment through saturation alone.
- Ensure all states remain distinguishable without relying only on color.
- Prioritize softness over gamified brightness.

## 4. Components

These are the highest-sensitivity patterns in the system. They should feel obvious to use, emotionally safe, and lightweight.

### 3-State Completion Row

Purpose: allow users to represent reality without collapsing everything into done or failed.

States:

- Done
- Partial
- Skipped

Behavior:

- All three states should feel equally selectable.
- Skipped should look neutral, not punitive.
- Partial should feel valid, not secondary in meaning.
- The component should avoid language like failed, missed, or broke.

Design intent:

- Communicates that consistency can include variation.
- Prevents all-or-nothing thinking.
- Supports continuity without shame.

### Energy Check-In

Purpose: help the product adapt to the user’s current capacity before asking for effort.

Common options:

- Low
- Medium
- High

Behavior:

- Should appear early when useful, but not on every screen.
- Selecting low energy should reduce complexity and expectations.
- Responses should shape what is offered next.
- The check-in should feel optional and light, not diagnostic.

Design intent:

- Makes the experience responsive instead of demanding.
- Helps the product meet users where they are.

### Emotional Anchor Prompt

Purpose: offer a gentle reflective moment that helps users name their state without forcing disclosure.

Prompt examples:

- What feels true today?
- Want to name the mood of this moment?
- What are you carrying right now?

Behavior:

- Keep prompts open-ended and easy to skip.
- Limit to a single emotionally meaningful question at a time.
- Do not chain multiple reflection prompts in one sequence.
- Treat responses as supportive context, not performance data.

Design intent:

- Encourages emotional honesty without pressure.
- Builds trust through restraint.

### Habit Context Row

Purpose: add lightweight situational context that helps users understand patterns without over-logging.

Possible context:

- Time of day
- Energy
- Location
- Friction level
- Mood

Behavior:

- Keep context optional.
- Make inputs fast and compact.
- Capture only the context that improves future guidance.
- Avoid turning each completion into a form.

Design intent:

- Supports pattern recognition without burden.
- Helps future guidance feel relevant and personal.

## 5. Motion

Motion should communicate clarity, softness, and confidence. It should never introduce pressure.

### Timing Tokens

- `80ms`: immediate state feedback
- `200ms`: standard transitions and UI responses
- `350ms`: reflective or more atmospheric transitions

### Motion Principles

- Motion should explain, not entertain.
- Immediate interactions should feel responsive and calm.
- More reflective moments can move slightly slower, but never sluggishly.
- Use subtle motion to support focus and transitions, not to celebrate compliance.

### Good Uses Of Motion

- State changes in completion rows
- Expanding a guided prompt
- Gentle entrance of a single reflective question
- Smooth reduction of UI complexity after a low-energy check-in

### What We Never Animate

- Shame motion: shake, jiggle, or bounce after skipped actions or invalid states
- Anxiety motion: counters, streaks, or score-like numbers animating on every open
- Pressure motion: flashing reminders, pulsing urgency, countdowns for non-essential actions
- Over-reward motion: confetti or exaggerated celebration for routine completion

## 6. User Journey

Guided moments should appear with care. The experience should feel supportive, not chatty.

### Core Rule

**No more than one guided moment per session.**

This keeps the product from becoming noisy, repetitive, or emotionally demanding.

### When Guided Moments Should Fire

- At first-use moments when the next action is unclear
- After a skipped period, when a gentle restart prompt would help
- When low energy is expressed and the interface can simplify meaningfully
- When a user reaches a reflective pause point and one prompt can support continuation

### When Guided Moments Should Not Fire

- Multiple times in the same session
- Immediately after a user has already made a choice
- During routine flows that are already clear
- In ways that block progress or force emotional interaction

### Journey Design Rules

- Guidance should appear at moments of uncertainty, not constantly.
- Reflection should be offered, never required.
- Returning after time away should feel open, not corrective.
- The product should prioritize re-entry over recovery narratives.

## Design Decision Filter

If a proposed feature increases pressure, introduces judgment, or rewards perfectionism, it is likely misaligned.

Examples:

- A streak reset counter conflicts with Warm and Incomplete Is Valid.
- A neutral skipped state supports emotional safety.
- A smaller default task list supports Small As Default.
- A single restart question supports Guided better than a multi-step recovery flow.

## Summary

This design language is not about making the interface soft for its own sake. It is about building a product that reduces shame, supports real-life inconsistency, and helps users continue without feeling judged.

The standard for every screen, interaction, and line of copy is simple:

- guide gently
- stay warm
- make room for incomplete participation
- keep the default small
