#!/usr/bin/env bash

# use https://github.com/s-octavian/FastDemoRestApi-ops.git

GREEN='\033[0;32m'
NC='\033[0m'

repo="${1:-}"

log() {
    echo -e "${GREEN}$(date '+%Y-%m-%d %H:%M:%S') - $1${NC}"
}

if [[ -z "$repo" ]]; then
    echo "Usage: $0 <git-repo-url>"
    exit 99
fi

current_dir="$(pwd)"
log "Director curent: $current_dir"

folder=$(basename "$repo" .git)

if [[ -d "$folder" ]]; then
    log "Repository \"$folder\" exista deja."
else
    log "Clonare repo \"$repo\"."
    git clone "$repo"
fi

cd "$folder" || exit
log "Locatia este \"$(pwd)\"."
log "Init REST API."

log "Creaza venv."
python3 -m venv venv

log "Activeaza venv"
source venv/bin/activate

log "Instalare dependinte."
pip install -r requirements.txt

log "Rulare teste."
pytest 2>&1 | grep -v "rootdir:" > teste.log
rezultate=$(<teste.log)

log "Repo URL: $repo"

#git checkout $git_PR_branch

gh pr create --base main --head dev --title "update add teste" --body "$rezultate"

log "Dezactivare venv."
deactivate

log "Locatia este \"$(pwd)\"."

cd ..

log "Locatia este \"$(pwd)\"."
log "$folder"

#rm -fr $folder

