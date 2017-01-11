# S3 Backup Docker image

Docker image that performs periodic backups on a chosen directory and then uploads the results to Amazon S3. It was initially made by Andrés García Mangas for MongoDB backups: https://github.com/agmangas/mongo-backup-s3
I refactored the code to backup whole directories.

Based on the [dbader/schedule](https://github.com/dbader/schedule) Python scheduling package.

## Configuration

The following table describes the available configuration environment variables.

Name | Description | Default
--- | --- | ---
`BACKUP_SOURCE` | Name of the directory to backup, that must be connected to the container as a volume at location */data/${BACKUPSOURCE}* | *Required*
`S3_BUCKET` | Amazon S3 bucket name | *Required*
`AWS_ACCESS_KEY_ID` | Amazon AWS access key | *Required*
`AWS_SECRET_ACCESS_KEY` | Amazon AWS secret | *Required*
`BACKUP_INTERVAL` | Interval between each backup (days) | `1`
`BACKUP_TIME` | Hour of the day at which the backup will be executed | `2:00`
`DATE_FORMAT` | Date format string used as the suffix of the backup filename | `%Y%m%d-%H%M%S`
`FILE_PREFIX` | Prefix of the backup filename | `backup-`

## Example

The following command starts a *wiki-backups* container that will stay in the background uploading backups of the *wiki* directory on the *my-mongo-host* MongoDB instance every day at 2:00. The backups will be uploaded to an S3 bucket named *my-s3-bucket*:

```
docker run -d -e BACKUP_SOURCE=wiki -v CUSTOM_PATH/wiki:/data/wiki -e S3_BUCKET=my-s3-bucket -e AWS_ACCESS_KEY_ID=<your_access_key> -e AWS_SECRET_ACCESS_KEY=<your_access_secret> -e BACKUP_INTERVAL=1 --name wiki_backups wojzag/directory-backup
```
