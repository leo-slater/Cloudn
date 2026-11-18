# Cloudn v1.4.2 English build

Cloudn follows the iOS app language. This branch packages English and Simplified Chinese resources for the app, share extension, and Download Live Activity. English is the fallback language for the iOS app.

## Download the unsigned IPA

Open GitHub Actions → CI, then choose a successful run on `complete-english-v1.4.2`. Sign in to GitHub and download **Cloudn-unsigned-ipa** from the run’s Artifacts section. Unzip it in Files and import `Cloudn-unsigned.ipa` into Feather. Sign it with your certificate and matching provisioning profile before installing.

## Editing translations

The app and its core package share `CloudnKit/Sources/CloudnKit/Resources/*/Localizable.strings`. The share extension and widget have their own tables. Keep the original key and preserve every positional format argument (for example, `%1$@`), even when English uses a different word order. Use a full sentence when adding a message with dynamic values.

The original error text and platform names remain available to the code that classifies service responses or selects download settings. Translate those values when the app presents them. Provider websites, server-provided messages, repository release notes, filenames, and media content can still appear in their source language. Diagnostic logs and older saved records can also contain original text.
