---
name: Keviq
description: A reflection companion drawn as a held structure. Pale concrete and carbon, one red cord of tension.
colors:
  # Light theme (:root). Dark counterparts follow with the -dark suffix.
  tension-cord: "#d62828"
  tension-cord-ink: "#b41f1f"
  on-cord: "#ffffff"
  concrete: "#e7e5e1"
  concrete-recessed: "#dcd9d3"
  paper-ash: "#f2f1ed"
  carbon: "#0d0d0f"
  graphite: "#3e3f43"
  graphite-muted: "#5f5f63"
  hairline: "rgba(13,13,15,.16)"
  hairline-strong: "rgba(13,13,15,.32)"
  slack-ash: "#9a9a9a"
  rod: "#16171a"
  rod-highlight: "rgba(255,255,255,.22)"
  act-plate: "#0d0d0f"
  on-act: "#f2f1ed"
  question-plate: "#141518"
  on-plate: "#f2f1ed"
  on-plate-muted: "#a7a7ab"
  plate-hairline: "rgba(242,241,237,.18)"
  chrome: "#0d0d0f"
  on-chrome: "#f2f1ed"
  ghost-near: "#cfccc6"
  ghost-far: "#a9a6a0"
  scrim: "rgba(13,13,15,.42)"
  # Dark theme (prefers-color-scheme: dark without data-theme="light", or data-theme="dark")
  tension-cord-dark: "#ef4338"
  tension-cord-ink-dark: "#ff6a5f"
  on-cord-dark: "#0d0d0f"
  carbon-ground-dark: "#0f1012"
  carbon-recessed-dark: "#0a0a0c"
  panel-dark: "#18191c"
  concrete-ink-dark: "#e7e5e1"
  ink-2-dark: "#bdbcb8"
  ink-3-dark: "#8f8e8b"
  hairline-dark: "rgba(231,229,225,.14)"
  hairline-strong-dark: "rgba(231,229,225,.3)"
  slack-ash-dark: "#5d5e62"
  rod-dark: "#d9d6d0"
  act-plate-dark: "#e7e5e1"
  on-act-dark: "#0d0d0f"
  question-plate-dark: "#dcd9d3"
  on-plate-dark: "#0d0d0f"
  on-plate-muted-dark: "#4a4a4e"
  plate-hairline-dark: "rgba(13,13,15,.16)"
  chrome-dark: "#1e1f23"
  on-chrome-dark: "#e7e5e1"
  ghost-near-dark: "#1a1b1e"
  ghost-far-dark: "#2a2b30"
  scrim-dark: "rgba(0,0,0,.6)"
typography:
  display:
    fontFamily: "'Martian Mono', ui-monospace, Menlo, monospace"
    fontSize: "34px"
    fontWeight: 600
    lineHeight: 1
    letterSpacing: "-0.01em"
    fontVariation: "\"wdth\" 75"
  display-numeral:
    fontFamily: "'Martian Mono', ui-monospace, Menlo, monospace"
    fontSize: "40px"
    fontWeight: 600
    lineHeight: 1
    fontVariation: "\"wdth\" 75"
  question:
    fontFamily: "'Martian Mono', ui-monospace, Menlo, monospace"
    fontSize: "29px"
    fontWeight: 600
    lineHeight: 1.08
    letterSpacing: "-0.01em"
    fontVariation: "\"wdth\" 75"
  headline:
    fontFamily: "'Martian Mono', ui-monospace, Menlo, monospace"
    fontSize: "24px"
    fontWeight: 560
    lineHeight: 1.08
    letterSpacing: "0"
    fontVariation: "\"wdth\" 75"
  title:
    fontFamily: "'Hanken Grotesk', 'Helvetica Neue', Arial, sans-serif"
    fontSize: "20px"
    fontWeight: 700
    lineHeight: 1.15
    letterSpacing: "-0.01em"
  body:
    fontFamily: "'Hanken Grotesk', 'Helvetica Neue', Arial, sans-serif"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.5
  writing:
    fontFamily: "'Hanken Grotesk', 'Helvetica Neue', Arial, sans-serif"
    fontSize: "22px"
    fontWeight: 400
    lineHeight: 1.38
  helper:
    fontFamily: "'Hanken Grotesk', 'Helvetica Neue', Arial, sans-serif"
    fontSize: "13px"
    fontWeight: 400
    lineHeight: 1.45
  chip:
    fontFamily: "'Hanken Grotesk', 'Helvetica Neue', Arial, sans-serif"
    fontSize: "16px"
    fontWeight: 600
    lineHeight: 1.15
  button:
    fontFamily: "'Martian Mono', ui-monospace, Menlo, monospace"
    fontSize: "12px"
    fontWeight: 500
    letterSpacing: "0.08em"
  section-label:
    fontFamily: "'Martian Mono', ui-monospace, Menlo, monospace"
    fontSize: "12px"
    fontWeight: 600
    letterSpacing: "0.12em"
  label:
    fontFamily: "'Martian Mono', ui-monospace, Menlo, monospace"
    fontSize: "11px"
    fontWeight: 400
    letterSpacing: "0.08em"
  kept-words:
    fontFamily: "'Kalam', 'Bradley Hand', 'Segoe Print', cursive"
    fontSize: "20px"
    fontWeight: 400
    lineHeight: 1.22
