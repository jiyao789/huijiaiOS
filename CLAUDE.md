# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an iOS application for a property/real estate management platform (惠家/Huijia) built with Objective-C. The app provides features for property listings, lifestyle services, owner delegation, and user management.

**Target Platform:** iOS 12.0+
**Language:** Objective-C
**Dependency Management:** CocoaPods
**Build System:** Xcode

## Build & Development Commands

### Initial Setup
```bash
# Install CocoaPods dependencies
pod install

# Always open the workspace (NOT the .xcodeproj)
open StandardApplication.xcworkspace
```

### Building

#### Using the Build Script (Recommended)
```bash
# Build for real device (default)
./build.sh
# or explicitly
./build.sh device

# Build for simulator (Intel x86_64)
./build.sh simulator
```

#### Manual Build Commands

**For Real Device:**
```bash
xcodebuild -workspace StandardApplication.xcworkspace \
           -scheme StandardApplication \
           -configuration Debug \
           -sdk iphoneos \
           build \
           ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO \
           ENABLE_DEBUG_DYLIB=NO \
           CODE_SIGN_IDENTITY="" \
           CODE_SIGNING_REQUIRED=NO \
           CODE_SIGNING_ALLOWED=NO
```

**For Simulator (Intel x86_64 only):**
```bash
xcodebuild -workspace StandardApplication.xcworkspace \
           -scheme StandardApplication \
           -configuration Debug \
           -sdk iphonesimulator \
           build \
           ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO \
           ENABLE_DEBUG_DYLIB=NO \
           ARCHS=x86_64 \
           VALID_ARCHS=x86_64 \
           ONLY_ACTIVE_ARCH=YES
```

**For Release:**
```bash
xcodebuild -workspace StandardApplication.xcworkspace \
           -scheme StandardApplication \
           -configuration Release \
           -sdk iphoneos \
           build \
           ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO \
           ENABLE_DEBUG_DYLIB=NO \
           CODE_SIGN_IDENTITY="" \
           CODE_SIGNING_REQUIRED=NO \
           CODE_SIGNING_ALLOWED=NO
```

**Important Build Notes:**
- `ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO` - Required because this is an Objective-C project
- `ENABLE_DEBUG_DYLIB=NO` - Prevents debug dylib generation errors
- Code signing disabled for development builds
- If you encounter "Build input file cannot be found: StandardApplication.debug.dylib" errors, ensure these flags are set

**Simulator vs Device:**
- Some dependencies (WeChat SDK, TTLock, etc.) have arm64 slices compiled for real iOS devices only
- On Apple Silicon Macs, these dependencies are NOT compatible with arm64 iOS Simulator
- **Solution**: Build for **x86_64 simulator** (Intel architecture) which runs under Rosetta
- The x86_64 builds work because these SDKs include x86_64 slices for simulator support

**Executable Locations:**
- Real device: `~/Library/Developer/Xcode/DerivedData/StandardApplication-<hash>/Build/Products/Debug-iphoneos/StandardApplication.app/StandardApplication`
- Simulator: `~/Library/Developer/Xcode/DerivedData/StandardApplication-<hash>/Build/Products/Debug-iphonesimulator/StandardApplication.app/StandardApplication`

### Testing
```bash
# Run tests
xcodebuild test -workspace StandardApplication.xcworkspace -scheme StandardApplication -destination 'platform=iOS Simulator,name=iPhone 14'
```

### Working with Dependencies
```bash
# Update pods
pod update

# Install specific pod
pod install --repo-update
```

## Architecture & Code Structure

### Main Application Structure

```
StandardApplication/
├── Base/                    # Base view controllers and core UI components
│   ├── BaseViewController   # Parent class for all view controllers
│   ├── BaseNavigationViewController
│   ├── BaseTabbarController # Tab bar with 5 main sections
│   └── NoMsgView            # Empty state view
├── Classes/                 # Feature modules (MVC pattern)
│   ├── Home/               # Homepage & property listings
│   ├── House/              # Property search & filtering
│   ├── Life/               # Lifestyle services
│   ├── Owner/              # Owner delegation features
│   ├── My/                 # User profile & settings
│   ├── Login/              # Authentication
│   ├── Wait/               # Waitlist/pending features
│   └── WaitNew/            # New waitlist implementation
├── Common/                  # Shared configuration & definitions
│   ├── MacroDefine.h       # Global macros, imports, and constants
│   ├── YDInterfaceDefinition.h  # API endpoint definitions
│   ├── ECLocationManager   # Location services wrapper
│   └── ECUUIDTool          # Device UUID management
├── Utils/                   # Utility classes
│   ├── HttpRequest         # Network request wrapper (AFNetworking)
│   ├── CommonUtils         # Common helper functions
│   ├── UploadFileManager   # File upload management
│   └── SNCache             # Local caching
├── Category/                # Objective-C categories/extensions
│   ├── Color/              # UIColor extensions
│   ├── Image/              # UIImage extensions
│   └── [Various categories for UIView, NSString, NSDate, etc.]
├── Libs/                    # Third-party libraries & custom components
└── Custom/                  # Custom UI components
    ├── BaseShadowView
    ├── PSBarButtonItem
    └── YDProgressView
```

### MVC Pattern

