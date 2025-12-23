/** @noSelfInFile */

export const moduleName = 'reload-config'
export const log = hs.logger.new(moduleName, 'info')

export function isNeedReloadConfig(files: string[]): boolean {
  return files.some(file => file.endsWith('.lua'))
}

export function reloadConfigIfNeed(this: void, files: string[]): void {
  if (isNeedReloadConfig(files)) {
    hs.reload()
  }
}

export const watcher = hs.pathwatcher.new(hs.configdir, reloadConfigIfNeed)

function init(): void {
  log.i(`Initializing [${moduleName}] module...`)
  watcher.start()
}

export function apply(): void {
  init()
}
