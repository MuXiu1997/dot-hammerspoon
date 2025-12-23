/** @noSelfInFile */

export const moduleName = 'keyboard'
export const log = hs.logger.new(moduleName, 'info')

export function useSquirrel(): void {
  const methods = hs.keycodes.methods()
  const squirrel = methods.find(method => method.includes('Squirrel'))
  if (squirrel) {
    hs.keycodes.setMethod(squirrel)
  }
}

export function bindSquirrelHotkey(): void {
  log.i('Binding squirrel hotkey...')
  hs.hotkey.bind(['cmd'], 'escape', useSquirrel)
}

function init(): void {
  log.i(`Initializing [${moduleName}] module...`)
  bindSquirrelHotkey()
}

export function apply(): void {
  init()
}
