#!/bin/bash

# Устанавливаем переменные
PREFIX="/your/prefix/path"  # Замените на ваш путь
TEMP_DIR="/tmp/mobox_temp"
URL="https://github.com/Snap888/Test/releases/download/mobox_wow64/"
GITHUB_URLS=(
    "box64-binaries.tar.xz"
    "dxvk.tar.xz"
    "en-ru-locale.tar.xz"
    "glibc-prefix.tar.xz"
    "glibc_package_manager.tar.gz"
    "libudev.tar.xz"
    "prefix-apps.tar.xz"
    "scripts.tar.xz"
    "turnip.tar.xz"
    "virgl-mesa.tar.xz"
    "wine-9.3-vanilla-wow64.tar.xz"
    "wined3d.tar.xz"
)

# Проверка наличия необходимых команд
command -v wget >/dev/null 2>&1 || { echo >&2 "wget не установлен. Установите wget и попробуйте снова."; exit 1; }
command -v tar >/dev/null 2>&1 || { echo >&2 "tar не установлен. Установите tar и попробуйте снова."; exit 1; }

# Проверка существования директории PREFIX
if [ ! -d "$PREFIX" ]; then
    echo "Директория $PREFIX не существует. Создайте её и попробуйте снова."
    exit 1
fi

# Создаем временную директорию
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR" || { echo "Не удалось перейти в директорию $TEMP_DIR"; exit 1; }

# Скачиваем и распаковываем файлы
for file in "${GITHUB_URLS[@]}"; do
    url="$URL$file"
    echo "Скачивание $file..."
    wget "$url"
    
    if [ $? -eq 0 ]; then
        echo "Распаковка $file..."
        tar -xf "$file" -C "$PREFIX"
        
        if [ $? -eq 0 ]; then
            echo "Распаковка $file успешно завершена."
            rm "$file"  # Удаляем архив после успешной распаковки
        else
            echo "Ошибка при распаковке $file."
            exit 1
        fi
    else
        echo "Ошибка при скачивании $file."
        exit 1
    fi
done

# Создаем символическую ссылку
LINK_SOURCE="$PREFIX/glibc/opt/scripts/mobox"
LINK_TARGET="$PREFIX/bin/mobox"

if [ -f "$LINK_SOURCE" ]; then
    mkdir -p "$PREFIX/bin"
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
