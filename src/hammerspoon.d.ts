/** @noSelfInFile */

declare namespace hs {
  const configdir: string

  function reload(): void

  namespace logger {
    /** @noSelf */
    function _new(this: void, name: string, logLevel?: string): Logger
    export { _new as new }

    interface Logger {
      i: (this: void, message: string) => void
      d: (this: void, message: string) => void
      e: (this: void, message: string) => void
      w: (this: void, message: string) => void
      f: (this: void, fmt: string, ...args: any[]) => void
    }
  }

  namespace alert {
    const defaultStyle: any
    function show(this: void, message: string, duration?: number): string
    function show(this: void, message: string, style: any, screen: any, duration?: number): string
    function closeSpecific(this: void, id: string): void
  }

  namespace screen {
    function mainScreen(this: void): any
  }

  namespace timer {
    function secondsSinceEpoch(this: void): number
    function waitUntil(this: void, predicate: (this: void) => boolean, action: (this: void) => void, checkInterval?: number): void
  }

  namespace application {
    interface Application {
      isRunning: () => boolean
      mainWindow: () => Window | undefined
      focusedWindow: () => Window | undefined
      allWindows: () => Window[]
      activate: () => boolean
      unhide: () => boolean
      setFrontmost: (allWindows?: boolean) => boolean
      isFrontmost: () => boolean
      hide: () => boolean
    }
    function get(this: void, hint: string): Application | undefined
    function frontmostApplication(this: void): Application | undefined
    function launchOrFocusByBundleID(this: void, bundleID: string): boolean
  }

  interface Window {
    focus: () => boolean
    raise: () => Window
    screen: () => any
    frame: () => { x: number, y: number, w: number, h: number }
    setFrame: (frame: { x: number, y: number, w: number, h: number }) => Window
    isStandard: () => boolean
    isMinimized: () => boolean
    unminimize: () => Window
  }

  namespace eventtap {
    export interface EventTap {
      start: () => EventTap
      stop: () => EventTap
    }
    export namespace event {
      const types: {
        flagsChanged: number
      }
      interface Event {
        getFlags: () => {
          cmd?: boolean
          ctrl?: boolean
          shift?: boolean
          fn?: boolean
          alt?: boolean
        }
        getKeyCode: () => number
      }
    }
    /** @noSelf */
    function _new(this: void, types: number[], fn: (this: void, event: event.Event) => boolean | void): EventTap
    export { _new as new }
  }

  namespace keycodes {
    function methods(this: void): string[]
    function setMethod(this: void, method: string): boolean
  }

  namespace hotkey {
    function bind(this: void, mods: string[], key: string, fn: (this: void) => void): void
  }

  namespace pathwatcher {
    /** @noSelf */
    function _new(this: void, path: string, fn: (this: void, files: string[]) => void): PathWatcher
    export { _new as new }

    interface PathWatcher {
      start: () => void
      stop: () => void
    }
  }
}
