#!/bin/bash

set -e

: ${S3_BUCKET:?}
: ${AWS_ACCESS_KEY_ID:?}
: ${AWS_SECRET_ACCESS_KEY:?}
: ${DATE_FORMAT:?}
: ${FILE_PREFIX:?}
: ${BACKUP_SOURCE}

FOLDER=/backup

FILE_NAME=${FILE_PREFIX}$(date -u +${DATE_FORMAT}).tar.gz

echo "Creating backup folder..."

rm -fr ${FOLDER} && mkdir -p ${FOLDER} && cd ${FOLDER}

echo "Starting backup..."

cp -rf /data/${BACKUP_SOURCE} ${BACKUP_SOURCE}

echo "Compressing backup..."

tar -zcvf ${FILE_NAME} ${BACKUP_SOURCE} && rm -fr ${BACKUP_SOURCE}

echo "Uploading to S3..."

aws s3api put-object --bucket ${S3_BUCKET} --key ${FILE_NAME} --body ${FILE_NAME}

echo "Removing backup file..."

rm -f ${FILE_NAME}

echo "Done!"
