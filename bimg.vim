function! Bimg()

"find path
execute("normal! \"aya>")
let l:path_pattern = 'src="\zs[a-zA-Z0-9/.]\+\ze"'
let l:image_path = matchstr(@a, l:path_pattern)

"check if it's an <img> tag and if it has src="" attribute
if (l:image_path == "")
	echo 'No "src=" attribute'
	return
endif

"get new size
"let l:image_path = expand("<cfile>")

python << PYTHONEND

from PIL import Image
import vim

image_file = vim.eval("l:image_path")
try:
	img = Image.open(image_file)
	width, height = img.size
	vim.command("let l:width = " + str(width))
	vim.command("let l:height = " + str(height))
except IOError:
	vim.command("echo 'File not found!'")

PYTHONEND

"remove any existing width and height values
let l:pattern_1 = 'height=[a-zA-Z0-9"]*'
let l:pattern_2 = 'width=[a-zA-Z0-9"]*'
let l:newtag = substitute(@a, l:pattern_1, "", "g")
let l:newtag = substitute(l:newtag, l:pattern_2, "", "g")

"get rid of multiple spaces
let l:newtag = substitute(l:newtag, '\s\+', ' ', "g")

"update the tag
if (exists("l:width") && exists("l:height"))
	let l:newtag = substitute(l:newtag, '\(src=[a-zA-Z0-9/."]\+\)', '\1 width="' . l:width . '" height="' . l:height . '"', "")
	let @a = l:newtag
	execute("normal! va>\"ap")
endif

endfunction

