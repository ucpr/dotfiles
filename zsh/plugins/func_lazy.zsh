ggl() {
    open "https://google.com/search?q=${*// /%20}"
}

gignore() {
    curl -L -s "https://www.gitignore.io/api/$@"
}
