#!/bin/sh
#
# permission retriever
#
# Description:
#   File permission retrieving tool
#
# Usage:
#   permretr.sh TARGET_DIR
#
#   TARGET_DIR:
#     target directory
#     (e.g. copied git/SVN checkout root directory)
#
USAGE="${0} TARGET_DIR"

# Check user privileges
if [ "$(id -u)" != 0 ]; then
    echo "Error: this script is root privileges required."
    exit 1
fi

# Check arguments
if [ $# -lt 1 ]; then
    echo "Usage: ${USAGE}"
    exit 1
fi

# Check target directory
if [ ! -d "${1}" ]; then
    echo "Error: ${1}: no such directory."
    exit 1
fi

# Check exist config file
BASE_DIR="${1%*/}"
CONFIG_FILE="${BASE_DIR}/.perm"

if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Error: ${CONFIG_FILE}: config file not found."
    exit 1
fi

# Change file pemissions from config file
grep -v '^#' "${CONFIG_FILE}" | \
while IFS=';' read -r s_owner s_group s_perm s_file
do
    FILENAME="${BASE_DIR}/${s_file#/*}"

    if [ -f "${FILENAME}" ]; then
        echo "file: ${FILENAME}"
        printf "bef: "; ls -l "${FILENAME}"

        chmod "${s_perm}" "${FILENAME}"
        chown "${s_owner}:${s_group}" "${FILENAME}"

        printf "aft: "; ls -l "${FILENAME}"
        echo 
    fi
done

exit 0
