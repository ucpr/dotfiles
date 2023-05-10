#!/bin/bash

_started_at=$(gdate +'%s.%5N')

# zsh を起動して終了するまでの時間
zsh -i -c exit

_ended_at=$(gdate +'%s.%5N')
_elapsed=$(echo "scale=5; $_ended_at - $_started_at" | bc)

echo "start: $(gdate -d "@${_started_at}" +'%Y-%m-%d %H:%M:%S.%5N (%:z)')"
echo "end  : $(gdate -d "@${_ended_at}" +'%Y-%m-%d %H:%M:%S.%5N (%:z)')"
echo "elapsed time  :   ${_elapsed}"
