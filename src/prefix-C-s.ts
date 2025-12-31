/** @noSelfInFile */

export const moduleName = 'prefix-C-s'
export const log = hs.logger.new(moduleName, 'info')

const prefixModal = hs.hotkey.modal.new(['ctrl'], 's')

let alertId: string | undefined
let timeoutTimer: hs.timer.Timer | undefined

function clearTimer() {
  if (timeoutTimer) {
    timeoutTimer.stop()
    timeoutTimer = undefined
  }
}

prefixModal.entered = function () {
  if (alertId) {
    hs.alert.closeSpecific(alertId)
  }
  alertId = hs.alert.show('Prefix Mode (Ctrl+S)', {
    textSize: 20,
    radius: 10,
    fillColor: { white: 0, alpha: 0.7 },
    strokeColor: { white: 1, alpha: 0.5 },
  }, hs.screen.mainScreen(), 999999)

  clearTimer()
  timeoutTimer = hs.timer.doAfter(2, () => {
    prefixModal.exit()
  })
}

prefixModal.exited = function () {
  if (alertId) {
    hs.alert.closeSpecific(alertId)
    alertId = undefined
  }
  clearTimer()
}

prefixModal.bind(['ctrl'], 's', () => {
  hs.eventtap.keyStroke(['ctrl'], 's')
  prefixModal.exit()
})

prefixModal.bind([], 'c', () => {
  prefixModal.exit()

  const cursorApp = hs.application.get('Cursor')
  if (!cursorApp) {
    hs.alert.show('Cursor is not running')
    return
  }

  const windows = cursorApp.allWindows().filter(win => win.isStandard())

  if (windows.length === 0) {
    hs.alert.show('No standard Cursor windows found')
    return
  }

  const choices = windows.map((win) => {
    return {
      text: win.title() || 'Untitled Window',
      subText: 'Cursor',
      window: win,
    }
  })

  const chooser = hs.chooser.new((choice: any) => {
    if (choice && choice.window) {
      const win = choice.window as hs.Window
      win.focus()
      if (win.isMinimized()) {
        win.unminimize()
      }
    }
  })

  chooser.choices(choices)
    .placeholderText('Select a Cursor window...')
    .searchSubText(true)
    .show()
})

prefixModal.bind([], 'e', () => {
  prefixModal.exit()

  const edgeApp = hs.application.get('Microsoft Edge')
  if (!edgeApp) {
    hs.alert.show('Microsoft Edge is not running')
    return
  }

  const windows = edgeApp.allWindows().filter(win => win.isStandard())

  if (windows.length === 0) {
    hs.alert.show('No standard Edge windows found')
    return
  }

  const choices = windows.map((win) => {
    return {
      text: win.title() || 'Untitled Window',
      subText: 'Microsoft Edge',
      window: win,
    }
  })

  const chooser = hs.chooser.new((choice: any) => {
    if (choice && choice.window) {
      const win = choice.window as hs.Window
      win.focus()
      if (win.isMinimized()) {
        win.unminimize()
      }
    }
  })

  chooser.choices(choices)
    .placeholderText('Select an Edge window...')
    .searchSubText(true)
    .show()
})

prefixModal.bind([], 't', () => {
  prefixModal.exit()

  const script = `
    tell application "Microsoft Edge"
        set res to {}
        try
            set winCount to count windows
            repeat with wIdx from 1 to winCount
                set tCount to count tabs of window wIdx
                repeat with tIdx from 1 to tCount
                    set tTitle to title of tab tIdx of window wIdx
                    set end of res to tTitle & "||" & wIdx & "||" & tIdx
                end repeat
            end repeat
        end try
        return res
    end tell
  `

  const [ok, result] = hs.osascript.applescript(script)

  if (!ok || !result) {
    hs.alert.show('Failed to get Edge tabs')
    return
  }

  const choices = (result as string[]).map((line) => {
    const [title, wIdx, tIdx] = line.split('||')
    return {
      text: title,
      subText: 'Microsoft Edge Tab',
      wIdx: Number.parseInt(wIdx),
      tIdx: Number.parseInt(tIdx),
    }
  })

  const chooser = hs.chooser.new((choice: any) => {
    if (choice) {
      const switchScript = `
        tell application "Microsoft Edge"
            set index of window ${choice.wIdx} to 1
            set active tab index of window 1 to ${choice.tIdx}
            activate
        end tell
      `
      hs.osascript.applescript(switchScript)
    }
  })

  chooser.choices(choices)
    .placeholderText('Select an Edge tab...')
    .searchSubText(true)
    .show()
})

export function apply(): void {
  log.i(`Initializing [${moduleName}] module...`)
}
