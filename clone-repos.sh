#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

git clone https://github.com/iulspop/aidd-skills.git
git clone https://github.com/iulspop/personal-app-template-sqlite-fly-io.git
git clone https://github.com/iulspop/production-app-template-postgres-supabase.git
git clone https://github.com/epicweb-dev/epic-stack.git
git clone https://github.com/iulspop/react-router-saas-template.git

echo "All repos cloned."
