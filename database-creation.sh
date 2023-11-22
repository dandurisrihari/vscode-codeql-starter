#!/bin/bash

# Check if the hss-database directory exists
if [ ! -d "hss-database" ]; then
    # If not, create the hss-database directory
    mkdir hss-database
fi

# Array of URLs
urls=(
"https://ftp.gnu.org/pub/gnu/gettext/gettext-0.22.3.tar.gz"
"https://ftp.gnu.org/gnu/cflow/cflow-latest.tar.gz"
"https://ftp.gnu.org/gnu/autogen/rel5.18.16/autogen-5.18.16.tar.gz"
"https://ftp.gnu.org/gnu/libextractor/libextractor-latest.tar.gz"
"https://ftp.gnu.org/gnu/a2ps/a2ps-4.15.tar.gz"
# "http://mirror.math.ucdavis.edu/ubuntu//pool/main/libs/libsmbios/libsmbios_2.4.3.orig.tar.gz"
# "http://mirror.math.ucdavis.edu/ubuntu//pool/main/e/edk2/edk2_2022.02.orig.tar.xz"
# "http://mirror.math.ucdavis.edu/ubuntu//pool/main/s/seabios/seabios_1.15.0.orig.tar.gz"
# "http://mirror.math.ucdavis.edu/ubuntu//pool/main/e/efibootmgr/efibootmgr_17.orig.tar.gz"
# "http://mirror.math.ucdavis.edu/ubuntu//pool/main/u/u-boot/u-boot_2022.01+dfsg.orig.tar.xz"
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
    # Go in to extracted directory and create the CodeQL database
    cd ${file%.tar.gz}
    # Use only alphanumeric characters for the database name
    # Loop over the URLs
    for url in ${urls[@]}; do
        # Get the file name
        file=$(basename $url)
        # Extract only alphanumeric characters from the file name
        file=$(echo $file | tr -cd '[:alnum:]')
        # Create the database name
        db_name="${file}-db"
        # Remove any non-alphanumeric characters from the database name
        db_name=$(echo $db_name | tr -cd '[:alnum:]')
        # Create the CodeQL database
        codeql database create $db_name --language=cpp --overwrite
    done

# codeql database create ../hss-database/seabios-db --language=cpp --overwrite
# codeql database analyze --rerun /home/sri/Desktop/HSS_codeql/vscode-codeql-starter/hss-database/libsmbios-db/ --format=sarif-latest --output=codeqlresults/codeqlresults_1.sarif /home/sri/Desktop/HSS_codeql/vscode-codeql-starter/ql/cpp/ql/src/codeql-suites/cpp-security-extended.qls

#codeql database analyze --rerun /home/sri/Desktop/HSS_codeql/vscode-codeql-starter/hss-database/u-boot-db/ --format=sarif-latest --output=codeqlresults/codeqlresults_2.sarif /home/sri/Desktop/HSS_codeql/vscode-codeql-starter/ql/cpp/ql/src/codeql-suites/cpp-security-extended.qls
# /home/sri/Desktop/HSS_codeql/vscode-codeql-starter/hss-database/libsmbios-2.4.3
# codeql database analyze --rerun libsmbios-db/ --format=sarif-latest --output=codeqlresults_libsmbios.sarif --download codeql/cpp-queries:codeql-suites/cpp-security-extended.qls