import Firebase
import RxSwift

//Authentication Extension Methods
public extension Reactive where Base: FQuery {
    /**
     - Returns: An `Observable<FAuthData?>`, `FAuthData?` will be nil if the user is logged out.
     */
    var authObservable :Observable<FAuthData?> {
        get {
            return Observable.create({ (observer: AnyObserver<FAuthData?>) -> Disposable in
                let ref = self.base.ref!;
                let listener = ref.observeAuthEvent({ (authData: FAuthData?) -> Void in
                    observer.on(.next(authData))
                })
                
                return Disposables.create {
                    self.base.ref.removeAuthEventObserver(withHandle: listener)
                }
            })
        }
    }
    
    func authUser(_ email: String, password: String) -> Observable<FAuthData> {
        let query = self.base;
        
        return Observable.create({ (observer: AnyObserver<FAuthData>) -> Disposable in
            query.ref.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
                if let error = error {
                    observer.on(.error(error))
                }else{
                    observer.on(.next(authData!))
                    observer.on(.completed)
                }
            })
            return Disposables.create()
        })
    }
    
    
    func authAnonymously() -> Observable<FAuthData> {
        let query = self.base;
        
        return Observable.create({ (observer: AnyObserver<FAuthData>) -> Disposable in
            query.ref.authAnonymously(completionBlock: { (error, authData) -> Void in
                if let error = error {
                    observer.on(.error(error))
                }else{
                    observer.on(.next(authData!))
                    observer.on(.completed)
                }
            })
            return Disposables.create()
        })
    }
    
    func authWithOAuthProvider(_ provider: String, parameters: [AnyHashable: Any]) -> Observable<FAuthData> {
        let query = self.base
        return Observable.create({ (observer: AnyObserver<FAuthData>) -> Disposable in
            query.ref.auth(withOAuthProvider: provider, parameters: parameters, withCompletionBlock: { (error, authData) -> Void in
                if let error = error {
                    observer.on(.error(error))
                }else{
                    observer.on(.next(authData!))
                    observer.on(.completed)
                }
            })
            return Disposables.create()
        })
    }
    
    
    func authWithOAuthProvider(_ provider: String, token: String) -> Observable<FAuthData> {
        let query = self.base
        return Observable.create({ (observer: AnyObserver<FAuthData>) -> Disposable in
            query.ref.auth(withOAuthProvider: provider, token: token, withCompletionBlock: { (error, authData) -> Void in
                if let error = error {
                    observer.on(.error(error))
                }else{
                    observer.on(.next(authData!))
                    observer.on(.completed)
                }
            })
            return Disposables.create()
        })
    }
    
    func authWithCustomToken(_ customToken: String) -> Observable<FAuthData> {
        let query = self.base
        return Observable.create({ (observer: AnyObserver<FAuthData>) -> Disposable in
            query.ref.auth(withCustomToken: customToken, withCompletionBlock: { (error, authData) -> Void in
                if let error = error {
                    observer.on(.error(error))
                }else{
                    observer.on(.next(authData!))
                    observer.on(.completed)
                }
            })
            return Disposables.create()
        })
    }
    
    func createUser(_ email: String, password: String) -> Observable<[AnyHashable: Any]> {
        let query = self.base
        return Observable.create { (observer : AnyObserver<[AnyHashable: Any]>) -> Disposable in
            query.ref.createUser(email, password: password, withValueCompletionBlock: { (error, value) in
                if let error = error {
                    observer.onError(error)
                }
                if let value = value {
                    observer.onNext(value)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        }
    }
    
    
    func observe(_ eventType: FEventType) -> Observable<FDataSnapshot> {
        return Observable.create( { (observer : AnyObserver<FDataSnapshot>) -> Disposable in
            let listener = self.base.ref.observe(eventType, with: { (snapshot) in
                observer.on(.next(snapshot!))
            }, withCancel: { (error) in
                observer.on(.error(error!))
            })

            return Disposables.create {
                self.base.ref.removeObserver(withHandle: listener)
            }
        })
    }
    /**
     - Returns: A tuple `Observable<(FDataSnapshot, String)>` with the first value as the snapshot and the second value as the sibling key
     */
    func observeWithSiblingKey(_ eventType: FEventType) -> Observable<(FDataSnapshot, String?)> {
        return Observable.create({ (observer : AnyObserver<(FDataSnapshot, String?)>) -> Disposable in
            let listener = self.base.ref.observe(eventType, andPreviousSiblingKeyWith: { (snapshot, siblingKey) in
                let tuple : (FDataSnapshot, String?) = (snapshot!, siblingKey)
                observer.on(.next(tuple))
            }, withCancel: { (error) in
                observer.on(.error(error!))
            })
            
            return Disposables.create {
                self.base.ref.removeObserver(withHandle: listener)
            }
        })
    }
    
    /**
     - Returns: The firebase reference where the update occured
     */
    func updateChildValues(_ values: [NSObject: AnyObject?]) -> Observable<Firebase> {
        return Observable.create({ (observer: AnyObserver<Firebase>) -> Disposable in
            self.base.ref.updateChildValues(values, withCompletionBlock: { (error, firebase) in
                if let error = error {
                    observer.on(.error(error))
                } else{
                    observer.on(.next(firebase!))
                    observer.on(.completed)
                }
            })
            
            return Disposables.create()
        })
    }
    
    func setValue(_ value: AnyObject!, priority: AnyObject? = nil) -> Observable<Firebase> {
        return Observable.create({ (observer: AnyObserver<Firebase>) -> Disposable in
            if let priority = priority {
                self.base.ref.setValue(value, andPriority: priority, withCompletionBlock: { (error, firebase) -> Void in
                    if let error = error {
                        observer.on(.error(error))
                    } else{
                        observer.on(.next(firebase!))
                        observer.on(.completed)
                    }
                })
            }else {
                self.base.ref.setValue(value, withCompletionBlock: { (error, firebase) -> Void in
                    if let error = error {
                        observer.on(.error(error))
                    } else{
                        observer.on(.next(firebase!))
                        observer.on(.completed)
                    }
                })
            }
            return Disposables.create()
        })
    }
    
    func removeValue() -> Observable<Firebase> {
        return Observable.create({ (observer: AnyObserver<Firebase>) -> Disposable in
            self.base.ref.removeValue(completionBlock: { (err, ref) -> Void in
                if let err = err {
                    observer.onError(err)
                }else if let ref = ref {
                    observer.onNext(ref)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
    
    func runTransactionBlock(_ block: ((FMutableData?) -> FTransactionResult?)!) -> Observable<(isCommitted: Bool, snapshot : FDataSnapshot)> {
        return Observable.create({ (observer) -> Disposable in
            self.base.ref.runTransactionBlock(block) { (err, isCommitted, snapshot) -> Void in
                if let err = err {
                    observer.onError(err)
                } else if let snapshot = snapshot {
                    observer.onNext((isCommitted: isCommitted, snapshot: snapshot))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        })
    }
    
    func setPriority(_ priority : AnyObject) -> Observable<Firebase> {
        return Observable.create({ (observer) -> Disposable in
            self.base.ref.setPriority(priority) { (error, ref) -> Void in
                if let error = error {
                    observer.onError(error)
                } else if let ref = ref {
                    observer.onNext(ref)
                    observer.onCompleted()
                }
                
            }
            return Disposables.create()
        })
    }
    
    func onDisconnectSetValue(_ value: AnyObject, priority: AnyObject? = nil) -> Observable<Firebase> {
        return Observable.create({ (observer) -> Disposable in
            if let priority = priority {
                self.base.ref.onDisconnectSetValue(value, andPriority: priority, withCompletionBlock: { (error, ref) -> Void in
                    if let error = error {
                        observer.onError(error)
                    } else if let ref = ref {
                        observer.onNext(ref)
                        observer.onCompleted()
                    }
                })
                return Disposables.create()
            } else {
                self.base.ref.onDisconnectSetValue(value, withCompletionBlock: { (error, ref) -> Void in
                    if let error = error {
                        observer.onError(error)
                    } else if let ref = ref {
                        observer.onNext(ref)
                        observer.onCompleted()
                    }
                })
                return Disposables.create()
            }
        })
    }
    
    func onDisconnectUpdateValue(_ values: [AnyHashable: Any]) -> Observable<Firebase> {
        return Observable.create({ (observer) -> Disposable in
            self.base.ref.onDisconnectUpdateChildValues(values, withCompletionBlock: { (error, ref) -> Void in
                if let error = error {
                    observer.onError(error)
                } else if let ref = ref {
                    observer.onNext(ref)
                    observer.onCompleted()
                }
            })
            
            return Disposables.create()
        })
    }
    
    func onDisconnectRemoveValueWithCompletionBlock() -> Observable<Firebase> {
        return Observable.create({ (observer) -> Disposable in
            self.base.ref.onDisconnectRemoveValue(completionBlock: { (error, ref) -> Void in
                if let error = error {
                    observer.onError(error)
                } else if let ref = ref {
                    observer.onNext(ref)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
    
    
}

public extension ObservableType where E : FDataSnapshot {
    func filterWhenNSNull() -> Observable<E> {
        return self.filter { (snapshot) -> Bool in
            return snapshot.value is NSNull
        }
    }
    
    func filterWhenNotNSNull() -> Observable<E> {
        return self.filter { (snapshot) -> Bool in
            return !(snapshot.value is NSNull)
        }
    }
}


