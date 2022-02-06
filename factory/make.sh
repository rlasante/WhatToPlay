#!/bin/bash

# Create appicons from source file: dice_t_01.png
# Requires graphicsmagick:
# brew install graphicsmagick

# 
gm convert -geometry 76x76 dice_t_01.png icon_76.png
gm convert -geometry 120x120 dice_t_01.png icon_120.png
gm convert -geometry 128x128 dice_t_01.png icon_128.png
gm convert -geometry 152x152 dice_t_01.png icon_152.png
gm convert -geometry 167x167 dice_t_01.png icon_167.png
gm convert -geometry 180x180 dice_t_01.png icon_180.png
gm convert -geometry 1024x1024 dice_t_01.png icon_1024.png
