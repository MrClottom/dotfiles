" Install Vim Plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()

function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

" utility
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips'
Plug 'tomtom/tcomment_vim'

" autocomplete
Plug 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'carlitux/deoplete-ternjs'
Plug 'davidhalter/jedi-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag' 

" linting
Plug 'w0rp/ale'

" visuals
Plug 'joshdick/onedark.vim'
Plug 'rakr/vim-one'
Plug 'uloco/vim-bluloco-dark'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline' " status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'machakann/vim-highlightedyank'

" syntaxing - vim-javascript slows down vim
Plug 'pangloss/vim-javascript'
Plug 'posva/vim-vue'
Plug 'digitaltoad/vim-pug'
Plug 'jparise/vim-graphql'

" fileexplorer
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons' " icons for nerd-tree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" 
" search
Plug 'cloudhead/neovim-fuzzy' " requires fzy and rg or ag
Plug 'ctrlpvim/ctrlp.vim'

" navigation
Plug 'vim-scripts/Tabmerge' " merges vim tabs

" git
Plug 'tpope/vim-fugitive'


" markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

call plug#end()

" autocomplete
let g:deoplete#enable_at_startup = 1
" let g:deoplete#auto_complete_start_length = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#max_abbr_width = 0
let g:deoplete#max_menu_width = 0
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})

let g:tern_request_timeout = 1
let g:tern_request_timeout = 6000
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]

let g:closetag_filenames = '*.html, *.xhtml, *.xml, *.phtml, *.js, *.vue, *.py, *.md'
autocmd FileType riot call tern#Enable()
autocmd FileType riot setlocal completeopt-=preview
autocmd FileType vue call tern#Enable()
" autocmd FileType vue setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufRead,BufNewFile *.type-def.* set filetype=graphql

" use autocomplete suggestions with tab
autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" linting
let g:ale_fixers = {
\  'javascript': ['prettier', 'eslint'],
\  'vue': ['prettier'],
\  'python': ['autopep8']
\}
let g:ale_fix_on_save = 1

" basic settings
set hidden
set nu
set rnu
set incsearch
set tabstop=2
set shiftwidth=2
set expandtab
set undofile
set undodir=~/.config/nvim/.vimundo
set ignorecase
set smartcase
" find and replace in visually selected
vnoremap f :s/\%V
inoremap jj <ESC>

" visuals
let g:airline_theme='deus'
let g:airline_powerline_fonts=1
syntax on
autocmd FileType vue syntax sync fromstart " otherwise syntax gets lost when scrolling fast
colorscheme one
let g:one_allow_italics = 1
set background=dark
set termguicolors
set textwidth=80
set colorcolumn=80
let g:highlightedyank_highlight_duration = 300

" fileicon settings
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vue'] = 'v'
let g:WebDevIconsNerdTreeAfterGlyphPadding = '  '
let NERDTreeQuitOnOpen=1
let g:NERDTreeExtensionHighlightColor = {}
let g:NERDTreeExtensionHighlightColor['vue'] = '3AFFDB'
nnoremap <Leader>cl :set background=light<CR>
nnoremap <Leader>cd :set background=dark<CR>

" markdown
let g:mkdp_auto_start = 1
let g:mkdp_auto_close = 1


" trailing whitespaces
set list listchars=tab:>\ ,trail:-,eol:↵

" clipboard
set clipboard+=unnamedplus

" line numbering
map <C-l> :set rnu!<CR>
map <C-A-l> :set nu!<CR>

" keymappings
nnoremap <Space> :nohl <Enter>
" navigate splits with alt
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

nnoremap <Leader>k :tabnew<CR>
nnoremap <Leader>s :vnew<CR>
nnoremap <Leader>r :Tabmerge right<CR>
nnoremap <Leader>m :tabm
"
" Create a new terminal in a vertical split
tnoremap <Leader>l <C-\><C-n>:vsp<CR><C-w><C-w>:term<CR>
noremap <Leader>l :vsp<CR><C-w><C-w>:term<CR>
inoremap <Leader>l <Esc>:vsp<CR><C-w><C-w>:term<CR>

" Create a new terminal in a horizontal split
tnoremap <Leader>j <C-\><C-n>:sp<CR><C-w><C-w>:term<CR>
noremap <Leader>j :sp<CR><C-w><C-w>:term<CR>
inoremap <Leader>j <Esc>:sp<CR><C-w><C-w>:term<CR>

" Create a new terminal in a new tab
tnoremap <Leader>t <C-\><C-n>:tabnew<CR>:term<CR>
noremap <Leader>t :tabnew<CR>:term<CR>
inoremap <Leader>t <Esc>:tabnew<CR>:term<CR>

" Switches back to vim mode in terminal, can then close with :q
tnoremap <A-q> <C-\><C-n>

map <C-n> :NERDTreeToggle<CR>
map <C-m> :NERDTreeFind<CR>

" git
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>ga :Gwrite<CR>
nnoremap <Leader>gc :Gcommit<CR>

" close buffer
nnoremap <Leader>c :bp<bar>sp<bar>bn<bar>bd<CR>

" finding files
nnoremap <C-p> :FuzzyGrep<CR>
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_map = '<Leader>f'
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>u :CtrlPUndo<CR>

" ternjs
nnoremap <Leader>trn :TernRename<CR>
nnoremap <Leader>tgd :TernDef<CR>

" snippets
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

" auto pair
let g:AutoPairsShortcutToggle=""

" nerdtred
let g:NERDTreeWinSize=40
autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" autoclose vim if only nerd tree is left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowLineNumbers=1
set encoding=utf8

" gitgutter
let g:gitgutter_map_key = 0
set updatetime=100

" performance
set lazyredraw

" Fuzzy finder
let g:fuzzy_opencmd = 'edit'

" fugitive
set diffopt+=vertical

" snippets
let g:UltiSnipsEditSplit="vertical"

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    highlight link TabNum Special
  endif
