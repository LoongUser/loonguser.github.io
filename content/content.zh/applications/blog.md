---
title: 3A6000上搭建hexo博客
author: Ayden Meng
categories: 3. 应用
toc: true
---

```
pacman -S nodejs npm git
npm config set proxy="http://127.0.0.1:7890"
npm install -g hexo-cli
```

```
mkdir loongsonwiki
cd loongsonwiki
hexo init
git clone  https://github.com/hdxw/hexo-theme-prowiki.git themes/hexo-theme-prowiki
git submodule add  https://github.com/hdxw/hexo-theme-prowiki.git themes/hexo-theme-prowiki
vim _config.yml
```

```
diff --git a/_config.yml b/_config.yml
index 02b67a4..2391977 100644
--- a/_config.yml
+++ b/_config.yml
@@ -97,7 +97,7 @@ ignore:
 # Extensions
 ## Plugins: https://hexo.io/plugins/
 ## Themes: https://hexo.io/themes/
-theme: landscape
+theme: hexo-theme-prowiki

 # Deployment
 ## Docs: https://hexo.io/docs/one-command-deployment
```
