# Change Log
All notable changes to this project will be documented in this file.
`RxUtils` adheres to [Semantic Versioning](http://semver.org/).


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
