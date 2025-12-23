/** @noSelfInFile */

export const moduleName = 'wezterm'
export const log = hs.logger.new(moduleName, 'info')

const WEZTERM_BUNDLE_ID = 'com.github.wez.wezterm'

function isWeztermFullyLaunched(): boolean {
  const app = hs.application.get(WEZTERM_BUNDLE_ID)
  const isRunning = app !== undefined && app.isRunning()
  const win = app?.mainWindow()
  const hasMainWindow = win !== undefined
  return isRunning && hasMainWindow
}

interface LastFocused {
  app: hs.application.Application | undefined
  win: hs.Window | undefined
  save: (this: LastFocused) => void
  restore: (this: LastFocused) => void
}

const lastFocused: LastFocused = {
  app: undefined,
  win: undefined,

  save(this: LastFocused): void {
    this.app = hs.application.frontmostApplication()
    this.win = this.app?.focusedWindow()
  },

  restore(this: LastFocused): void {
    if (this.app) {
      this.app.activate()
      this.win?.focus()
    }
    this.app = undefined
    this.win = undefined
  },
}

interface LaunchingAlert {
  currentAlertId: string | undefined
  show: (this: LaunchingAlert) => void
  close: (this: LaunchingAlert) => void
}

const launchingAlert: LaunchingAlert = {
  currentAlertId: undefined,

  show(this: LaunchingAlert): void {
    this.close()
    this.currentAlertId = hs.alert.show(
      'Launching WezTerm...',
      hs.alert.defaultStyle,
      hs.screen.mainScreen(),
      Number.POSITIVE_INFINITY,
    )
  },

  close(this: LaunchingAlert): void {
    if (this.currentAlertId) {
      hs.alert.closeSpecific(this.currentAlertId)
      this.currentAlertId = undefined
    }
  },
}

function maximizeWindow(win: hs.Window | undefined): void {
  if (!win)
    return
  const screen = win.screen()
  const screenFrame = screen.frame()
  win.setFrame(screenFrame)
}

function getFocusableWindow(app: hs.application.Application | undefined): hs.Window | undefined {
  if (!app)
    return undefined

  const prepareWindow = (win: hs.Window | undefined): hs.Window | undefined => {
    if (!win || !win.isStandard())
      return undefined
    if (win.isMinimized()) {
      win.unminimize()
    }
    return win
  }

  let win = prepareWindow(app.focusedWindow()) || prepareWindow(app.mainWindow())
  if (win)
    return win

  for (const candidate of app.allWindows()) {
    win = prepareWindow(candidate)
    if (win)
      return win
  }

  return undefined
}

function showAndMaximize(app: hs.application.Application | undefined): void {
  if (!app)
    return
  app.unhide()
  app.setFrontmost(true)
  const win = getFocusableWindow(app)
  if (!win)
    return
  maximizeWindow(win)
  win.raise()
  win.focus()
}

function toggleWezterm(): void {
  const app = hs.application.get(WEZTERM_BUNDLE_ID)

  if (!app) {
    lastFocused.save()
    launchingAlert.show()
    hs.application.launchOrFocusByBundleID(WEZTERM_BUNDLE_ID)
    hs.timer.waitUntil(
      isWeztermFullyLaunched,
      () => {
        launchingAlert.close()
        const currentApp = hs.application.get(WEZTERM_BUNDLE_ID)
        showAndMaximize(currentApp)
      },
      0.1,
    )
    return
  }

  if (!app.isFrontmost()) {
    lastFocused.save()
    showAndMaximize(app)
    return
  }

  app.hide()
  lastFocused.restore()
}

const OPTION_KEYCODES: Record<number, boolean> = {
  58: true, // left option
  61: true, // right option
}

function createOptionDoublePressWatcher(callback: () => void): hs.eventtap.EventTap {
  const doublePressTimeout = 0.3
  let lastOptionRelease = 0
  let optionIsDown = false
  let optionWasPure = true

  const eventtap = hs.eventtap.new([hs.eventtap.event.types.flagsChanged], (event) => {
    const flags = event.getFlags()
    const keyCode = event.getKeyCode()
    const isOptionKey = OPTION_KEYCODES[keyCode] === true

    if (optionIsDown && (flags.cmd || flags.ctrl || flags.shift || flags.fn)) {
      optionWasPure = false
    }

    if (!isOptionKey) {
      if (!flags.alt) {
        optionIsDown = false
        optionWasPure = true
      }
      return false
    }

    if (flags.alt) {
      optionIsDown = true
    }
    else {
      if (optionIsDown && optionWasPure) {
        const now = hs.timer.secondsSinceEpoch()
        if (now - lastOptionRelease <= doublePressTimeout) {
          callback()
          lastOptionRelease = 0
          optionIsDown = false
          optionWasPure = true
          return true
        }
        else {
          lastOptionRelease = now
        }
      }

      optionIsDown = false
      optionWasPure = true
    }

    return false
  })

  return eventtap
}

export const optionDoublePressWatcher = createOptionDoublePressWatcher(toggleWezterm)

function init(): void {
  log.i(`Initializing [${moduleName}] module...`)
  optionDoublePressWatcher.start()
}

export function apply(): void {
  init()
}
