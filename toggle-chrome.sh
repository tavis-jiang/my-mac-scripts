#!/bin/bash

osascript <<EOT
tell application "Google Chrome"
    set found to false
    -- 遍历所有窗口 (Loop through all windows)
    repeat with w in windows
        -- 遍历当前窗口的所有标签页 (Loop through all tabs)
        repeat with t in tabs of w
            if URL of t contains "youtube.com/watch" then
                -- 修正后的执行语句 (Corrected execution syntax)
                tell t to execute javascript "var v = document.querySelector('video'); if(v) { v.paused ? v.play() : v.pause(); }"
                set found to true
                exit repeat
            end if
        end repeat
        if found then exit repeat
    end repeat
end tell
EOT
