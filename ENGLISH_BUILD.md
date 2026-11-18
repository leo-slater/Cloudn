# Cloudn English — first translation pass

Branch: `english-v1.4.2` (based on Cloudn v1.4.2). Main remains unchanged.

This is an **initial English translation**, not a complete localization. The main tabs, setup notice, common controls and much of Resolve, Downloads, Accounts, Settings, media browsing, and GitHub screens are translated. Some help text, dynamic notifications, error messages, and deeper screens remain in Chinese.

Only exact user-facing string literals in selected app UI files were changed. Networking code, cloud service adapters, credentials, and signing settings were not intentionally modified.

## Build on an iPhone
1. Open GitHub → this repo → Actions → CI.
2. Select the `english-v1.4.2` branch and run the workflow, or open the run started by the branch push.
3. When the **iOS app** job succeeds, download its `Cloudn-unsigned-ipa` artifact (a ZIP).
4. Extract it in iOS Files to get `Cloudn-unsigned.ipa`, then import into Feather and sign/install it.

Warning: An unsigned IPA cannot be installed directly. Keep a backup of the current app/data, as sideload-signing with a different identity may require uninstalling your existing Cloudn installation. For sensitive cloud logins, assess the exact resulting build before use.
