autocmd FileType vim setlocal keywordprg=:help
autocmd FileType lua setlocal keywordprg=:help


" Plugins: vim-plug"
" Add fzf to runtime path
set rtp+=~/scoop/apps/fzf/current
" Initialize config dictionary for fzf.vim
let g:fzf_vim = {}
" Automatically install missing plugins on startup"
autocmd VimEnter *
    \   if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|    PlugInstall --sync | q
    \|  endif

" H to open help docs"
" function! s:plug_doc()
"     let name = matchstr(getline('.'), '^- zs\S\+\ze: ')
"     if has_key(g:plugs,name)
" 	for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), 'n')
" 	    execute 'table' doc
" 	endfor
"     endif
" endfunction
"
"augroup PlugHelp
"    autocmd!
"    autocmd FileType vim-plug nnoremap <buffer> <silent> H :call <sid>plug_doc()<cr>
"augroup END
"
" <Leader>gx to open GitHub URLs on browser		    "
" Press <Leader>gx to open the GitHub URL for a plugin or a commit with the default "
" browser"
function! s:plug_gx()
  let line = getline('.')
  let sha  = matchstr(line, '^  \X*\zs\x\{7,9}\ze ')
  let name = empty(sha) ? matchstr(line, '^[-x+] \zs[^:]\+\ze:')
                      \ : getline(search('^- .*:$', 'bn'))[2:-2]
  let uri  = get(get(g:plugs, name, {}), 'uri', '')
  if uri !~ 'github.com'
    return
  endif
  let repo = matchstr(uri, '[^:/]*/'.name)
  let url  = empty(sha) ? 'https://github.com/'.repo
                      \ : printf('https://github.com/%s/commit/%s', repo, sha)
  call netrw#BrowseX(url, 0)
endfunction

augroup PlugGx
  autocmd!
  autocmd FileType vim-plug nnoremap <buffer> <silent> gx :call <sid>plug_gx()<cr>
augroup END

" Browse help files and README.md"
" Requires fzf"
function! s:plug_help_source()
  let lines = []
  let longest = keys(g:plugs)->map({_, v -> strlen(v)})->max()
  for [name, plug] in items(g:plugs)
    let matches = []
    for pat in ['doc/*.txt', 'README.md']
      let match = get(split(globpath(plug.dir, pat), '\n'), 0, '')
      if len(match)
        call add(lines, printf('%-'..longest..'s\t%s\t%s', name, fnamemodify(match, ':t'), match))
      endif
    endfor
  endfor
  return sort(lines)
endfunction,

command! PlugHelp call fzf#run(fzf#wrap({
  \ 'source': s:plug_help_source(),
  \ 'sink':   { line -> execute('tabedit '..split(line)[-1]) },
  \ 'options': ['--reverse', '--delimiter=\t', '--with-nth=1..2', '--preview', 'bat --style=numbers --color=always {-1}']}))

" UltiSnips
let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit=["UltiSnips"]
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" Triggers
let g:UltiSnipsExpandOrJumpTrigger = "<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" CustomFunctions
autocmd! User UltiSnipsEnterFirstSnippet
autocmd User UltiSnipsEnterFirstSnippet call CustomInnerKeyMapper()
autocmd! User UltiSnipsExitLastSnippet
autocmd User UltiSnipsExitLastSnippet call CustomInnerKeyUnmapper()


" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Telescope
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" vim-sort-motion
let g:sort_motion_flags = 'i'

" Fix icon width for Nerd Fonts v3.2.1.
call setcellwidths([
\   [ 0x23fb, 0x23fe, 2 ],
\   [ 0x2665, 0x2665, 2 ],
\   [ 0x2b58, 0x2b58, 2 ],
\   [ 0xe000, 0xe00a, 2 ],
\   [ 0xe0c0, 0xe0c8, 2 ],
\   [ 0xe0ca, 0xe0ca, 2 ],
\   [ 0xe0cc, 0xe0d7, 2 ],
\   [ 0xe200, 0xe2a9, 2 ],
\   [ 0xe300, 0xe3e3, 2 ],
\   [ 0xe5fa, 0xe6b5, 2 ],
\   [ 0xe700, 0xe7c5, 2 ],
\   [ 0xea60, 0xec1e, 2 ],
\   [ 0xed00, 0xefce, 2 ],
\   [ 0xf000, 0xf2ff, 2 ],
\   [ 0xf300, 0xf375, 2 ],
\   [ 0xf400, 0xf533, 2 ],
\   [ 0xf0001, 0xf1af0, 2 ],
\ ])

" LuaSnips
" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
" -1 for jumping backwards.
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'

lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
			{ name = 'cmdline', },
			{ name = 'path', },
    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]-- 

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['vimls'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['lua_ls'].setup {
    capabilities = capabilities
  }
EOF

lua print('config.vim')
lua dump = require('plugins.dump')
