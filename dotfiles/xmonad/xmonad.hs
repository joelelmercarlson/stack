-- | yum install cabal-install xmonad
-- | cabal-install xmobar
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig
import System.IO

myManageHook = composeAll
  [ className =? "Gimp"    --> doFloat
  ]

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ defaultConfig
   { manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
   , layoutHook = avoidStruts  $  layoutHook defaultConfig
   , logHook    = dynamicLogWithPP xmobarPP
     { ppOutput = hPutStrLn xmproc
     , ppTitle  = xmobarColor "green" "" . shorten 50
     } 
  -- | windows key
   , modMask            = mod4Mask
   , workspaces         = map show [1 .. 9 :: Int] 
   , terminal           = "urxvt"
   , borderWidth        = 2
   , focusedBorderColor = "#FF8C00"
   , normalBorderColor  = "#CCCCCC"
   } 
   `additionalKeys`
   [ ((mod4Mask, xK_f),               spawn "firefox")
   , ((mod4Mask, xK_e),               spawn "emacs")
   , ((mod4Mask, xK_x),               spawn "urxvt -bg black -fg green")
   , ((mod4Mask, xK_z),               spawn "xscreensaver-command -activate")
   ]
