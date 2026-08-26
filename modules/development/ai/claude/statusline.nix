{
  pkgs,
  omc,
  ...
}:
pkgs.writers.writePython3Bin "statusline" {
  flakeIgnore = [
    "E501"
    "E722"
    "W503"
  ];
}
# py
''
  """Claude Code Status Line — Dreambase Flat
  Single-line adaptation of @kyleledbetter's Dreambase Panel: the same
  context bar, stats, and repo sections in a terracotta Claude-brand
  palette, rendered on one line instead of a boxed three-row panel.
  """

  import json
  import os
  import subprocess
  import sys
  import time

  data = json.load(sys.stdin)

  # ── Extract data ──────────────────────────────────────────
  model = data.get("model", {}).get("display_name", "—")
  model_id = data.get("model", {}).get("id", "")
  project_dir = data.get("workspace", {}).get("project_dir", ".")
  current_dir = data.get("workspace", {}).get("current_dir", ".")
  pct = int(float(data.get("context_window", {}).get("used_percentage") or 0))
  ctx_size = int(data.get("context_window", {}).get("context_window_size") or 200000)
  input_tokens = int(data.get("context_window", {}).get("total_input_tokens") or 0)
  output_tokens = int(data.get("context_window", {}).get("total_output_tokens") or 0)
  cost_usd = float(data.get("cost", {}).get("total_cost_usd") or 0)
  duration_ms = int(data.get("cost", {}).get("total_duration_ms") or 0)
  lines_added = int(data.get("cost", {}).get("total_lines_added") or 0)
  lines_removed = int(data.get("cost", {}).get("total_lines_removed") or 0)
  exceeds_200k = data.get("exceeds_200k_tokens", False)
  vim_mode = data.get("vim", {}).get("mode", "")

  # ── ANSI Colors ───────────────────────────────────────────
  R = "\033[0m"
  B = "\033[1m"
  D = "\033[2m"

  # Claude brand rust / terracotta
  RUST = "\033[38;5;173m"
  RUST_B = "\033[38;5;209m"
  RUST_D = "\033[38;5;131m"
  RUST_BG = "\033[48;5;52m"

  # Functional
  GRN = "\033[38;5;34m"
  LIME = "\033[38;5;118m"
  YEL = "\033[38;5;220m"
  ORG = "\033[38;5;208m"
  RED = "\033[38;5;196m"
  CYN = "\033[38;5;81m"
  BLU = "\033[38;5;69m"
  PUR = "\033[38;5;141m"
  WHT = "\033[38;5;255m"
  GRY = "\033[38;5;243m"


  # ── Formatters ────────────────────────────────────────────
  def fmt_tok(n):
      if n >= 1_000_000:
          return f"{n / 1_000_000:.1f}M"
      if n >= 1_000:
          return f"{n / 1_000:.1f}K"
      return str(n)


  def fmt_dur(ms):
      s = ms // 1000
      h, rem = divmod(s, 3600)
      m, sec = divmod(rem, 60)
      if h:
          return f"{h}h {m}m"
      if m:
          return f"{m}m {sec}s"
      return f"{sec}s"


  def truncate(s, maxlen=18):
      return s[: maxlen - 1] + "…" if len(s) > maxlen else s


  # ── Progress bar ──────────────────────────────────────────
  BAR_W = 22
  BLOCKS = " ▏▎▍▌▋▊▉█"

  if pct >= 95:
      bar_clr = RED
      status_label = f"{RED}{B}CRITICAL{R}"
  elif pct >= 85:
      bar_clr = ORG
      status_label = f"{ORG}HIGH{R}"
  elif pct >= 70:
      bar_clr = YEL
      status_label = f"{YEL}MODERATE{R}"
  elif pct >= 50:
      bar_clr = LIME
      status_label = f"{LIME}OK{R}"
  else:
      bar_clr = GRN
      status_label = f"{GRN}GOOD{R}"

  eighths = pct * BAR_W * 8 // 100
  full = eighths // 8
  partial = eighths % 8
  empty = BAR_W - full - (1 if partial else 0)

  bar = "█" * full
  if partial:
      bar += BLOCKS[partial]
  bar += "░" * empty

  ctx_label = "1M" if ctx_size >= 1_000_000 else "200K"
  warn = f" {RED}{B}⚠{R}" if exceeds_200k else ""

  # ── Git info (cached for perf) ────────────────────────────
  CACHE = "/tmp/claude-sl-git"


  def git_info():
      try:
          if time.time() - os.path.getmtime(CACHE) < 5:
              with open(CACHE) as f:
                  p = f.read().strip().split("|")
                  if len(p) == 4:
                      return p
      except (OSError, ValueError):
          pass
      try:
          br = subprocess.run(
              ["git", "-C", project_dir, "branch", "--show-current"],
              capture_output=True,
              text=True,
              timeout=2,
          ).stdout.strip()
          if not br:
              return ["", "0", "0", "0"]
          st = len(
              subprocess.run(
                  ["git", "-C", project_dir, "diff", "--cached", "--numstat"],
                  capture_output=True,
                  text=True,
                  timeout=2,
              )
              .stdout.strip()
              .splitlines()
          )
          mo = len(
              subprocess.run(
                  ["git", "-C", project_dir, "diff", "--numstat"],
                  capture_output=True,
                  text=True,
                  timeout=2,
              )
              .stdout.strip()
              .splitlines()
          )
          ut = len(
              subprocess.run(
                  [
                      "git",
                      "-C",
                      project_dir,
                      "ls-files",
                      "--others",
                      "--exclude-standard",
                  ],
                  capture_output=True,
                  text=True,
                  timeout=2,
              )
              .stdout.strip()
              .splitlines()
          )
          result = [br, str(st), str(mo), str(ut)]
          with open(CACHE, "w") as f:
              f.write("|".join(result))
          return result
      except Exception:
          return ["", "0", "0", "0"]


  branch, staged, modified, untracked = git_info()
  staged, modified, untracked = int(staged), int(modified), int(untracked)

  # ── OMC telemetry (delegated to the OMC HUD) ─────────────
  # ralph/agents/todos/bg state lives in OMC + the session transcript;
  # instead of re-parsing it, run the HUD once and cache the rendered
  # segment (per session, 2s TTL). Disabled elements (model/ctx/session)
  # are configured via settings.omcHud in default.nix.
  NODE = "${pkgs.lib.getExe pkgs.nodejs_24}"
  HUD = "${omc}/lib/node_modules/oh-my-claude-sisyphus/dist/hud/index.js"


  def omc_section():
      cache = f"/tmp/claude-sl-omc-{data.get('session_id', 'x')}"
      try:
          if time.time() - os.path.getmtime(cache) < 2:
              with open(cache) as f:
                  return f.read().strip()
      except (OSError, ValueError):
          pass
      line = ""
      try:
          proc = subprocess.run(
              [
                  NODE,
                  HUD,
              ],
              input=json.dumps(data),
              capture_output=True,
              text=True,
              timeout=1.5,
          )
          out_lines = (proc.stdout or "").strip().splitlines()
          if out_lines:
              line = out_lines[-1].strip()
      except Exception:
          line = ""
      try:
          with open(cache, "w") as f:
              f.write(line)
      except OSError:
          pass
      return line


  omc = omc_section()

  # ── Derived values ────────────────────────────────────────
  in_t = fmt_tok(input_tokens)
  out_t = fmt_tok(output_tokens)
  cost_s = f"''${cost_usd:.2f}"
  dur_s = fmt_dur(duration_ms)
  clock = time.strftime("%H:%M")

  # Git indicators
  git_ind = ""
  if staged:
      git_ind += f" {GRN}+{staged}{R}"
  if modified:
      git_ind += f" {YEL}~{modified}{R}"
  if untracked:
      git_ind += f" {GRY}?{untracked}{R}"

  # Lines changed
  lines_s = ""
  if lines_added or lines_removed:
      lines_s = f"{GRN}+{lines_added}{R}{D}/{R}{RED}-{lines_removed}{R}"

  # Model diamond icon
  if "opus" in model_id:
      m_icon = f"{RUST_B}◆{R}"
  elif "sonnet" in model_id:
      m_icon = f"{BLU}◆{R}"
  elif "haiku" in model_id:
      m_icon = f"{GRN}◆{R}"
  else:
      m_icon = f"{GRY}◆{R}"

  # Vim mode
  vim_s = ""
  if vim_mode == "NORMAL":
      vim_s = f" {RUST_BG}{WHT}{B} N {R}"
  elif vim_mode == "INSERT":
      vim_s = f" {RUST_BG}{WHT}{B} I {R}"

  # ── Build content strings ─────────────────────────────────
  ctx_content = (
      f"{bar_clr}{bar}{R}  {WHT}{B}{pct}%{R}{warn}"
      f" {D}of{R} {RUST}{ctx_label}{R}  {D}·{R}  {status_label}"
  )

  stats_content = (
      f"{BLU}↓{R} {in_t}  {PUR}↑{R} {out_t}"
      f"  {RUST_D}│{R}  {YEL}{cost_s}{R}"
      f"  {RUST_D}│{R}  {GRY}⏱ {dur_s}{R}"
      + (f"  {RUST_D}│{R}  {lines_s}" if lines_s else "")
  )

  repo_content = f"{m_icon} {RUST_B}{B}{model}{R}"
  if branch:
      repo_content += f"  {RUST_D}·{R}  {PUR}{truncate(branch)}{R}{git_ind}"
  repo_content += f"  {RUST_D}·{R}  {GRY}{clock}{R}"
  repo_content += vim_s

  # ── Render (single line) ──────────────────────────────────
  sep = f"  {RUST}│{R}  "
  sections = [ctx_content, stats_content, repo_content]
  if omc:
      sections.append(f"{RUST}OMC{R} {omc}")
  print(sep.join(sections))
''
