<img src="reponomadx-logo.jpg" alt="reponomadx logo" width="250"/></img>
# macOS Elevated Admin Rights with Workspace ONE

[![Platform](https://img.shields.io/badge/Platform-macOS-lightgrey)](https://www.apple.com/macos/)
[![Workspace ONE](https://img.shields.io/badge/Workspace%20ONE-UEM-blue)](https://www.vmware.com/products/workspace-one.html)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Active-success)]()

> Grant temporary admin rights to macOS users using Workspace ONE UEM and a dummy app deployment — no scripting required.

---

## 📖 Summary

This workflow enables macOS users to be granted **temporary administrator access** using Workspace ONE UEM. It uses a dummy `.pkg` file that installs no actual software but contains a postinstall script that adds the current console user to the `admin` group.

The process is managed entirely through the Workspace ONE console — no external scripts, APIs, or custom workflows are required.

---

## 🧰 Requirements

- Workspace ONE UEM Console access  
- macOS devices enrolled via DEP or MDM  
- Download the [Packages App](http://s.sudre.free.fr/files/Packages_1211_dev.dmg) by WhiteBox
  (This is the latest developer build with bug fixes; mount and install the `.dmg` after download)
- Workspace ONE Admin access to create Smart Groups and Internal Apps  

---

## 📦 Step 1: Create a Dummy Package

We are going to use a dummy package to deliver post-install and post-uninstall scripts.  
Use the [Packages App](http://s.sudre.free.fr/files/Packages_1211_dev.dmg) to create this.

1. Open Packages App. Pick **Raw Package** and click **Next**
2. Give it a name. (Example: `macOS Admin Elevation`)
3. Go to the **Build** menu, and click **Build**
4. Your package will be in the **project directory under `/build`**
5. Use the [Workspace ONE Admin Assistant Tool](https://docs.omnissa.com/bundle/Admin-AssistantVSaaS/page/Download.html) to create the Plist for uploading to the UEM console.

<img src="Packages App 1.avif" alt="Packages App Template"/></img>

<img src="Packages App 2.avif" alt="Packages App Name"/></img>

<img src="Packages App 3.avif" alt="Packages App Build"/></img>

<img src="Packages App 4.avif" alt="Packages App Location"/></img>


---

## 👥 Step 2: Create a Smart Group

Create a Smart Group that will control which devices receive the elevated rights package.

Steps:

1. In the Workspace ONE Console, go to:  
   **Groups & Settings > Groups > Assignment Groups**
2. Click **Add Smart Group**
3. Name the group (e.g., `macOS Admin Elevation`)
4. Configure assignment logic:
   - Manually assign devices  
   - Or use a Tag (e.g., `MacOS Admin Elevation`) for dynamic membership

<img src="Smart Group.jpg" alt="Smart Group"/></img>

> ✅ Any device added to this Smart Group will receive the app and be granted admin rights.

---

## 🚀 Step 3: Upload and Assign the App

Upload the `.pkg` to Workspace ONE as an Internal App.

Steps:

1. In the Workspace ONE Console, go to:  
   **Apps > Native > Internal > Add Application**
2. Upload the file: `macOS Admin Elevation.pkg`
3. Upload the Plist created by the Workspace ONE Admin Assistant tool
4. Set the **Post-Install Script** and **Post-Uninstall Script** as shown below
5. (Optional) Give it an icon
6. Click **Save & Assign**
7. Click **Add Assignment**
8. Assign to the Smart Group from Step 2.  
   You can use **Auto** or **On-Demand** assignment
9. Click **Add**, then **Save & Publish**

### 📝 Post-Install Script:
```bash
#!/bin/bash

loggedInUser=`/usr/bin/stat -f%Su /dev/console`

if [ "$CurrentUser" == "root" ] || [ "$CurrentUser" == "_mbsetupuser" ]; then
  exit 0
fi

#adds user to admin group (post-install)
dseditgroup -o edit -a "$loggedInUser" -t user admin
```

### 📝 Post-Uninstall Script:
```bash
#!/bin/bash

loggedInUser=`/usr/bin/stat -f%Su /dev/console`

if [ "$CurrentUser" == "root" ] || [ "$CurrentUser" == "_mbsetupuser" ]; then
  exit 0
fi

#removes user from the admin group (post-uninstall)
dseditgroup -o edit -d "$loggedInUser" -t user admin
```

---

## 🔄 Removing Admin Rights

To revoke admin rights:

1. Remove the device from the Smart Group  
   (e.g., delete the `macOS Admin Elevation` tag)
2. Workspace ONE will uninstall the dummy package

---

## 📄 License

MIT License – see [LICENSE](LICENSE) for full details.

---
