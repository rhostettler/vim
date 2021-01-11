" Roland's VIM Config
" ===================
" Reload using :so ~/.vimrc
"
" Consider cleaning up:
" https://stackoverflow.com/questions/2889766/best-way-to-organize-filetype-settings-in-vim-and-vimrc#2890444

" Vundle
" ------
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
set nocompatible
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins (must be added before vundle#end())
Plugin 'VundleVim/Vundle.vim'       " Vundle itself
Plugin 'LaTeX-Box-Team/LaTeX-Box'   " LaTeX-Box
Plugin 'tpope/vim-surround'         " Surround

call vundle#end()            " required
"filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
filetype plugin on


" Determine the OS for OS specific settings. Use as:
"
"   if os == 'Darwin' || os == 'Mac'
"   if os == 'Linux'
" 
" and so forth.
let os = substitute(system('uname'), '\n', '', '')

" General (G)UI Preferences
" =========================
" Use 4 whitespaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab

" Indentation
set autoindent nosmartindent

" Adjust the window- and font size when using gvim
"if has("gui_gtk")
if has("gui_running")
    set number                 " Show line numbers by default
    "set lines=999 columns=999  " Fullscreen; TODO: Should rather be 'recover last pos/size' TODO: Makes gvim crash in Ubuntu 18.04 LTS; hence we disable it.

"    highlight ColorColumn ctermbg=gray
"    set colorcolumn=80

    " Linux specific GUI settings
    if os == 'Linux'
        set guifont=Monospace\ 12  " TODO: I might consider making this host-dependent
        set guioptions-=T           " Remove toolbar
        " set guioptions-=m           " Remove menubar
        "

        " Map Alt-# to tab switching (similar to Gnome terminal and Firefox),
        " but only on Linux and in GUI mode to avoid interfering with the same
        " functionality in Gnome terminal.
        noremap <M-1> 1gt
        noremap <M-2> 2gt
        noremap <M-3> 3gt
        noremap <M-4> 4gt
        noremap <M-5> 5gt
        noremap <M-6> 6gt
        noremap <M-7> 7gt
        noremap <M-8> 8gt
        noremap <M-9> 9gt

        " Ctrl+Shift+V for paste from system buffer
"        noremap <C-S-V> "+gP
"        inoremap <C-S-V> <Esc>"+gPa

        " Open new tab with Ctrl+t
        noremap <silent> <C-T> :tabnew<CR>
        vnoremap <silent> <C-T> <C-C>:tabnew<CR>
        inoremap <silent> <C-T> <C-O>:tabnew<CR>
    endif

    " MacOS specific GUI settings
    if os == 'Darwin' || os == 'Mac'
        set guifont=Menlo\ Regular:h14
    endif
endif

" Enable line and column numbers
set ruler

" Colorscheme
colorscheme molokai

" Spellchecking
" =============
" Set default spellchecking to en_us (could also be used somewhere in the
" LaTeX-Box plugin config to only apply to TeX-files but I think it should be
" global anyway)
set spelllang=en_us spell

" Spellchecking does not always work in LaTeX, see https://stackoverflow.com/questions/23353009/vim-spellcheck-not-always-working-in-tex-file-check-region-in-vim#23357364
syntax spell toplevel

" Plugins
" =======
" To enable the LaTeX-Box (and possibly others) plugins
filetype plugin on

" Autocompletion for LaTeX w/ Tab
" ===============================
" Based on the function discussed here:
" http://vim.wikia.com/wiki/Smart_mapping_for_tab_completion)
function! Complete_Tab_LaTeX()
    " Get the word/character in front of the cursor
    let substr = strpart(getline('.'), -1, col('.'))    " get substring up to cursor
    let substr = matchstr(substr, "[^ \t]*$")           " Strip leading tabs and whitespaces
    
    " Empty string => nothing to match => insert tab
    if (strlen(substr)==0)
        return "\<tab>"
    endif

"    let has_period = match(substr, '\.') != -1      " position of period, if any
"    let has_slash = match(substr, '\/') != -1       " position of slash, if any
    " Check if the last character prior to the cursor is a backslash or curly
    " brace
    let has_input = match(substr, '\\input{') != -1
    let has_include = match(substr, '\\include') != -1
    let has_backslash = match(substr, '\\') != -1
    let has_curlybrace_open = match(substr, '{') != -1
    if (has_input || has_include)
        return "\<C-X>\<C-F>"                        " file matching
    elseif (has_backslash || has_curlybrace)
        return "\<C-X>\<C-O>"                        " plugin matching
"    else
"        return "\<C-X>\<C-P>"                         " text matching
    else
        return "\<tab>"
    endif
endfunction
inoremap <tab> <c-r>=Complete_Tab_LaTeX()<CR>


" Custom Key Mapping
" ==================
" Remap Ctrl-Space to Ctrl-x Ctrl-o for autocompletion, see
" http://stackoverflow.com/questions/7722177/how-do-i-map-ctrl-x-ctrl-o-to-ctrl-space-in-terminal-vim
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
nnoremap <Up> gk
nnoremap <Down> gj

" Ctrl-s for saving, see https://stackoverflow.com/questions/3446320/in-vim-how-to-map-save-to-ctrl-s#3448551
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>

" Ctrl-v for paste, see https://superuser.com/questions/61226/configure-vim-for-copy-and-paste-keyboard-shortcuts-from-system-buffer-in-ubuntu
" TODO: Doesn't work in insert mode yet
"map <C-v> "+gP

" Shift-tab for unindent
inoremap <S-Tab> <C-d>
"if has("gui_running")
"    " C-Space seems to work under gVim on both Linux and win32
"    inoremap <C-Space> <C-x> <C-o>
"    inoremap <C-@> <C-Space>
"else " no gui
"    if has("unix")
"        inoremap <Nul> <C-x> <C-o>
"    else
"        " I have no idea of the name of Ctrl-Space elsewhere
"    endif
"endif

" Automatically closing brackets
" https://stackoverflow.com/questions/21316727/automatic-closing-brackets-for-vim#34992101
" inoremap " ""<left>
" inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
" inoremap { {}<left>
" inoremap < <><left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Remap some keys to make LaTeX life on MAC easier
if has("gui_macvim")
    " Autocompletion
"    inoremap <C-Space> <C-x> <C-o>
"    inoremap <C-@> <C-Space>

    " Backslash, curly braces
    inoremap <D-7> \
    inoremap <D-8> {
    inoremap <D-9> }
endif

" Custom Commands
" ===============
" {S}et the {W}orking {W}irectory to the directory of the current file
command SWD cd %:p:h

" {S}et {F}iletype to {L}aTeX
command SFL set filetype=tex

" Remap {W} to w (I'm always too fast)
command W w

