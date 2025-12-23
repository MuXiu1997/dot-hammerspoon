import * as keyboard from './keyboard'
/** @noSelfInFile */
import * as reloadConfig from './reload-config'

reloadConfig.apply()
keyboard.apply()

hs.alert.show('Hammerspoon config loaded')
