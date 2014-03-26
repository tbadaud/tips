set t_ku=OA
set t_kd=OB
set t_kr=OC
set t_kl=OD

set background=dark
syntax on
filetype indent on
filetype plugin on

" Pathogen load
" https://github.com/tpope/vim-pathogen
filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on
syntax on

" https://github.com/klen/python-mode
"

" set nocompatible "Supprime la compatibilité avec Vi pour éviter les bugs"
" syn on " Active la coloration syntaxique"
" filetype indent plugin on " Active l'indentation automatique"
" set number "Affiche le numéro des lignes"
" set tabstop =4 "La touche Tab insert 4 espaces"
" set shiftwidth =4 "On indente de 4 espaces"
" set softtabstop=4 "Une suppression supprime les 4 espaces d'un coup"
" set expandtab "Supprime les tabulations et met des espaces"
" set incsearch "La recherche commence dès qu'on tape le premier caractère"
" set ignorecase "La recherche ne prend pas en compte la casse"
" set smartcase "Si le mot recherché contient au minimum une majuscule alors
" la recherche prend en compte la casse"
