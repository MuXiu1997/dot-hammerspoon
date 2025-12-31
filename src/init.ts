/** @noSelfInFile */

import * as keyboard from './keyboard'
import * as prefixCs from './prefix-C-s'
import * as reloadConfig from './reload-config'
import * as wezterm from './wezterm'
import 'hs.ipc'

reloadConfig.apply()
keyboard.apply()
prefixCs.apply()
wezterm.apply()

hs.alert.show('Hammerspoon config loaded')
