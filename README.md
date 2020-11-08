# Vim plugin for Bluespec SystemVerilog (BSV)
## Installation using Vundle
Place this in your `.vimrc`:

`Plug 'mtikekar/vim-bsv'`

… then run the following in Vim:
```
:source %
:PlugInstall
```
## Features
- Syntax highlighting
- Autoindent
- Autocomplete options:
  1. From dictionary of words: ctrl-x ctrl-k
  2. From `import`ed files: ctrl-x ctrl-i
  3. Above options are simply settings for vim's builtin `'complete'` feature. Make it more useful with plugins like [supertab](https://github.com/ervandew/supertab) or [autocomplpop](https://github.com/othree/vim-autocomplpop).
- Move between matching keywords (%) with vim's built-in matchit plugin. Enable the plugin in vimrc:

  ```vim
  if !exists('g:loaded_matchit')
      runtime! macros/matchit.vim
  endif
  ```
- Open `import`ed file: In normal mode, press `gf` (goto file) with cursor over file name.
- Code snippets for [snipmate](https://github.com/ervandew/snipmate.vim), or [new snipmate](https://github.com/garbas/vim-snipmate)
- Rules for [endwise](https://github.com/tpope/vim-endwise)

Features involving `import`ed files use vim's `path` option to look for the files. There are several ways to do this:

1. Per project: `set exrc secure`, put a .vimrc in your project folder with `set path=...`
2. Per file: `set modeline`, put a comment at the beginning of your code `// vim:path=...`
3. Can export the per file setting globally with: `autocmd BufWinEnter *.bsv if &l:path != '' | let &path = &l:path | endif`
4. roll your own file format that can be read by both vim and your build script

Do :help path, :help exrc, :help modeline for more info.

I prefer the last option. In my top-level source folder, I have a file called "bsvpath". In vimrc:

```vim
function! BSVSetPath(srcdir)
    let pathfile = a:srcdir . '/bsvpath'
    if filereadable(pathfile)
        set path=
        for line in readfile(pathfile)
            if line =~# '^[^$/]'
                let line = simplify(a:srcdir . '/' . line)
            endif
            execute "set path+=" . line
        endfor
    endif
endfunction

autocmd FileType bsv call BSVSetPath(expand('<afile>:p:h'))
```