rounded:
  hair: "2px"
  frame: "3px"
  control: "4px"
  sheet: "10px"
  node: "50%"
spacing:
  xs: "6px"
  sm: "8px"
  md: "10px"
  lg: "14px"
  inset: "16px"
  gutter: "22px"
  section: "32px"
components:
  button-primary:
    backgroundColor: "{colors.act-plate}"
    textColor: "{colors.on-act}"
    typography: "{typography.button}"
    rounded: "0"
    padding: "0 44px 0 22px"
    height: "52px"
  button-primary-small:
    backgroundColor: "{colors.act-plate}"
    textColor: "{colors.on-act}"
    typography: "{typography.button}"
    padding: "0 36px 0 14px"
    height: "40px"
  button-secondary:
    backgroundColor: "{colors.paper-ash}"
    textColor: "{colors.carbon}"
    typography: "{typography.button}"
    rounded: "{rounded.control}"
    padding: "0 22px"
    height: "52px"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.carbon}"
    typography: "{typography.button}"
    rounded: "{rounded.control}"
    padding: "0 22px"
    height: "52px"
  chip-guess:
    backgroundColor: "{colors.paper-ash}"
    textColor: "{colors.carbon}"
    typography: "{typography.chip}"
    rounded: "{rounded.frame}"
    padding: "10px 16px"
    height: "44px"
  chip-confirmed:
    backgroundColor: "{colors.act-plate}"
    textColor: "{colors.on-act}"
    typography: "{typography.chip}"
    rounded: "{rounded.frame}"
    padding: "10px 16px 10px 30px"
    height: "44px"
  chip-open:
    backgroundColor: "transparent"
    textColor: "{colors.graphite-muted}"
    typography: "{typography.label}"
    rounded: "{rounded.frame}"
    padding: "10px 16px"
    height: "44px"
  question-plate:
    backgroundColor: "{colors.question-plate}"
    textColor: "{colors.on-plate}"
    typography: "{typography.question}"
    padding: "22px 22px 20px"
  card-panel:
    backgroundColor: "{colors.paper-ash}"
    textColor: "{colors.carbon}"
    rounded: "{rounded.frame}"
    padding: "16px"
  input-line:
    backgroundColor: "{colors.concrete}"
    textColor: "{colors.carbon}"
    typography: "{typography.body}"
    rounded: "{rounded.frame}"
    padding: "0 16px"
    height: "54px"
  tab-bar:
    backgroundColor: "{colors.chrome}"
    textColor: "{colors.on-chrome}"
    typography: "{typography.label}"
    rounded: "{rounded.control}"
    padding: "4px"
  tab-bar-item:
    textColor: "{colors.on-chrome}"
    rounded: "{rounded.hair}"
    padding: "0 20px"
    height: "48px"
  toast:
    backgroundColor: "{colors.chrome}"
    textColor: "{colors.on-chrome}"
    typography: "{typography.label}"
    rounded: "{rounded.frame}"
    padding: "12px 18px"
  badge:
    backgroundColor: "{colors.act-plate}"
    textColor: "{colors.on-act}"
    typography: "{typography.label}"
    rounded: "{rounded.hair}"
    padding: "0 10px"
    height: "28px"
  icon-button:
    backgroundColor: "transparent"
    textColor: "{colors.carbon}"
    rounded: "{rounded.node}"
    size: "44px"
