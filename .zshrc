# 起動時のディレクト設定 #
cd /Users/komagome/Documents/vscode

# chromをでデバッグモードで起動するエイリアス #
alias debugchrom='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222'


export PATH=$HOME/.nodebrew/current/bin:$PATH

# 起動時にログインシェルをFishにする
if [[ -o interactive ]]; then
    exec fish
fi
