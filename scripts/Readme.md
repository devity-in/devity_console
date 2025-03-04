## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production


The script accepts 3 arguments. First one is the artifact apk, appbundle or ios. 
Second one is the build type release, debug or profile. 
Third one is the build flavor, development, staging or production.

```sh
# Running debug for development
./run.sh apk debug development

# Building debug for development
./build.sh apk debug development

# Building debug for staging
./build.sh apk debug staging

# Building Release APK for Production
./build.sh apk release production
```