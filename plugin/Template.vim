" Version: $Id: Template.vim 199 2008-10-08 07:12:49Z i.feelinglucky $
" File: Template.vim
" Maintainer: feelinglucky<i.feeilnglucky#gmail.com>
" Last Change: 2008/10/08
" Desption: create new file form template

let g:TemplatePath=$VIM.'/vimfiles/Template.vim/'
let g:TemplateCursorFlag='#cursor#'

" {{{ Source
function! NewTemplate(name, mode)
    let s:ext = expand('%:e')
    if s:ext == ""
        let s:ext = expand('%:t')
    endif
        
    if a:mode == 'tab'
        tabnew
    else
        silent execute "new ".a:name
    endif
    
    call LoadTemplate()

endfunction

function! LoadTemplate()
    let s:ext = expand('%:e')
    if s:ext == ""
        let s:ext = expand('%:t')
    endif
        
    let Template=g:TemplatePath.'Template.'.s:ext
  
    if !filereadable(Template)
        echo "Template ".Template.": not exists!"
        return
    endif
   
    normal gg    
    delete

    execute 'setlocal filetype='.s:ext
    silent execute "0r ".Template
    
    call TemplateReplTags()
    unlet Template

    normal G
    if s:ext == "php"
       sil! exec 's/^?>$//'
    endif
    " 取消刪除最後一行
    "delete G    

    let hasfind=search(g:TemplateCursorFlag)
    if hasfind
        let line = getline('.')
        let repl = substitute(line, g:TemplateCursorFlag, '', '')
        call setline('.', repl)
    endif
endfunction

function! TemplateReplTags()
    if g:template_tags_replacing != 1
        return
    endif
    let sl = exists("g:template_replace_start_line") ? g:template_replace_start_line : 1
    let el = exists("g:template_replace_end_line") ? g:template_replace_end_line : "$"
    if exists("g:T_AUTHOR")
        sil! execute sl.','.el."s/<T_AUTHOR>/".g:T_AUTHOR."/g"
    endif
    if exists("g:T_AUTHOR_EMAIL")
        sil! execute sl.','.el."s/<T_AUTHOR_EMAIL>/".g:T_AUTHOR_EMAIL."/g"
    endif
    if exists("g:T_AUTHOR_WEBSITE")
        sil! execute sl.','.el."s=<T_AUTHOR_WEBSITE>=".g:T_AUTHOR_WEBSITE."=g"
    endif
    if exists("g:T_LICENSE")
        sil! execute sl.','.el."s/<T_LICENSE>/".g:T_LICENSE."/g"
    endif
    if exists("g:T_DATE_FORMAT") 
        sil! execute sl.','.el."s/<T_CREATE_DATE>/".strftime(g:T_DATE_FORMAT)."/g"
    endif   

    let s:fn = expand('%:t')
    sil! execute sl.','.el."s/<T_FILENAME>/".s:fn."/g"
    unlet s:fn
endfunction

com! -nargs=1 -range=% LoadTemplate call LoadTemplate()
com! -nargs=1 -range=% NewTemplate call NewTemplate(<f-args>, 'window')
if v:version > 700
    com! -nargs=1 -range=% NewTemplateTab call NewTemplate(<f-args>, 'tab')
endif