---

# Design System: Keviq

## Overview

**Creative North Star: "Tension & Release"**

What a person carries between therapy sessions is tension; what helps is release. Keviq draws the day as a held structure: pale concrete ground, carbon rods and plates, grey slack cords, and a single red cord that marks where the tension is and which action is about to be taken. The question of the day is a clipped carbon plate held on the frame. Habits are nodes. The week is a column of entries separated by hairlines. Keviq's proposals hang slack until the person pulls them taut.

The world is flat and engineered. Depth comes from inverting the ground (a carbon plate on concrete, or a concrete plate on carbon), from 1px hairlines, and from chamfered corners. Shadow is used only on the few elements that float. Type speaks in two voices: condensed monospace caps for anything measured, labelled, pressed or asked, and a humanist grotesk for anything read as a sentence. A hand face appears only on words the person chose to keep.

Both themes are first-class and tokenised the same way. Light is concrete ground with carbon ink. Dark is carbon ground with concrete ink, and the question plate flips to concrete so the question stays the inverse of the ground. The world refuses the calm-wellness default (pastel cards, soft gradients) and the flat black and white slabs Keviq used before.

**Key Characteristics:**
- One red cord per surface region, used for tension and the next action. Never for error.
- Slack/taut state law: a guess is dashed and tilted, a confirmed choice is a solid plate with a red node, an empty slot is an open dashed frame.
- Condensed Martian Mono caps (wdth 75) for labels, data, buttons and questions. Hanken Grotesk for sentences.
- Chamfered plates, 1px hairline frames, circular nodes. Corners are 2 to 4px everywhere else.
- A generative tensegrity column (rods, red cords, slack cords, nodes) that breathes on an 8s cycle.

## Colors

Two neutrals with warm grey undertones, carbon and concrete, trade places between themes. A single saturated red is the only chromatic hue.

Every role is a CSS custom property on `:root`, redefined in a `prefers-color-scheme: dark` block guarded by `:root:not([data-theme="light"])` and again under `:root[data-theme="dark"]`. Components read the role and never the hex value, so one rule renders correctly in both themes. The table maps each role to its light and dark frontmatter token.

| Role (CSS var) | Light token | Dark token |
|---|---|---|
| `--red` | tension-cord | tension-cord-dark |
| `--red-ink` | tension-cord-ink | tension-cord-ink-dark |
| `--on-red` | on-cord | on-cord-dark |
| `--bg` | concrete | carbon-ground-dark |
| `--bg-2` | concrete-recessed | carbon-recessed-dark |
| `--panel` | paper-ash | panel-dark |
| `--ink` / `--ink-2` / `--ink-3` | carbon / graphite / graphite-muted | concrete-ink-dark / ink-2-dark / ink-3-dark |
| `--line` / `--line-2` | hairline / hairline-strong | hairline-dark / hairline-strong-dark |
| `--slack` | slack-ash | slack-ash-dark |
| `--rod` / `--rod-hi` | rod / rod-highlight | rod-dark / transparent |
| `--act` / `--on-act` | act-plate / on-act | act-plate-dark / on-act-dark |
| `--plate` / `--on-plate` / `--on-plate-2` / `--plate-line` | question-plate / on-plate / on-plate-muted / plate-hairline | question-plate-dark / on-plate-dark / on-plate-muted-dark / plate-hairline-dark |
| `--chrome` / `--on-chrome` | chrome / on-chrome | chrome-dark / on-chrome-dark |
| `--ghost-1` / `--ghost-2` | ghost-near / ghost-far | ghost-near-dark / ghost-far-dark |
| `--scrim` | scrim | scrim-dark |

