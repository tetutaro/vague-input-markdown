# vague-input-markdown

VIMでMarkdownが適当に都合よく入力できるように

- `]]`, `[[`
    - normal / visual モードで、次（前）のヘッダに移動
- CR
    - insert モードで
    - リストが空の場合にインデントを下げる
- TAB
    - insert モードで
    - リストのインデントを上げる
    - ヘッダのレベルを上げる
- S-TAB
    - insert モードで
    - リストのインデントを下げる
    - ヘッダのレベルを下げる

## 設定方法

vimrc に以下を記述

```
augroup VagueInputMarkdown
    autocmd!
    autocmd Filetype markdown call vagueinputmarkdown#Configure()
augroup END
```
