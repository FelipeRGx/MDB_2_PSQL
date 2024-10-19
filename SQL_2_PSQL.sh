#!/bin/bash

DATABASE="nombre_de_tu_base_de_datos"
USER="felipe"

# Cambia al directorio donde se encuentran los archivos SQL
cd /ruta/del/directorio/con/archivos/sql

# Adaptar los archivos SQL reemplazando corchetes con comillas dobles
for file in *.sql; do
    sed -i 's/\[/"/g' "$file"
    sed -i 's/\]/"/g' "$file"
done

# Para cada archivo SQL adaptado
for file in *.sql; do
    # Deriva el nombre de la tabla del nombre del archivo (sin extensión)
    tablename=$(basename "$file" .sql)

    # Comprueba si la tabla existe
    if ! sudo -u $USER psql $DATABASE -tAc "SELECT 1 FROM pg_tables WHERE tablename = '$tablename'" | grep -q 1; then
        # Si la tabla no existe, créala
        echo "CREATE TABLE \"$tablename\" ();" | sudo -u $USER psql $DATABASE
    fi

    # Extraer las columnas del archivo SQL
    COLUMNS=$(awk -F'(' '/INSERT INTO/ {print $2}' "$file" | cut -d ")" -f 1)

    # Dividir las columnas en un array
    IFS=',' read -ra COLUMN_LIST <<< "$COLUMNS"

    # Generar SQL para verificar y agregar columnas si no existen
    for COLUMN in "${COLUMN_LIST[@]}"; do
        TRIMMED_COLUMN=$(echo $COLUMN | tr -d ' "')
        CHECK_COLUMN_SQL="DO \$\$ BEGIN IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = '$tablename' AND column_name = '$TRIMMED_COLUMN') THEN ALTER TABLE \"$tablename\" ADD COLUMN \"$TRIMMED_COLUMN\" TEXT; END IF; END \$\$;"
        
        # Ejecutar el SQL para verificar y agregar la columna
        sudo -u $USER psql $DATABASE -c "$CHECK_COLUMN_SQL"
    done

    # Una vez que todas las columnas necesarias están presentes, ejecuta el archivo
    sudo -u $USER psql $DATABASE < "$file"
done

echo "Proceso completado."