### Primary
- **Tension Cord** (tension-cord, lifted to tension-cord-dark on carbon): used for strokes, not fills. It appears as the cord and node on primary plates, the node on confirmed chips, the tab underline, the hairline leader on the question plate, section and plate label dots, focus rings, the caret, text selection, the recording dot and the stop control, the hold-to-finish fill, calendar pips, meter fills, and the cords of the tensegrity art.
- **Cord Ink** (tension-cord-ink / tension-cord-ink-dark): the red used for text, such as a large pattern statistic, a source line in the Guide, or a strip annotation. At text sizes the base red does not reach 4.5:1 contrast on concrete, so any red text uses this role instead.

### Neutral
- **Concrete** (concrete): the light ground for every screen and pane.
- **Recessed Concrete** (concrete-recessed): the ground for the Reset pane, recording, the session and the Guide stack, which are the quieter surfaces. In dark mode the matching role is the deepest carbon.
- **Paper Ash** (paper-ash): the raised panel used by cards, sheets, the composer, unconfirmed chips and inputs.
- **Carbon** (carbon): ink, the primary action plate and the chrome (tab bar and toast) in light mode. In dark mode concrete takes the ink and action-plate roles, and the chrome becomes a lifted carbon (chrome-dark).
- **Graphite / Graphite Muted** (graphite, graphite-muted): secondary text, helper sentences, labels and the dashed border of a guess chip.
- **Hairline / Hairline Strong** (hairline, hairline-strong): row dividers and frames (`--line`), and control borders and inset frames (`--line-2`).
- **Slack Ash** (slack-ash): the slack cords and knots in the tensegrity art. It is a stroke colour only and is never used for text.
- **Rod** (rod / rod-dark): the compression members in the art. They are carbon on concrete and concrete on carbon, with a thin white highlight in light mode only.
- **Question Plate** (question-plate / question-plate-dark): the ground for the question card, the prompt plate in compose, the therapy date plate, the experiment card and the dark small-win card.
- **Ghost Near / Far** (ghost-near, ghost-far): the stacked plates behind the question card and the recording card, showing that more questions wait underneath.

### Named Rules
**The One Cord Rule.** Red is tension and the action about to be taken. Use it for a cord, a node, a leader line or an underline, and never for error, warning or validation copy. Fill a large area with red only while an action is being committed, such as the hold-to-finish fill or the stop-recording control.

**The Plate Flip Rule.** The question plate is always the inverse of the ground: carbon on concrete in light mode, concrete (question-plate-dark) on carbon in dark mode. The primary action plate follows the ink colour. Never hard-code either plate.

**The Role-Not-Hex Rule.** Components consume `--bg`, `--ink`, `--act`, `--plate` and the other roles. A literal hex value in a component rule is allowed only in the fixed-palette share posters.

## Typography

**Display Font:** Martian Mono at width 75 (falling back to ui-monospace, Menlo)
**Body Font:** Hanken Grotesk (falling back to Helvetica Neue, Arial)
**Label/Mono Font:** Martian Mono, at width 75 for display and at the default width for small labels
**Kept-words Font:** Kalam (falling back to Bradley Hand, Segoe Print)

**Character:** The condensed mono caps read like stencilled measurements on a structural drawing and carry every label, number, button and question. The grotesk is warm and plain, and it carries anything the person reads or writes as a sentence.

The shipped scale has 17 sizes (11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 22, 24, 26, 29, 34, 40, 46px) and 5 weights (400, 500, 560, 600, 700). Nothing is set below 11px.

