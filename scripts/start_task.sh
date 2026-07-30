#!/bin/bash
set -euo pipefail

AGENT="${1:-}"
shift || true
TASK="$*"

if [ -z "$AGENT" ] || [ -z "$TASK" ]; then
  echo "Usage:"
  echo "  ./scripts/start_task.sh codex \"Fix FlowSOM UMAP labels\""
  echo "  ./scripts/start_task.sh cursor \"Refactor Data Browser CSS\""
  exit 1
fi

case "$AGENT" in
  codex|cursor|gemini|chatgpt) ;;
  *)
    echo "Unknown agent: $AGENT"
    echo "Allowed: codex cursor gemini chatgpt"
    exit 1
    ;;
esac

mkdir -p docs/agent-state/active-tasks

TASK_ID="$(date +%Y%m%d-%H%M%S)-${AGENT}"

cat > "docs/agent-state/active-tasks/${AGENT}.md" <<EOT
# Active Task - ${AGENT}

Last Updated:
$(date)

Task ID:
${TASK_ID}

Task:
${TASK}

Current Status:
planning

Current Branch:
$(git branch --show-current)

Files In Scope:

Latest Progress:

Next Action:

Success Criteria:

Known Risks:

Relevant History Queries:
- ./shiny-index logs search "${TASK}"
EOT

echo "Task initialized for ${AGENT}: ${TASK_ID}"
