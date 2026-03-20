#!/bin/bash

# 使用 osascript 在终端运行增强版 AppleScript 指令
osascript <<EOD
tell application "Google Chrome"
    if (count windows) is 0 then return
    
    # 1. 记录当前的 Gemini 标签页（假设你在当前页操作）
    set currentTab to active tab of window 1
    
    # 2. 静默清理 Sockets (解决连接转圈)
    set socketTab to make new tab at end of tabs of window 1 with properties {URL:"chrome://net-internals/#sockets"}
    delay 1.0 -- 等待页面加载
    execute socketTab javascript "document.getElementById('sockets-view-flush-button').click();"
    close socketTab
    
    # 3. 静默清理 DNS 缓存 (解决地区识别错误)
    set dnsTab to make new tab at end of tabs of window 1 with properties {URL:"chrome://net-internals/#dns"}
    delay 0.5
    execute dnsTab javascript "document.getElementById('dns-view-clear-host-cache').click();"
    close dnsTab
    
    # 4. 强制刷新当前页面 (Hard Reload，忽略旧的地区 Cookie)
    # 我们通过执行 JS 指令来强制刷新
    execute currentTab javascript "window.location.reload(true);"
    
end tell
EOD

echo "🚀 Network Fixed: Sockets Flushed, DNS Cleared, and Page Hard-Reloaded!"