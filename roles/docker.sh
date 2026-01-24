# Docker aliases/ functions
alias dcud="docker compose up -d"
alias dcd="docker compose down"
alias dcpl="docker compose pull"
alias dpsf="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dst="docker stats"
alias dstn="docker stats --no-stream"

dcudproj() {
  docker compose --project-directory "$1" up -d
}
dcdproj() {
  docker compose --project-directory "$1" down
}
dcplproj() {
  docker compose --project-directory "$1" pull
}
dexit() {
  docker exec -it "$1" sh
}
dnet() {
  docker network "$@"
}
dc() {
  docker compose "$@"
}
dl() {
  docker logs -f "$1"
}
