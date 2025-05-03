#!/bin/bash

# --- Настройки ---
DOTFILES_DIR="$HOME/dotfiles"       # Путь к dotfiles
BACKUP_BASE_DIR="$DOTFILES_DIR/backups" # Базовая папка для бэкапов
DATE=$(date +"%Y-%m-%d_%H-%M-%S")   # Формат даты для папки бэкапа
BACKUP_DIR="$BACKUP_BASE_DIR/$DATE" # Полный путь к папке конкретного бэкапа

# --- Проверяем, существует ли dotfiles ---
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "❌ Папка dotfiles не найдена: $DOTFILES_DIR"
    exit 1
fi

# --- Ищем конфликтующие файлы ---
echo "⏳ Поиск конфликтующих файлов..."
CONFLICTS=()
shopt -s dotglob # Включаем поиск скрытых файлов (*)
shopt -s nullglob # Если нет совпадений, find не выдаст ошибку

for package_dir in "$DOTFILES_DIR"/*/; do
    package=$(basename "$package_dir")

    # Пропускаем не-пакеты (например, сам backups)
    if [ "$package" == "backups" ] || [ ! -d "$package_dir" ]; then
        continue
    fi

    # echo "Проверяем пакет: $package" # Раскомментируйте для отладки

    # Ищем файлы в пакете (обратите внимание на -mindepth 1)
    while IFS= read -r -d $'\0' file; do
        # Получаем относительный путь файла внутри пакета
        relative_path=${file#"$package_dir"}
        # Формируем целевой путь в $HOME
        target_file="$HOME/$relative_path"

        # echo "  Проверяем файл: $file -> $target_file" # Раскомментируйте для отладки

        # Проверяем, существует ли целевой файл и не является ли он симлинком
        if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
            # echo "    КОНФЛИКТ: $target_file существует и не симлинк." # Раскомментируйте для отладки
            CONFLICTS+=("$target_file")
        fi
    done < <(find "$package_dir" -mindepth 1 -type f -print0) # Используем find и null-терминаторы для надежности

done

shopt -u dotglob nullglob # Возвращаем настройки glob по умолчанию

# --- Если нет конфликтов, выходим ---
if [ ${#CONFLICTS[@]} -eq 0 ]; then
    echo "✅ Нет конфликтующих файлов. Можно безопасно запускать stow."
    exit 0
fi

# --- Сообщаем о конфликтах и создаем папку бэкапа ---
echo "🔍 Найдены конфликтующие файлы:"
# Убираем дубликаты, если один и тот же файл мог быть найден из разных пакетов (маловероятно, но возможно)
UNIQUE_CONFLICTS=($(printf "%s\n" "${CONFLICTS[@]}" | sort -u))

# Создаем папку для бэкапа ТОЛЬКО СЕЙЧАС
echo "Создание папки для бэкапа: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
if [ $? -ne 0 ]; then
    echo "❌ Не удалось создать папку для бэкапа: $BACKUP_DIR"
    exit 1
fi

# --- Делаем бэкапы ---
echo "Создание резервных копий:"
for file in "${UNIQUE_CONFLICTS[@]}"; do
    relative_path_for_backup=${file#"$HOME/"} # Относительный путь для структуры в бэкапе
    backup_target_path="$BACKUP_DIR/$relative_path_for_backup"
    backup_target_dir=$(dirname "$backup_target_path")

    # Создаем нужную структуру папок внутри бэкапа
    mkdir -p "$backup_target_dir"

    echo "  - Копирование '$file' в '$backup_target_path'"
    cp -L -v "$file" "$backup_target_path" # -L разыменовывает симлинки, если они вдруг попались
done

echo "📦 Бэкапы сохранены в: $BACKUP_DIR/"

# --- (Опционально) Запуск stow ---
# read -p "Запустить stow --adopt для найденных конфликтов? (y/N) " -n 1 -r
# echo
# if [[ $REPLY =~ ^[Yy]$ ]]; then
#     echo "Запуск 'stow --adopt */' из $DOTFILES_DIR..."
#     cd "$DOTFILES_DIR" && stow -v --adopt */
#     echo "✅ Stow adopt завершен."
# else
#     echo "ℹ️ Бэкапы созданы. Запустите 'stow' вручную, если необходимо."
# fi

exit 0

