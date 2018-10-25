# SOLR migration

This script use some lucene libraries, we have just included a couple of jars (and the license information) to keep the download size small.

You can download the full library from these urls:

* Lucene 5.5.5: http://www.apache.org/dyn/closer.lua/lucene/java/5.5.5
* Lucene 6.6.5: http://www.apache.org/dyn/closer.lua/lucene/java/6.6.5
* Lucene 7.5.0: http://www.apache.org/dyn/closer.lua/lucene/java/7.5.0

## Usage

#### Migrate an existing solr index

```
./migrate.sh indexDir [-v|--verbose] [-n|--dry-run]
```

  * `-v` or `--verbose` enable some more logging.
  * `-n` or `--dry-run` do not perform the migration but only checks for the index directory existence.

The migration is an inplace upgrade so it is an **unreversible** operation, make sure you have backups in place.

It is impossible to migrate from the 5.x version to 7.x directly so the script will migrate to 5.x, than repeat the migration to 6.x and finally the last migration to 7.x.\
If an index is already migrated, the script will not modify it, so it is safe to execute it on an already migrated script.

#### Help

```
./migrate.sh -h|--help
```

  * show the usage information

An help will be shown on the screen

#### Version

```
./migrate.sh --version
```

  * show the current version
