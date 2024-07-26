#!/bin/sh

# Função recursiva para renomear diretórios e arquivos
rename_files() {
  for file in "$1"/*; do
    if [ -d "$file" ]; then
      # Renomeia o diretório atual antes de chamar recursivamente
      dir=$(basename "$file")
      new_dir=$(echo "$dir" | iconv -f utf8 -t ascii//TRANSLIT | tr 'A-Z' 'a-z' | tr ' ' '_' | tr -d '-')
      new_dir=$(echo "$new_dir" | tr -s '_') # Remove duplos underlines
      if [ "$dir" != "$new_dir" ]; then
        mv -T "$1/$dir" "$1/$new_dir"
        file="$1/$new_dir" # Atualiza o nome do diretório após a renomeação
      fi
      # Recursivamente renomeia o conteúdo do diretório
      rename_files "$file"
    elif [ -f "$file" ]; then
      # Renomeia o arquivo atual
      filename=$(basename "$file")
      new_filename=$(echo "$filename" | iconv -f utf8 -t ascii//TRANSLIT | tr 'A-Z' 'a-z' | tr ' ' '_' | tr -d '-')
      new_filename=$(echo "$new_filename" | tr -s '_') # Remove duplos underlines
      if [ "$filename" != "$new_filename" ]; then
        mv -T "$1/$filename" "$1/$new_filename"
      fi
    fi
  done
}

root_dir="."

rename_files "$root_dir"
