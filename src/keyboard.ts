/** @noSelfInFile */

export const moduleName = 'keyboard'
export const log = hs.logger.new(moduleName, 'info')

export function useSquirrel(): void {
  const currentID = hs.keycodes.currentSourceID()
  const currentMethod = hs.keycodes.currentMethod()
  const isSquirrel = (currentID && currentID.includes('Squirrel')) || (currentMethod && currentMethod.includes('Squirrel'))

  if (isSquirrel) {
    // If Squirrel is already active, send Control+Shift+Alt+F2.
    // This triggers the Rime configuration:
    // `- { when: always, accept: "Control+Shift+Alt+F2", unset_option: ascii_mode }`
    // to force switch from ASCII mode back to Chinese mode.
    hs.eventtap.keyStroke(['ctrl', 'shift', 'alt'], 'f2')
  }
  else {
    const methods = hs.keycodes.methods()
    const squirrel = methods.find(method => method.includes('Squirrel'))
    if (squirrel) {
      hs.keycodes.setMethod(squirrel)
    }
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
