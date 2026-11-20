#!/bin/bash
# فایل‌های کنار هم را در ساختار لازم اندروید می‌چیند
set -e
mkdir -p proj/app/src/main/java/ir/ganjineketab/app proj/app/src/main/res/values
cp build.gradle settings.gradle gradle.properties proj/
cp app-build.gradle proj/app/build.gradle
cp ganjine.keystore proj/app/ganjine.keystore
cp AndroidManifest.xml proj/app/src/main/AndroidManifest.xml
cp MainActivity.java proj/app/src/main/java/ir/ganjineketab/app/MainActivity.java
cp config.xml strings.xml styles.xml proj/app/src/main/res/values/
pip install --break-system-packages pillow >/dev/null
python3 - <<'EOF_PY'
from PIL import Image
import os
try:
    src=Image.open('logo.png').convert('RGBA')
except Exception:
    src=Image.new('RGBA',(512,512),(79,70,229,255))
base='proj/app/src/main/res'
for d,s in {'mdpi':48,'hdpi':72,'xhdpi':96,'xxhdpi':144,'xxxhdpi':192}.items():
    os.makedirs(f'{base}/mipmap-{d}',exist_ok=True)
    bg=Image.new('RGBA',(s,s),(255,255,255,255))
    bg.alpha_composite(src.resize((s,s),Image.LANCZOS))
    bg.convert('RGB').save(f'{base}/mipmap-{d}/ic_launcher.png')
EOF_PY
