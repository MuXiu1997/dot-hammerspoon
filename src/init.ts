/** @noSelfInFile */

import * as keyboard from './keyboard'
import * as reloadConfig from './reload-config'
import * as wezterm from './wezterm'

reloadConfig.apply()
keyboard.apply()
wezterm.apply()

hs.alert.show('Hammerspoon config loaded')
