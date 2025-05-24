if [ "$1" = "development" ]; then
    echo "Running in development mode"
    flutter run --target lib/main_development.dart -d chrome --web-browser-flag "--disable-web-security"
elif [ "$1" = "production" ]; then
    echo "Running in production mode"
    flutter run --target lib/main_production.dart -d chrome --web-browser-flag "--disable-web-security"
else
    # default to development
    echo "Running in development mode"
    flutter run --target lib/main_development.dart -d chrome --web-browser-flag "--disable-web-security"
fi
