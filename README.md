[![Build Status](https://travis-ci.com/jmatsu/danger-apkstats.svg?branch=master)](https://travis-ci.com/jmatsu/danger-apkstats) [![Gem Version](https://badge.fury.io/rb/danger-apkstats.svg)](https://badge.fury.io/rb/danger-apkstats)

# danger-apkstats

A description of danger-apkstats.

## Installation

    $ gem install danger-apkstats

## Usage

    Methods and attributes from this plugin are available in
    your `Dangerfile` under the `apkstats` namespace.

# Sample

```
apkstats.apk_filepath='app-debug.apk' # required.
apkstats.compare_with('app-other.apk', do_report: true)
apkstats.file_size #=> Fixnum
apkstats.download_size #=> Fixnum
apkstats.required_features #=> Array<String> | Nil
apkstats.non_required_features #=> Array<String> | Nil
apkstats.permissions #=> Array<String> | Nil
apkstats.min_sdk #=> String | Nil
apkstats.target_sdk #=> String | Nils
```

## Compare apk files

The report will be like below.

### Apk comparision results

Property | Summary  
:--- | :---
New File Size | 1621248 Bytes. (1.55 MB
File Size Change | -13352 Bytes. (-13.04 KB)
Download Size Change | +41141 Bytes. (+40.18 KB)
Removed Required Features | - android.hardware.camera
Removed Non-required Features | - android.hardware.camera.front (not-required)
Removed Permissions | - android.permission.INTERNET<br>- android.permission.CAMERA

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
