#!/usr/bin/env python3
import json
import os
import subprocess
import sys
from datetime import datetime


# Colors inspired by Tokyo Night theme
class Colors:
    RESET = "\033[0m"
    CYAN = "\033[38;2;139;233;253m"
    BLUE = "\033[38;2;122;162;247m"
    MAGENTA = "\033[38;2;187;154;247m"
    GREEN = "\033[38;2;146;214;170m"
    YELLOW = "\033[38;2;250;179;135m"
    RED = "\033[38;2;249;166;139m"
    PURPLE = "\033[38;2;198;160;246m"
    FG_DARK = "\033[38;2;116;125;140m"


# Read JSON from stdin
try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    print(f"{Colors.RED}[Error: Invalid JSON]{Colors.RESET}", file=sys.stderr)
    sys.exit(1)

# --- Extract values with fallbacks ---
model = data.get("model", {}).get("display_name", "Claude")
version = data.get("version", "1.0")
output_style = data.get("output_style", {}).get("name", "default")

current_dir_path = data.get("workspace", {}).get("current_dir", "Dir?")
project_dir_path = data.get("workspace", {}).get("project_dir", current_dir_path)

# Use relative path from project root if different
if current_dir_path != project_dir_path:
    try:
        rel_path = os.path.relpath(current_dir_path, project_dir_path)
        if rel_path == ".":
            current_dir = os.path.basename(project_dir_path)
        else:
            current_dir = f"{os.path.basename(project_dir_path)}/{rel_path}"
    except:
        current_dir = os.path.basename(current_dir_path)
else:
    current_dir = os.path.basename(current_dir_path)

cost_data = data.get("cost", {})
cost = cost_data.get("total_cost_usd", 0.0)
lines_added = cost_data.get("total_lines_added", 0)
lines_removed = cost_data.get("total_lines_removed", 0)

# --- Enhanced git status ---
git_info = ""
git_dir_path = os.path.join(current_dir_path, ".git")

if os.path.exists(git_dir_path):
    try:
        # Get branch name
        head_path = os.path.join(git_dir_path, "HEAD")
        with open(head_path, "r") as f:
            ref = f.read().strip()
            if ref.startswith("ref: refs/heads/"):
                branch_name = ref.replace("ref: refs/heads/", "")
                git_info = f"{Colors.GREEN}on {branch_name}{Colors.RESET}"

                # Get status using git commands with no locks
                try:
                    result = subprocess.run(
                        [
                            "git",
                            "-C",
                            current_dir_path,
                            "status",
                            "--porcelain",
                            "--no-lock",
                        ],
                        capture_output=True,
                        text=True,
                        timeout=5,
                    )
                    if result.returncode == 0:
                        changed_files = (
                            len(result.stdout.strip().split("\n"))
                            if result.stdout.strip()
                            else 0
                        )
                        if changed_files > 0:
                            git_info += (
                                f" {Colors.YELLOW}●{changed_files}{Colors.RESET}"
                            )
                except:
                    pass
    except Exception:
        pass

# --- Time info ---
current_time = datetime.now().strftime("%H:%M")

# --- Output style indicator ---
style_colors = {
    "default": Colors.BLUE,
    "Explanatory": Colors.CYAN,
    "Learning": Colors.MAGENTA,
}
style_color = style_colors.get(output_style, Colors.BLUE)
style_indicator = f"{style_color}{output_style}{Colors.RESET}"

# --- Build status line in Starship style ---
components = []

# User/Session info
components.append(f"{Colors.PURPLE} Claude Code{Colors.RESET}")

# Model and version
components.append(f"{Colors.CYAN}{model} v{version}{Colors.RESET}")

# Directory
components.append(f"{Colors.BLUE}{current_dir}{Colors.RESET}")

# Git info (if available)
if git_info:
    components.append(git_info)

# Cost and changes
if cost > 0:
    components.append(f"{Colors.YELLOW}💲{cost:.3f}{Colors.RESET}")
    if lines_added > 0 or lines_removed > 0:
        components.append(
            f"{Colors.GREEN}+{lines_added}{Colors.RESET}{Colors.RED}-{lines_removed}{Colors.RESET}"
        )

# Output style
components.append(style_indicator)

# Time
components.append(f"{Colors.FG_DARK}{current_time}{Colors.RESET}")

# Join with Starship-style separators
separator = f"{Colors.FG_DARK}❯{Colors.RESET}"
status_line = f" {separator} ".join(components)

print(status_line)
