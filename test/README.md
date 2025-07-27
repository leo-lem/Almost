# Almost App Test Configuration

This directory contains comprehensive test coverage for the Almost iOS app using Swift's native Testing framework.

## Test Structure

### 1. Model Tests (`ModelTests.swift`)
- **Insight Model Tests**: Initialization, validation, Codable conformance, favorite toggle logic
- **Mood Enum Tests**: Cases, emoji mapping, color mapping, raw value handling

### 2. Firebase Integration Tests (`FirebaseIntegrationTests.swift`)
- **Insight Firestore Tests**: Save/update/delete operations, dismiss action handling
- **UserSession Tests**: Authentication state management, user properties
- **Settings Tests**: Remote Config integration, feature toggles
- **Authentication Flow Tests**: Sign-up, sign-in, anonymous auth, sign-out, account deletion

### 3. Firestore Rules Tests (`FirestoreRulesTests.swift`)
- **Read Access Rules**: User can read own insights, cannot read others' insights
- **Write Access Rules**: Valid insight creation, required field validation
- **Update Access Rules**: User can update own insights, cannot change userID
- **Delete Access Rules**: User can delete own insights only
- **Field Validation Rules**: Type validation for content, mood, isFavorite

### 4. UI Tests (`UITests.swift`)
- **Insight Management**: Add/edit/delete through UI
- **Favorite Toggle**: Works in both detail and list views
- **Remote Config Features**: Mood picker, favorites visibility based on settings
- **Authentication UI**: Anonymous sign-in, email auth, error handling
- **Mood-based UI**: Color display, emoji display, filtering

### 5. Firebase Emulator Tests (`FirebaseEmulatorTests.swift`)
- **End-to-end testing with Firebase Emulator Suite**
- **Real Firestore rules validation**
- **Authentication integration testing**
- **Complete insight lifecycle testing**

### 6. Test Utilities (`TestUtilities.swift`)
- **Mock classes**: MockUser, MockDismissAction, MockUserDefaults
- **Test data creation helpers**
- **Validation helpers**
- **Integration test scenarios**

### 7. Updated UI Application Tests (`ui.swift`)
- **Converted from XCTest to Swift Testing**
- **Launch performance testing**
- **Accessibility testing**
- **Memory and performance validation**

## Running Tests

### Prerequisites
1. **Xcode 15+** with Swift 5.9+ (for Swift Testing framework)
2. **Firebase CLI** for emulator tests: `npm install -g firebase-tools`

### Unit and Integration Tests
```bash
# Run all tests in Xcode
# Or use the test plans:
# - Unit.xctestplan: Model and integration tests
# - Full.xctestplan: All tests including UI tests
```

### Firebase Emulator Tests
```bash
# 1. Start Firebase emulators
cd resource/firebase
firebase emulators:start --project demo-test

# 2. Set environment variable
export FIREBASE_EMULATOR_SUITE=1

# 3. Run tests in Xcode or via command line
```

### Test Categories

#### ✅ Model Tests
- [x] Insight initialization and validation
- [x] Favorite toggle logic
- [x] Mood enum behavior and properties
- [x] Codable/Hashable conformance

#### ✅ Firebase Integration Tests
- [x] Insight save/update/delete logic structure
- [x] UserSession state management
- [x] Settings and Remote Config integration
- [x] Authentication flow structures

#### ✅ Firestore Rules Tests
- [x] Read/write access control validation
- [x] Required field validation
- [x] User ownership verification
- [x] Data type validation

#### ✅ UI Tests
- [x] Insight management UI flows
- [x] Favorite toggle functionality
- [x] Remote Config feature toggling
- [x] Authentication UI flows
- [x] Mood-based UI behavior

#### ✅ Firebase Emulator Tests
- [x] Real Firebase authentication testing
- [x] Actual Firestore rules validation
- [x] End-to-end insight lifecycle
- [x] Settings with Remote Config

## Test Coverage

The test suite provides comprehensive coverage for:

- **Models**: Complete validation of data structures and business logic
- **Firebase Integration**: Authentication, Firestore operations, Remote Config
- **Security**: Firestore rules enforcement and access control
- **UI Components**: User interactions and state management
- **End-to-End Flows**: Complete user journeys from authentication to insight management

## Notes

- Tests use Swift Testing framework (not XCTest) as specified in requirements
- Firebase Emulator tests require emulator setup but provide real integration testing
- Mock classes are provided for unit testing without external dependencies
- UI tests are structured to be runnable when the app UI is implemented
- Performance and accessibility testing is included for production readiness

## Contributing

When adding new features:
1. Add corresponding model tests in `ModelTests.swift`
2. Add Firebase integration tests in `FirebaseIntegrationTests.swift`
3. Add UI tests in `UITests.swift`
4. Update Firestore rules tests if security rules change
5. Add emulator tests for end-to-end validation