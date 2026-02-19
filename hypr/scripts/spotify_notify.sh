player="spotify"

# Loop contínuo monitorando mudanças de faixa
playerctl --player=$player metadata --follow \
  --format '{{mpris:artUrl}}|{{title}}|{{artist}}' |
while IFS='|' read -r art_url title artist; do

  # Cria pasta temporária para imagens
  tmp_dir="/tmp/spotify-art"
  mkdir -p "$tmp_dir"

  # Define o caminho do arquivo da capa
  art_file="$tmp_dir/cover.jpg"

  # Baixa a capa (normalmente o link vem do open.spotify.com ou i.scdn.co)
  if [[ "$art_url" =~ ^https?:// ]]; then
    curl -s "$art_url" -o "$art_file"
  else
    # Caso não tenha imagem (ex: podcast), limpa arquivo anterior
    rm -f "$art_file"
  fi

  # Monta a notificação sem emoji
  if [[ -f "$art_file" ]]; then
    notify-send \
      -i "$art_file" \
      "$title" \
      "$artist" \
      -h string:x-dunst-stack-tag:spotify
  else
    notify-send \
      "$title" \
      "$artist" \
      -h string:x-dunst-stack-tag:spotify
  fi

done