### Hierarchy
- **Display** (Mono 600, wdth 75, uppercase, 34px, lh 1, -0.01em): large screen titles such as the Reset name at 40px. The breath phase word in the session is 46px.
- **Display Numeral** (Mono 600, wdth 75, 40px, lh 1 to 1.05): counts and statistics, such as "since last session" numbers and pattern stats. Mono 26px is the smaller numeral size on habit cards.
- **Question** (Mono 600, wdth 75, uppercase, 29px, lh 1.08, balanced wrapping): today's question on its plate. The recording card uses 26px, the compose prompt uses 20px at weight 560, and the poster line uses 22px.
- **Headline** (Mono 560, wdth 75, uppercase, 24px, lh 1.08): in-screen headlines such as "Noticed" on Review and the pattern detail title.
- **Title** (Hanken 700, 19 to 26px, lh 1.12 to 1.15, -0.01em to -0.015em): sentence-case headings that are read as phrases, such as the Today greeting (19px), card titles (20 to 24px) and the Guide card question (26px).
- **Body** (Hanken 400, 16px, lh 1.5): reading text, messages and entry text. Keep lines to about 34 to 40ch in cards.
- **Writing** (Hanken 400, 22px, lh 1.38, ruled with `--line`): the compose textarea. Entry detail text is 20px at lh 1.45.
- **Helper** (Hanken 400, 13px, lh 1.45, graphite-muted): explanatory sentences under controls.
- **Chip** (Hanken 600, 16px, lh 1.15): the words inside habit, noticed and event chips.
- **Button** (Mono 500, 12px, 0.08em, uppercase): every button label. Small buttons use 11px.
- **Section Label** (Mono 600, 12px, 0.12em, uppercase): section rails, drawn with a hollow node before the text and a hairline after it that runs to the edge.
- **Label** (Mono 400 to 500, 11px, 0.06 to 0.1em, uppercase): dates, metadata, field labels, tags and toasts.
- **Kept Words** (Kalam 400, 20px, lh 1.22): the text of small-win cards only.

### Named Rules
**The Two Voices Rule.** If it is measured, labelled, pressed or asked, set it in mono caps. If it is a sentence someone reads, set it in Hanken. Never set a helper sentence in mono.

**The Kept Words Rule.** Kalam appears only on words the person chose to keep, which today means small wins. It never appears in UI chrome, headings or Keviq's own voice.

**The 11px Floor Rule.** No text is set below 11px. Condensed width is reserved for 20px and above. Mono at 11 to 12px stays at the default width with 0.06 to 0.12em tracking so it remains legible.

## Layout

The app is a single phone column (designed at 410x864). Screen gutters are 22px for headers and copy, and cards and rows sit 16px from the edge. Sections open with a 32px top margin and a mono section rail. Inside groups, the rhythm steps through 6, 8, 10 and 14px. Lists are rows separated by hairlines, not stacked cards. Grids of cards (habits, resets) use two columns with a 10px gap. Small wins use a two-column masonry layout.

Primary navigation is a two-cell floating tab bar (Today and Reset) centred 26px above the bottom edge. The two panes sit on a horizontal pager that also responds to swipes. A 120px fade at the bottom of each pane, in the pane's own ground colour, keeps content clear of the tab bar. Detail screens slide in from the right, and the screen underneath shifts 22% to the left. Composer and recording screens rise from the bottom. Sheets rise from the bottom over a scrim and take up to 88% of the height.

The prototype's presentation stage (a rail, a device frame and notes, with breakpoints at 1180, 760 and 480px) is demo scaffolding and not part of the product system.

## Elevation & Depth

The system is flat and depth is tonal. Layers separate through ground inversion (a plate against the ground), recessed and raised neutrals (`--bg-2` below the ground, `--panel` above it), and 1px inset hairlines (`box-shadow: inset 0 0 0 1px var(--line)`). Stacked ghost plates behind the question and recording cards suggest depth through offset, not blur.

### Shadow Vocabulary
- **Float** (`--shadow`: light `0 18px 40px -22px rgba(13,13,15,.45)`, dark `0 18px 40px -20px rgba(0,0,0,.8)`): only for chrome that floats above content (the tab bar and toast) and for the top card of the Guide stack.
- **Sheet lift** (`0 -1px 0 var(--line-2), 0 -20px 50px -30px rgba(0,0,0,.5)`): the upper edge of a bottom sheet.
- **Poster drop** (`0 30px 60px -30px rgba(0,0,0,.55), 0 0 0 1px var(--line)`): the share-card preview only.
- **Node ring** (`0 0 0 3-4px <ground>, 0 0 0 4-5px var(--red)`): a red ring set apart from the element by a gap in the ground colour. It marks the current item on the Reset arc, a selected feeling bubble and event dots.

