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
    function show(this: void, message: string, duration?: number): void
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
