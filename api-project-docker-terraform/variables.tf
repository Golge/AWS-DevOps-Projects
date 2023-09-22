variable "repo-files" {
  default = ["bookstore-api.py", "Dockerfile", "requirements.txt", "docker-compose.yaml"]
}

variable "github_token" {
  description = "Github Personal Access Token"
  default = ""  # your github token
}