Each feature module in `Classes/` follows the MVC pattern:
- **Model/**: Data models (using MJExtension for JSON mapping)
- **View/**: Custom views and UI components
- **Controller/**: View controllers managing UI logic

### Key Architectural Components

#### 1. Navigation System
- Uses `GKNavigationBarViewController` for custom navigation
- All view controllers inherit from `BaseViewController`
- Navigation is wrapped in `BaseNavigationViewController`
- Supports full-screen pop gestures and custom navigation bar styling

#### 2. Tab Bar Structure
The app has 5 main tabs (defined in `BaseTabbarController`):
1. **Home** (`HomeViewController`) - Homepage & property listings
2. **House** (`HouseViewController`) - Property search
3. **Life** (`LifeViewController`) - Lifestyle services
4. **Owner** (`OwnerNewBaseViewController`) - Owner delegation
5. **My** (`MyViewController`) - User profile

#### 3. Network Layer
- `HttpRequest` class wraps AFNetworking
- API endpoints defined in `YDInterfaceDefinition.h`
- Base URLs configured for different environments (alpha/beta/pre)
- Supports GET/POST requests with built-in caching via `BaseNetworkCache`

#### 4. User Management
- `User` singleton manages authentication state
- Stores token, userId, mobile, and device ID
- Uses local storage for session persistence

#### 5. Theme System
- Uses `LEETheme` for theming support
- Custom color extensions in `Category/Color/`
- Supports barrier-free (accessibility) mode

## Key Dependencies

### Essential Pods
- **AFNetworking**: Network requests
- **MJExtension/MJRefresh**: JSON parsing and pull-to-refresh
- **SDWebImage**: Image loading and caching
- **Masonry**: Auto Layout DSL
- **ReactiveCocoa (2.1.8)**: Functional reactive programming
- **GKNavigationBarViewController**: Custom navigation
- **IQKeyboardManager**: Keyboard handling

### Integration SDKs
- **AMap** (高德地图): Maps and location (NO-IDFA versions)
- **TTLock**: Smart lock/Bluetooth integration
- **AliPlayerSDK**: Video player (via SJVideoPlayer)
- **WechatOpenSDK/AliPay_SDK**: Payment integrations
- **UMShare**: Social sharing (WeChat reduced)
- **Bugly**: Crash reporting
- **MatomoTracker**: Analytics

### UI Components
- **JXCategoryView**: Category/segment views
- **FSCalendar**: Calendar component
- **QMUIKit**: UI utilities
- **YYText/YYModel**: Text rendering and model parsing

## Important Files

### Configuration Files
- **MacroDefine.h**: Central import file for all commonly used headers and macros. Includes convenience macros for properties, screen dimensions, and global UI constants.
- **YDInterfaceDefinition.h**: All API endpoint definitions and base URLs. Switch between production/beta/pre environments by commenting/uncommenting URL definitions.
- **Info.plist**: App configuration, permissions, URL schemes

### Entry Points
- **AppDelegate.m**: App initialization, SDK setup, navigation configuration
- **BaseTabbarController.m**: Main tab bar setup

### Shared Resources
- **User.h/m**: User session management singleton
- **CommonUtils.h/m**: Common utility methods
- **HttpRequest.h/m**: Network request abstraction

## Development Patterns

### Adding New Features
1. Create new folder in `Classes/` with Model/View/Controller subfolders
2. Inherit controllers from `BaseViewController`
3. Define API endpoints in `YDInterfaceDefinition.h`
4. Use `HttpRequest` for network calls
5. Use MJExtension for JSON-to-model mapping

### Navigation Customization
BaseViewController provides extensive navigation customization:
- `navTitle`, `navTitleColor`, `navTitleFont` - Title styling
- `navBackgroundColor`, `naviBarAlpha` - Background styling
- `hideNaviBar`, `hideNavLine` - Visibility control
- Methods for adding custom bar button items

### Network Requests
```objc
[HttpRequest requestUrlPath:@"serverId"
                    urlPath:endpoint
                 parameters:params
                       type:HttpRequestTypePost
                     result:^(NSDictionary *dic, NSInteger status, NSString *msg) {
    // Handle response
}];
```

### Pull-to-Refresh
```objc
[self setupRefreshWithTableView:self.tableView];
// Implement headerRefreshloadData and footerRefreshloadData
```

## Environment Configuration

API environments are controlled in `YDInterfaceDefinition.h`:
- **Production**: `alpha.huichenghuijia.com`
- **Beta**: `beta.fujuhaofang.com` (commented out)
- **Pre-production**: `pre.fujuhaofang.com` (commented out)

To switch environments, comment/uncomment the appropriate BaseURL definitions.

## Build Configuration Notes

### Code Signing
CocoaPods are configured with code signing disabled in the Podfile post_install hook. This is intentional for development.

### Swift Standard Libraries
The project sets `ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = NO` for all pods to avoid conflicts.

### Debug Tools
- **LookinServer**: UI debugging (Debug configuration only)
- **Bugly**: Crash reporting and diagnostics

## Third-Party Service Integration

### Location Services
- AMap API Key configured in AppDelegate: `40ec7df263df9014c185bcd45a4e8f03`
- Uses NO-IDFA versions of AMap pods for privacy compliance

### Smart Lock
- TTLock SDK for Bluetooth smart lock integration
- Initialized in `application:didFinishLaunchingWithOptions:`

### Video Player
- Uses SJVideoPlayer with AliPlayer backend
- Configuration available in AppDelegate

### Analytics
- Matomo tracker integration in `Utils/MatomoTracker/`
- Custom tracker class: `MatomoTrackerClass`
