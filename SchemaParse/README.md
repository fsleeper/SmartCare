# SchemaParse

### Usage:
Usage: app [options]

  Options:

    -h, --help                    output usage information
    -V, --version                 output the version number
    -f, --files [file/directory]  The file or directory of files to parse
    -e, --ext [extension]         The extension of files to process, such as json, txt or use --ext none for files with NO extension

### Description:
**SchemaParse** will parse the directory specified for all files, each file containing 1 or more schema documents, matching the schema to a list of defined schemas to determine what each JSON is:

The first check is to look for the header information that can tell the application what the JSON document is SUPPOSED to be (**schemaInfo** field):
```
{
    "schemaInfo": {
        "applicationNamespace": "someappname.Namespace",
        "method": "theAppMethod",
        "version": "theAppVersion"
    }
}
```
For example, assume you have:
- An application named **"SongPal"**.  
- The method that is being called (or identified as) is **"getHome"**.  
- The app version to be used is **"1.0.2"**

The schemaInfo would be:
```
{
    "schemaInfo": {
        "applicationNamespace": "song.songpal",
        "method": "getHome",
        "version": "1.0.2"
    }
}
```

The above will force the schema lookup to load all the schema information contained in the schema folder:
s3://smartcareschema/sony/songpal/1.0.2/getHome/
