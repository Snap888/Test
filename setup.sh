#!/bin/bash

# Устанавливаем переменные
PREFIX="/your/prefix/path"  # Замените на ваш путь
TEMP_DIR="/tmp/mobox_temp"
URL=https://github.com/Snap888/Test/releases/download/mobox_wow64/
GITHUB_URLS=(
    "$URL"box64-binaries.tar.xz""
    "$URL"dxvk.tar.xz""
    "$URL"en-ru-locale.tar.xz""
    "$URL"glibc-prefix.tar.xz""
    "$URL"glibc_package_manager.tar.gz""
    "$URL"libudev.tar.xz""
    "$URL"prefix-apps.tar.xz""
    "$URL"scripts.tar.xz""
    "$URL"turnip.tar.xz""
    "$URL"virgl-mesa.tar.xz""
    "$URL"wine-9.3-vanilla-wow64.tar.xz""
    "$URL"wined3d.tar.xz""


)

# Создаем временную директорию
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Скачиваем и распаковываем файлы
for url in "${GITHUB_URLS[@]}"; do
    filename=$(basename "$url")
    echo "Скачивание $filename..."
    wget "$url"
    
    echo "Распаковка $filename..."
    tar -xf "$filename" -C "$PREFIX"
    
    if [ $? -eq 0 ]; then
        echo "Распаковка $filename успешно завершена."
        rm "$filename"  # Удаляем архив после успешной распаковки
    else
        echo "Ошибка при распаковке $filename."
        exit 1
    fi
done

# Создаем символическую ссылку
LINK_SOURCE="$PREFIX/glibc/opt/scripts/mobox"
LINK_TARGET="$PREFIX/bin/mobox"

if [ -f "$LINK_SOURCE" ]; then
    ln -sf "$LINK_SOURCE" "$LINK_TARGET"
    echo "Символическая ссылка создана: $LINK_TARGET -> $LINK_SOURCE"
else
    echo "Файл для ссылки не найден: $LINK_SOURCE"
    exit 1
fi

# Очистка временной директории
rm -rf "$TEMP_DIR"
echo "Временная директория очищена."

echo "Все операции завершены успешно."