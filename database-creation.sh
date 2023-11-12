#!/bin/bash

# Check if the hss-database directory exists
if [ ! -d "hss-database" ]; then
    # If not, create the hss-database directory
    mkdir hss-database
fi

# Array of URLs
urls=(
#"https://ftp.gnu.org/pub/gnu/gettext/gettext-0.22.3.tar.gz"
#"https://ftp.gnu.org/gnu/cflow/cflow-latest.tar.gz"
#"https://ftp.gnu.org/gnu/autogen/rel5.18.16/autogen-5.18.16.tar.gz"
"https://ftp.gnu.org/gnu/libextractor/libextractor-latest.tar.gz"
#"https://ftp.gnu.org/gnu/a2ps/a2ps-4.15.tar.gz"
)

# Loop over the URLs
for url in ${urls[@]}; do
    # Get the file name
    file=$(basename $url)
    # Download the file
    wget $url
    # Create a directory for extraction
    mkdir ${file%.tar.gz}
    # Extract the tar.gz file into the created directory
    tar -xzf $file -C ${file%.tar.gz}
    # Get the directory name and split at '-'
    IFS='-' read -r name rest <<< "${file%.tar.gz}"
    # Create the CodeQL database
    codeql database create hss-database/$name-db --language=cpp --source-root=${file%.tar.gz}
    # Remove the tar.gz file
    rm $file
    # Remove the extracted directory
    rm -rf ${file%.tar.gz}
done