### Named Rules
**The Hairline Before Shadow Rule.** Separate with a hairline or a plate flip first. A shadow is allowed only when an element floats over scrolling content.

## Shapes

The form language is structural. Key plates are chamfered with `clip-path`: the question card, compose prompt, recording card, Guide cards, experiment card, therapy date plate and pattern hero clip their top-right corner. The chamfer scales with the plate, from 10px on ghost plates to 16px on small plates, 20px on cards and 22px on the question and recording cards. Primary action plates are chamfered on two opposite corners (12px, or 14px on the Reset Start plate). A red hairline runs diagonally across the question card's chamfer.

Everything else is framed with square-ish corners: 2px for tags, segmented buttons, filter chips and toggles; 3px for chips, cards, rows and inputs; 4px for secondary buttons, the composer, the tab bar and inline panels. The only larger radius is the 10px top corners on bottom sheets. Circles are reserved for nodes, including icon buttons, the mic button, avatars, arc stops, calendar day numbers and every dot.

Nodes are 5 to 7px circles, filled red when taut or active and outlined or dashed when slack or empty. They appear at the start of labels, section rails and chips, and at the corners of icons that are in an on state.

## Components

### Buttons
Plates you pull, not pills you tap.
- **Shape:** the primary plate is chamfered on two corners (12px). All other buttons are framed with a 4px radius.
- **Primary:** an act plate (carbon in light, concrete in dark) with on-act text in mono caps, 52px tall (40px when small). The right padding is widened to 44px to hold the cord glyph, which is an 18px red hairline tilted -28 degrees leading to a 6px red node. On the question plate the primary is drawn in on-plate colour, so it inverts again with the same cord. The Reset Start plate is 62px tall with a 26px cord.
- **Hover / Focus / Active:** pressing scales to 0.97. Focus draws a 1.5px red outline with a 3px offset. Disabled buttons drop to 0.35 opacity.
- **Secondary:** a paper-ash button with a 1px hairline-strong border that turns to ink on hover.
- **Ghost:** the same as secondary with a transparent background.
- **Link:** mono caps at 11px followed by a 14px red hairline that extends to 22px on hover.
- **Hold:** a primary plate whose background fills with red from left to right over 1.2s while it is held.

### Chips
Keviq's proposals hang slack until the person pulls them taut.
- **Guess (slack):** paper-ash background, a 1px dashed graphite-muted border, a slight tilt (`--tilt`), and Hanken 600 at 16px with a minimum height of 44px.
- **Confirmed (taut):** a solid act plate with no tilt and a 7px red node on the left that springs from scale 0. The transform, border and background all transition on the spring curve over 0.6s.
- **Open (blank):** transparent, with a dashed hairline-strong border, mono caps at 11px and graphite-muted text. On hover the border turns red.
- **Habit toggle:** a solid hairline frame that fills to the act plate when pressed and shows a red check.
- **Filter and segmented controls:** 34px mono caps controls with a 2px radius. The pressed state is the act plate. Filters that Keviq suggested start dashed and become solid once picked.

### Cards / Containers
- **Corner Style:** 3px, or a chamfer on the plates listed under Shapes.
- **Background:** paper-ash panels on the concrete ground. Plates use the question-plate colour.
- **Shadow Strategy:** an inset 1px hairline, with no drop shadow (see Elevation & Depth).
- **Border:** hairline, or hairline-strong for cards you can interact with. The border turns to ink on hover.
- **Internal Padding:** 14 to 16px for cards and 20 to 22px for plates.

### Inputs / Fields
- **Style:** 54px tall, with a concrete background, a 1px hairline-strong border, a 3px radius and Hanken at 16 to 17px. The chat input uses paper-ash.
- **Focus:** the border shifts to ink, and the caret is always red.
- **Field labels:** mono caps at 11px followed by a hairline that runs to the edge.

