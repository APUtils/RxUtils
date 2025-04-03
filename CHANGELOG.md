# Change Log
All notable changes to this project will be documented in this file.
`RxUtils` adheres to [Semantic Versioning](http://semver.org/).


## [5.0.0](https://github.com/APUtils/RxUtils/releases/tag/5.0.0)
Released on `2025-04-01`

#### Added

- [BackgroundSafeTimer] Default value for `period`
- [BackgroundSafeTimer] Support for Driver
- [BackgroundSafeTimer] `.never` `period` handle
- [Completable] `asObservableJustReturn(_:)`
- [Completable] `share(scope:)`
- [Error] `asRxError`
- [FlatMapThrottle] Restricted to `Single` operations
- [FlatMapThrottle] `flatMapThrottleCompletable` method
- [MapToCount] New operators `mapToCount`
- [Maybe] `retry(_ behavior:scheduler:shouldRetry:)`
- [ObservableType, ObservableConvertibleType] `distinctUntilChanged()` for tuple of 3 and 4 equatable elements
- [ObservableType, ObservableConvertibleType] `distinctUntilChanged()` for tuple of equatable elements
- [OperationsQueue] `addOperation(_:)
- [Resubscribe] operator
- [Resubscribe] public for `Single` extension
- [Resubscribe] `label` parameter
- [Single] `compactMap`
- [Tests] `Resubscribe` operator tests
- [TimeInterval] `asRxTimeInterval` crash fix
- [TimeMeasure] `measureExecutionTimeOnNext(start:end:)`
- [UIApplication] `didLeaveActive`
- [UIApplication] `didLeaveBackgroundAndBecameActive`
- [UITableViewDiffableDataSource] Public access
- [UITableViewDiffableDataSource] Rx support


## [4.3.0](https://github.com/APUtils/RxUtils/releases/tag/4.3.0)
Released on 2024-03-25.

#### Added
- [Assert] operators
- [BehaviorRelay] `asBinder()`
- [CatchAndReturn] closure-variant operators
- [ControlEvent] `merge` operator
- [filterMany] for optional collections
- [Maybe] distinctUntilChangedWeakly()
- [Maybe] distinctWeakly()
- [ObservableType] distinctUntilChangedWeakly()
- [ObservableType] distinctWeakly()
- [Single] distinctUntilChangedWeakly()
- [Single] distinctWeakly()
- [SortMany] Operator
- [ThrottledTap] added
- [TimeMeasure] measureExecutionTime(_:)
- [UIAlertController] `showPicker(title:message:cancelTitle:actionTitles:)`
- [UIApplication] `didMoveToBackground`
- [UNUserNotificationCenter] reactive support
- `catchErrorJustComplete` operator with optional `onError` closure for `Single` and `Maybe`

#### Changed
- catchErrorJustComplete > catchAndComplete
- iOS 13.0 for example project
- Use `ConcurrentMainScheduler.instance` instead of `MainScheduler.instance`
- [MapToVoid] operator rework to log double `Void` mappings
- [UIAlertController] Return index and title as picker result


## [4.2.0](https://github.com/APUtils/RxUtils/releases/tag/4.2.0)
Released on 2023-04-10.

#### Added
- SPM support
- [Maybe] asCompletable()
- [Maybe] flatMap(_:) for Single


## [4.1.2](https://github.com/APUtils/RxUtils/releases/tag/4.1.2)
Released on 2023-01-26.

#### Added
- [Completable] andThenDeffered(_:)
- [Completable] preventDisposal(disposeBag:)
- [TimeZone] rx.current

#### Changed
- Check read-write keychain status
- [Completable] made `doOnCompleted` throwable
- Min iOS version 11.0


## [4.0.0](https://github.com/APUtils/RxUtils/releases/tag/4.0.0)
Released on 2022-07-30.

#### Added
- BackgroundSafeTimer operator
- Completable .assertNoErrors()
- DispatchQueueScheduler alwaysAsync init parameter
- EventsProcessor
- KeychainState.notReadable(status:) doc
- NopeScheduler
- ObservableObserver
- ObservableObserverType
- RoutableLogger dependency
- [Completable] subscribeOnDisposed(_:)
- [Driver] withPrevious()
- [Driver] withRequiredPrevious()
- [Maybe] mapToAny()
- [Maybe] subscribeOnDisposed(_:)
- [ObservableType] .assertNoErrors()
- [ObservableType] mapToAny()
- [Single] .assertNoErrors()
- [Single] filterEmpty()
- [Single] mapToAny()
- [Single] subscribeOnDisposed(_:)
- [UIApplication.KeychainState] statusMessage
- [UIViewController] present(_:animated:)
- {DispatchQueueScheduler} background
- {ObservableType<[Element]?>} mapMany(_:)

#### Changed
- Do not check `isFirstUnlockHappened` below 100 MB of free space
- preventDisposal() -> preventDisposal(disposeBag:)
- RxSwift+Error+ObservableType -> RxSwift+Error+ObservableConvertibleType
- Simplified and more robust `asRxTimeInterval` conversion

#### Fixed
- Fixed background timer schedule drift
- mapToError fix

## [3.0.0](https://github.com/APUtils/RxUtils/releases/tag/3.0.0)
Released on 11/18/2021.

#### Added
- Completable .retry(_:scheduler:shouldRetry:)
- Completable .retryIf(_:)
- DispatchQueueScheduler.main
- Driver .mapMany(_:)
- Driver .reloadOnLeaveBackground()
- Maybe .filterMany(_:)
- Maybe .flatMapCompletable(_:)
- Maybe .flatMapObservable(_:)
- Maybe .mapMany(_:)
- ObservableType .flatMapLatestCompletable(_:)
- ObservableType .reloadOnLeaveBackground()
- ObservableType .retryIf(_:)
- RxTimeInterval .asTimeInterval
- RxTimeInterval: CustomStringConvertible
- Single .errorOnNil(_:)
- Single .retryIf(_:)
- Single .share(scope:)
- TimeInterval .asRxTimeInterval
- UIApplication .didLeaveBackground
- UIApplication .didLeaveBackgroundWithTimeInterval
- UILabel .rx.textColor

#### Changed
- Carthage is deprecated
- Dependency on APExtensions/Occupiable and APExtensions/OptionalType
- Moved RxOptional code to the framework directly

#### Fixed
- .preventDisposal() deadlock fix

## [2.0.0](https://github.com/APUtils/RxUtils/releases/tag/2.0.0)
Released on 11/01/2021.

#### Added
- .withPrevious() for optional Element
- Added .filterMany for ObservableType of collections of elements
- Added ObservableType .catchErrorIfHadElement()
- Completable .catchErrorJustComplete()
- Completable .mapError
- Completable .mapErrorTo
- Completable .showContinueAlert(title:message:continue:cancel:)
- Completable .showOkAlert(title:message:ok:)
- DispatchQueueScheduler
- Do operations for Maybe
- Do operators for Completable trait
- Driver + Do operators
- flatMapFirst for Void element
- Maybe .mapToVoid()
- Maybe .preventCancellation()
- Maybe .wrapIntoOptional()
- Observable + do after operators
- Observable .preventCancellation()
- ObservableConvertibleType .flatMapAlert(title:message:actions:_:)
- ObservableConvertibleType .flatMapThrottle(scheduler:selector:)
- ObservableConvertibleType .showContinueAlert(title:message:continue:cancel:)
- ObservableConvertibleType .showOkAlert(title:message:ok:)
- ObservableType .asSafeSingle()
- ObservableType .catchErrorJustComplete(_:)
- ObservableType .doOnEmpty
- ObservableType .errorIfNoElements()
- ObservableType .skipFirstIf(_:)
- ObservableType .skipFirstIfFalse()
- ObservableType .withRequiredPrevious()
- ObservableType .wrapIntoOptional()
- OptionalType to work with extensions for optional Elements
- preventCancellation -> preventDisposal
- ProcessInfo .rx.lowPowerModeEnabled
- RxSwiftExt dependency
- Signal .mapToVoid()
- Single .filterMany(_:)
- Single .filterNil()
- Single .flatMapCompletable(_:)
- Single .flatMapObservable(_:)
- Single .mapError
- Single .mapErrorTo
- Single .mapMany(_:)
- Single .mapToVoid()
- Single .pausableBuffered(_:)
- Single .preventCancellation()
- Single .retry(_:scheduler:shouldRetry:)
- Single .showContinueAlert(title:message:continue:cancel:)
- Single .showOkAlert(title:message:ok:)
- Single .subscribeOnError(_:)
- Single .subscribeOnSuccess(_:)
- Single .wrapIntoOptional()
- SPM support
- Subscribe operators for Completable
- Subscribe operators for Maybe
- UIApplication .rx.backgroundRefreshStatus
- UIApplication .rx.isKeychainReadable
- UIApplication.shared.rx.isFirstUnlockHappened
- UIApplication.shared.rx.isProtectedDataAvailable
- UIDevice .rx.batteryLevel
- UIDevice .rx.batteryState
- UIScrollView .rx.contentInset
- UIScrollView .rx.contentSize
- UIScrollView .rx.currentPage
- UIScrollView .rx.numberOfPages
- UIScrollView .rx.pageSize
- UIView .rx.bounds
- UIView .rx.tintColor
- UIViewController .rx.viewDidAppear
- UIViewController .rx.viewDidDisappear
- UIViewController .rx.viewDidLayoutSubviews
- UIViewController .rx.viewDidLoad
- UIViewController .rx.viewWillAppear
- UIViewController .rx.viewWillDisappear
- UIViewController .rx.viewWillLayoutSubviews

#### Changed
- .subscribe(on: ConcurrentMainScheduler.instance) for UI extensions
- compareWithPrevious thread safety
- distinctUntilChanged for applicationState
- Removed @autoclosure for .startWithDeferred(_:) so it'll be obvious that parameter is captured
- Removed OptionalType protocol and using RxOptional one instead

#### Fixed
- Better memory usage for .withPrevious() operators
- preventDisposal unexpected observer capture fix


## [1.3.3](https://github.com/APUtils/RxUtils/releases/tag/1.3.3)
Released on 08/16/2019.

#### Fixed
- Public for weak map

#### Removed
- Timer .rx.scheduledTimer(withTimeInterval:repeats:)


## [1.3.2](https://github.com/APUtils/RxUtils/releases/tag/1.3.2)
Released on 08/16/2019.

#### Added
- Timer .rx.scheduledTimer(withTimeInterval:repeats:)


## [1.3.1](https://github.com/APUtils/RxUtils/releases/tag/1.3.1)
Released on 08/09/2019.

#### Added
- ObservableType .mapToVoid()
- ObservableType .withPrevious()
- RxSwift+Weak+CatchError+ObservableType
- Signal .emitOnCompleted(_:)
- Signal .emitOnDisposed(_:)
- Signal .emitOnNext(_:)

#### Fixed
- CompareResult .isNew and .isSame computation


## [1.3.0](https://github.com/APUtils/RxUtils/releases/tag/1.3.0)
Released on 07/15/2019.

#### Added
- Added convenience computed properties for CompareResult

#### Changed
- CompareResult now also returns previous value for same case


## [1.2.0](https://github.com/APUtils/RxUtils/releases/tag/1.2.0)
Released on 07/15/2019.

#### Added
- ObservableType .compareWithPrevious(_:)
- ObservableType .compareWithPrevious()
- Driver .compareWithPrevious(_:)
- Driver .compareWithPrevious()


## [1.1.6](https://github.com/APUtils/RxUtils/releases/tag/1.1.6)
Released on 07/12/2019.

#### Added
- Driver .doOnNext(weak:_:)
- Single .doOnSubscribe(_:)
- Single .doOnSubscribed(_:)
- Single .doOnSuccess(_:)
- Single .doOnError(_:)
- Single .doOnDispose(_:)


## [1.1.5](https://github.com/APUtils/RxUtils/releases/tag/1.1.5)
Released on 05/30/2019.

#### Added
- Single .doOnSuccess(weak:_:)
- Single .doOnError(weak:_:)


## [1.1.3](https://github.com/APUtils/RxUtils/releases/tag/1.1.3)
Released on 05/23/2019.

#### Removed
- RxSwift .compactMap(_:) because RxSwift already have it



## [1.1.1](https://github.com/APUtils/RxUtils/releases/tag/1.1.1)
Released on 05/21/2019.

#### Fixed
- Podspec fix


## [1.1.0](https://github.com/APUtils/RxUtils/releases/tag/1.1.0)
Released on 05/21/2019.

#### Added
- RxCocoa .compactMap(_:)
- RxCocoa .map(weak:_:)
- RxSwift .map(weak:_:)
- RxSwift latest support
- Swift 5 support

#### Fixed
- Deprecation warnings

#### Dropped
- iOS 8.0 is no longer supported


## [1.0.3](https://github.com/APUtils/RxUtils/releases/tag/1.0.3)
Released on 05/17/2019.

#### Added
- RxCocoa .driveOnNext(_:)
- RxCocoa .driveOnCompleted(_:)
- RxCocoa .driveOnDisposed(_:)


## [1.0.2](https://github.com/APUtils/RxUtils/releases/tag/1.0.2)
Released on 04/19/2019.

#### Fixed
- public extension


## [1.0.1](https://github.com/APUtils/RxUtils/releases/tag/1.0.1)
Released on 04/19/2019.

#### Added
- UIApplication .rx.applicationState
- RxSwift .compactMap(_:)
- RxSwift .startWithDeferred(_:)
- RxSwift .doOnSubscribe(_:)
- RxSwift .doOnSubscribed(_:)
- RxSwift .doOnNext(_:)
- RxSwift .doOnError(_:)
- RxSwift .doOnCompleted(_:)
- RxSwift .doOnDispose(_:)
- RxSwift .mapError(_:)
- RxSwift .mapErrorTo(_:)
- RxSwift .filterWithLatestFrom(_:)
- RxSwift .filterEqualWithLatestFrom(_:)
- RxSwift .subscribeOnNext(_:)
- RxSwift .subscribeOnError(_:)
- RxSwift .subscribeOnCompleted(_:)
- RxSwift .subscribeOnDisposed(_:)
- RxSwift .doOnNext(weak:_:)
- RxSwift .doOnError(weak:_:)
- RxSwift .doOnCompleted(weak:_:)
- RxSwift .flatMapFirst(weak:_:)
- RxSwift .flatMapLatest(weak:_:)
- RxSwift .flatMap(weak:_:)
- RxSwift .subscribeOnNext(weak:_:)
