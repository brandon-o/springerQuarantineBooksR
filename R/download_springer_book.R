# Function that fetchs the pdf file and saves it in the current directory

download_springer_book <- function(book_spec_title, springer_table){

  file_sep <- .Platform$file.sep

  aux <- springer_table %>%
    filter(book_title == book_spec_title) %>%
    arrange(desc(copyright_year)) %>%
    slice(1)

  edition <- aux$edition
  en_book_type <- aux$english_package_name

  # DOWNLOAD PDF FILES
  download_url <- aux$open_url %>%
    GET() %>%
    extract2('url') %>%
    str_replace('book', paste0('content', file_sep, 'pdf')) %>%
    str_replace('%2F', file_sep) %>%
    paste0('.pdf')

  pdf_file = GET(download_url)

  clean_book_title <- str_replace(book_spec_title, '/', '-') # Avoiding '/' special character in filename

  write.filename = file(paste0(clean_book_title, " - ", edition, ".epub"), "wb")
  writeBin(pdf_file$content, write.filename)
  close(write.filename)

  # DOWNLOAD EPUB FILES
  download_url <- aux$open_url %>%
    GET() %>%
    extract2('url') %>%
    str_replace('book', paste0('content', file_sep, 'epub')) %>%
    str_replace('%2F', file_sep) %>%
    paste0('.epub')

  epub_file = GET(download_url)

  clean_book_title <- str_replace(book_spec_title, '/', '-') # Avoiding '/' special character in filename

  write.filename = file(paste0(clean_book_title, " - ", edition, ".epub"), "wb")
  writeBin(epub_file$content, write.filename)
  close(write.filename)
}