### Navigation
- **Tab bar:** a two-cell chrome bar with a 4px radius, a 4px inset and a plate-hairline border, carrying the Float shadow. Items are 48px tall, mono caps at 11px with 0.1em tracking and 0.62 opacity. The active item is at full opacity on a 9% tint and has a red 1px underline that scales in from the left.
- **Top bar:** 44px circular icon buttons with a hairline-strong frame and a centred mono caps title at 12px. The on state is an act-plate circle with a red corner node.
- **Section rail:** a hollow 7px node, a mono caps label at 12px with 0.12em tracking, and a hairline running to the right edge, with an optional link at the end.

### Toast
A chrome capsule with a 3px radius, 11px mono caps, a red icon and the Float shadow. It rises from 100px above the bottom.

### Tensegrity Column (signature)
A generative SVG `column({levels, twist, lean, wide})` builds a stack of crossed carbon rods (9px stroke, round caps), red tension cords (1.1px), slack-ash cords with knots, 4.2px nodes filled with the pane colour and outlined in ink, and a dashed red axis. When breathing, the body scales vertically to 1.06 and the slack cords tighten to red over an 8s cycle (`cubic-bezier(.45,0,.55,1)`). The same generator draws the Reset hero, the pattern stat, habit and idea thumbnails, and the share posters. The session uses a rods-and-cords body figure instead: on each 4s inhale it lengthens to 1.035, its slack cords turn red and its cords thicken to 1.6px, while a dashed red breath line with end nodes rises 190px. Annotations attach to the art with a red target node, a 30px leader and a framed label.

### Share Poster
A 9:16 card with a fixed palette that does not follow the app theme. There are three palettes: Carbon (a #0d0d0f ground, concrete rods and a #ef4338 cord), Concrete (a #e7e5e1 ground, carbon rods and a #d62828 cord) and Cord (a #d62828 ground, carbon rods and an #f2f1ed cord). The poster carries a mono caps line at 22px and a column drawing.

### Motion
- **Screen and pane transitions:** `cubic-bezier(.16,1,.3,1)` over 0.5 to 0.55s.
- **Slack to taut, and chip arrival:** `cubic-bezier(.3,1.5,.45,1)` over 0.5 to 0.7s. Chips arrive from 20px above with their tilt multiplied by four.
- **Breathing:** 8s for the column and 4s phases in the session.
- **Reduced motion:** when `prefers-reduced-motion: reduce` is set, animations and transitions collapse to near zero, animated SVGs pause, and staged delays shorten.

## Do's and Don'ts

### Do:
- **Do** read every colour through its role variable (`--bg`, `--ink`, `--act`, `--plate`, `--red`) so both themes hold without extra rules.
- **Do** draw every Keviq proposal slack (dashed, tilted) and animate it to taut (a solid act plate, no tilt, a red node) when the person confirms it. Apply this to noticed chips, event chips, suggested filters and the "Suggested for right now" / "Your pick" tag.
- **Do** end primary action plates with the red cord and node, and chamfer two corners (12px).
- **Do** use mono caps at 11px for dates, metadata and field labels, and Hanken 13px in graphite-muted for any explanatory sentence.
- **Do** separate list rows with hairlines and start sections with the node-and-hairline rail.
- **Do** use tension-cord-ink whenever red is text.

### Don't:
- **Don't** use red for errors, warnings or validation messages.
- **Don't** set sentences in mono. Toasts and labels stay short.
- **Don't** use Kalam outside small wins.
- **Don't** set text below 11px, or condense mono below 20px.
- **Don't** add drop shadows to cards in the page flow. Use an inset hairline or a plate flip.
- **Don't** hard-code plate or ground colours in components. Only share posters carry fixed palettes.
- **Don't** use pastel cards, soft gradients or wellness-style rounded pills. Corners stay at 2 to 4px, circles are only for nodes, and the 10px sheet top is the only exception.
