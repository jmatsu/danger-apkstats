# danger-apkstats

A description of danger-apkstats.

## Installation

    $ gem install danger-apkstats

## Usage

    Methods and attributes from this plugin are available in
    your `Dangerfile` under the `apkstats` namespace.

# Sample

```
apkstats.command_type=:apk_analyzer # required
apkstats.apk_filepath='app-debug.apk' # required. It would be a base apk.
apkstats.compare_with('app-other.apk', do_report: true)
apkstats.file_size #=> Integer
apkstats.download_size #=> Integer
apkstats.required_features #=> Array<String>
apkstats.non_required_features #=> Array<String>
apkstats.permissions #=> Array<String>
apkstats.min_sdk #=> String
apkstats.target_sdk #=> String
```

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
