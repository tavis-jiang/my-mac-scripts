#!/bin/bash

# @Raycast.title Open Gemini and Focus Input
# @Raycast.author Gemini
# @Raycast.mode silent

osascript <<EOT
tell application "Google Chrome"
    set found to false
    set windowList to every window
    
    repeat with w in windowList
        set tabIndex to 0
        repeat with t in tabs of w
            set tabIndex to tabIndex + 1
            if URL of t contains "gemini.google.com" then
                -- 1. 激活窗口和标签页
                set current tab of w to t
                set index of w to 1
                activate
                
                -- 2. 使用 JavaScript 寻找并聚焦输入框
                tell t to do JavaScript "
                    (function() {
                        var input = document.querySelector('div[contenteditable=\"true\"] p') || 
                                    document.querySelector('div[contenteditable=\"true\"]');
                        if (input) {
                            input.focus();
                            // 模拟点击以确保光标激活
                            var evt = document.createEvent('MouseEvents');
                            evt.initMouseEvent('click', true, true, window, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
                            input.dispatchEvent(evt);
                        }
                    })();
                "
                set found to true
                exit repeat
            end if
        end repeat
        if found then exit repeat
    end repeat

    -- 3. 如果没开启 Gemini，则直接打开
    if not found then
        open location "https://gemini.google.com"
        activate
    end if
end tell
EOT
