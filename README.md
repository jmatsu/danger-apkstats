[![jmatsu](https://circleci.com/gh/jmatsu/danger-apkstats.svg?style=shield)](https://circleci.com/gh/jmatsu/danger-apkstats) [![Gem Version](https://badge.fury.io/rb/danger-apkstats.svg)](https://badge.fury.io/rb/danger-apkstats)

# danger-apkstats

This is a plugin of [Danger](https://github.com/danger/danger) for Android projects.
This allows you to get attributes of your application file (apk) and report a summary of comparison between two application files.

## Installation

`gem install danger-apkstats` or add `danger-apkstats` to your Gemfile.

Please include `apkanalyzer` in your PATH or specify the path of apkanalyzer in your Dangerfile.

```ruby
apkstats.apkanalyzer_path='/path/to/apkanalyzer'
```

NOTE: Inferring the path of apkanalyzer by using ANDROID_HOME and/or ANDROID_SDK_ROOT will be removed since version 0.4.

## Usage

`apkstats` namespace is available under Dangerfile.
    
### Required preparation

```
apkstats.apk_filepath='app-debug.apk' # required.
```

### Show attributes

```
apkstats.file_size #=> Fixnum
apkstats.download_size #=> Fixnum
apkstats.required_features #=> Array<String> | Nil
apkstats.non_required_features #=> Array<String> | Nil
apkstats.permissions #=> Array<String> | Nil
apkstats.min_sdk #=> String | Nil
apkstats.target_sdk #=> String | Nils
apkstats.reference_count #=> Fixnum
apkstats.dex_count #=> Fixnum
```

### Get a comparison report

```
apkstats.compare_with(String, do_report: Boolean)
```

For example, the report will be like below.

Property | Summary  
:--- | :---
New File Size | 1621248 Bytes. (1.55 MB)
File Size Change | -13352 Bytes. (-13.04 KB)
Download Size Change | +41141 Bytes. (+40.18 KB)
Removed Required Features | - android.hardware.camera
Removed Non-required Features | - android.hardware.camera.front (not-required)
Removed Permissions | - android.permission.INTERNET<br>- android.permission.CAMERA
New Number of dex file(s) | 15720
Number of dex file(s) Change | 1

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.

### Supported ruby versions

Support only versions which are in normal and/or security maintenance.

ref: https://www.ruby-lang.org/en/downloads/branches/

### Supported JDK versions

Depends on `apkanalyzer`. Please read the official document and set up your environment. The following sections might be your help.

#### If your are using less than Java 9

`$ANDROID_HOME/tools/bin/apkanalyzer` is compatible with your environment. 

This binary would throw `java.lang.NoClassDefFoundError: javax/xml/bind/annotation/XmlSchema` when running on Java 9 or later.

#### If you are using Java 9 or later

`$ANDROID_HOME/cmdline-tools/latest/bin/apkanalyzer` is compatible.