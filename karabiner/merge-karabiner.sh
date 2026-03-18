#!/bin/bash
# Merge Goku-generated rules with JIS-specific rules into karabiner.json
#
# Workflow:
#   1. Run `goku` to generate base config from karabiner.edn
#   2. Run this script to merge JIS rules into the generated config
#
# Usage: ./merge-karabiner.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
JIS_RULES="$SCRIPT_DIR/jis-rules.json"
KARABINER_CONFIG="$HOME/.config/karabiner/karabiner.json"

if [[ ! -f "$KARABINER_CONFIG" ]]; then
    echo "Error: $KARABINER_CONFIG not found"
    exit 1
fi

if [[ ! -f "$JIS_RULES" ]]; then
    echo "Error: $JIS_RULES not found"
    exit 1
fi

python3 -c "
import json, sys

with open('$KARABINER_CONFIG') as f:
    config = json.load(f)

with open('$JIS_RULES') as f:
    jis_rules = json.load(f)

profile = config['profiles'][0]
existing_rules = profile.get('complex_modifications', {}).get('rules', [])

# Remove any existing JIS rules (keyboard_type_if condition)
non_jis_rules = []
for r in existing_rules:
    has_jis = any(
        c.get('type') == 'keyboard_type_if'
        for m in r.get('manipulators', [])
        for c in m.get('conditions', [])
    )
    if not has_jis:
        non_jis_rules.append(r)

# JIS rules first, then Goku-generated rules
profile['complex_modifications']['rules'] = jis_rules + non_jis_rules

with open('$KARABINER_CONFIG', 'w') as f:
    json.dump(config, f, indent=2, ensure_ascii=False)

print(f'Merged: {len(jis_rules)} JIS rules + {len(non_jis_rules)} other rules = {len(jis_rules) + len(non_jis_rules)} total')
"
