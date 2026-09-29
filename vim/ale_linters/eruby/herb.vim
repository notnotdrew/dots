" Description: Herb linter (@herb-tools/linter) for ERB templates.
" Lives in dots (vim/ is ~/.vim) because vim/plugged is not tracked.
" herb-lint has no stdin mode and only lints paths under its cwd, so this
" runs against the saved file from the nearest .herb.yml directory.

call ale#Set('eruby_herb_executable', 'herb-lint')
call ale#Set('eruby_herb_options', '')
call ale#Set('eruby_herb_use_global', get(g:, 'ale_use_global_executables', 0))

function! ale_linters#eruby#herb#GetExecutable(buffer) abort
    return ale#path#FindExecutable(a:buffer, 'eruby_herb', [
    \   'node_modules/.bin/herb-lint',
    \])
endfunction

function! ale_linters#eruby#herb#GetCwd(buffer) abort
    let l:config = ale#path#FindNearestFile(a:buffer, '.herb.yml')

    return empty(l:config) ? '%s:h' : fnamemodify(l:config, ':h')
endfunction

function! ale_linters#eruby#herb#GetCommand(buffer) abort
    return ale#Escape(ale_linters#eruby#herb#GetExecutable(a:buffer))
    \   . ' --json --no-color'
    \   . ale#Pad(ale#Var(a:buffer, 'eruby_herb_options'))
    \   . ' %s'
endfunction

function! s:Type(severity) abort
    if a:severity is# 'error'
        return 'E'
    elseif a:severity is# 'warning'
        return 'W'
    endif

    " info, hint, and anything Herb adds later.
    return 'I'
endfunction

function! ale_linters#eruby#herb#Handle(buffer, lines) abort
    let l:report = ale#util#FuzzyJSONDecode(a:lines, {})
    let l:output = []

    " Herb columns are 0-based; end is exclusive.
    for l:offense in get(l:report, 'offenses', [])
        let l:start = get(l:offense.location, 'start', {})
        let l:end = get(l:offense.location, 'end', {})
        let l:item = {
        \   'lnum': get(l:start, 'line', 1) + 0,
        \   'col': get(l:start, 'column', 0) + 1,
        \   'code': get(l:offense, 'code', ''),
        \   'text': get(l:offense, 'message', ''),
        \   'type': s:Type(get(l:offense, 'severity', '')),
        \}

        if has_key(l:end, 'line') && has_key(l:end, 'column')
            let l:item.end_lnum = l:end.line + 0
            let l:item.end_col = l:end.column + 0
        endif

        call add(l:output, l:item)
    endfor

    return l:output
endfunction

call ale#linter#Define('eruby', {
\   'name': 'herb',
\   'executable': function('ale_linters#eruby#herb#GetExecutable'),
\   'cwd': function('ale_linters#eruby#herb#GetCwd'),
\   'command': function('ale_linters#eruby#herb#GetCommand'),
\   'callback': 'ale_linters#eruby#herb#Handle',
\   'lint_file': 1,
\})
