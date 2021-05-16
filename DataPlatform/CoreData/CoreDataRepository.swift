//
//  CoreDataPlatform.h
//  CoreDataRepository
//
//  Created by siva lingam on 13/5/21.
//

import CoreData
import RxSwift
import MagicalRecord
import Domain

protocol CoreDataRepository {
    associatedtype EntityType
    associatedtype ModelType
    
    // MARK: - Mapper
    static func map(from item: ModelType, to entity: EntityType)
    static func item(from entity: EntityType) -> ModelType?
}

extension CoreDataRepository where
    Self.EntityType: NSManagedObject,
    Self.ModelType: CoreDataModel,
    Self.ModelType.IDType: CVarArg {
    
    func all(sortTerm: String? = nil,
             acending: Bool = true,
             with predicate: NSPredicate? = nil,
             limit: Int = 0) -> Observable<[ModelType]> {
        
        return Observable.create { observer in
            let context = NSManagedObjectContext.mr_()
            let request: NSFetchRequest<NSFetchRequestResult>
            if let sortTerm = sortTerm {
                request = EntityType.mr_requestAllSorted(by: sortTerm,
                                                         ascending: acending,
                                                         with: predicate,
                                                         in: context)
            } else {
                request = EntityType.mr_requestAll(with: predicate, in: context)
            }
            if limit > 0 {
                request.fetchLimit = limit
            }
            let items = EntityType.mr_executeFetchRequest(request)
                .flatMap { $0 as? [EntityType] }
                .flatMap { entities -> [ModelType] in
                    return entities.compactMap { Self.item(from: $0) }
                } ?? []
            observer.onNext(items)
            return Disposables.create()
        }
    }
    
    func item(havingID id: ModelType.IDType) -> Observable<ModelType?> {
        return Observable.create { observer in
            let context = NSManagedObjectContext.mr_()
            let predicate = NSPredicate(format: "\(ModelType.primaryKey) = " + (id is Int ? "%d" : "%@" ), id)
            if let entity = EntityType.mr_findFirst(with: predicate, in: context) {
                observer.onNext(Self.item(from: entity))
            } else {
                observer.onNext(nil)
            }
            return Disposables.create()
        }
    }
    
    func item(havingID id: ModelType.IDType, for userId:String) -> Observable<ModelType?> {
        return Observable.create { observer in
            let context = NSManagedObjectContext.mr_()
            let predicate = NSPredicate(format: "\(ModelType.primaryKey) = " + (id is Int ? "%d" : "%@" ), id)
            if let entity = EntityType.mr_findFirst(with: predicate, in: context) {
                observer.onNext(Self.item(from: entity))
            } else {
                observer.onNext(nil)
            }
            return Disposables.create()
        }
    }
    
    func item(with predicate: NSPredicate) -> Observable<ModelType?> {
        return Observable.create { observer in
            let context = NSManagedObjectContext.mr_()
            if let entity = EntityType.mr_findFirst(with: predicate, in: context) {
                observer.onNext(Self.item(from: entity))
            } else {
                observer.onNext(nil)
            }
            return Disposables.create()
        }
    }
    
    func addAll(_ items: [ModelType]) -> Observable<Void> {
        return MagicalRecord.rx.save(block: { context in
            if let context = context {
                for item in items {
                    if let entity = EntityType.mr_createEntity(in: context) {
                        Self.map(from: item, to: entity)
                    }
                }
            }
        })
    }

    func add(_ item: ModelType) -> Observable<Void> {
        return addAll([item])
    }
        
    func updateAll(_ items: [ModelType]) -> Observable<Void> {
        return MagicalRecord.rx.save { context in
            if let context = context {
                for item in items {
                    let predicate = NSPredicate(format: "\(ModelType.primaryKey) = " + (item.modelID is Int ? "%d" : "%@" ),
                                                item.modelID)
                    if let entity = EntityType.mr_findFirst(with: predicate, in: context) {
                        Self.map(from: item, to: entity)
                    }
                    else if let entity = EntityType.mr_createEntity(in: context) {
                        Self.map(from: item, to: entity)
                    }
                }
            }
        }
    }
    
    func update(_ item: ModelType) -> Observable<Void> {
        return updateAll([item])
    }
    
    func deleteItem(havingID id: ModelType.IDType) -> Observable<Void> {
        return MagicalRecord.rx.save { context in
            if let context = context {
                let predicate = NSPredicate(format: "\(ModelType.primaryKey) = " + (id is Int ? "%d" : "%@" ), id)
                EntityType.mr_deleteAll(matching: predicate, in: context)
            }
        }
    }
    
    func deleteItem(havingIDs ids: [String], for user:String) -> Observable<Void> {
        return MagicalRecord.rx.save { context in
            if let context = context {
                let predicate = NSPredicate(format: "\(ModelType.primaryKey) IN %@", ids)
                EntityType.mr_deleteAll(matching: predicate, in: context)
            }
        }
    }
    
    func deleteAll() -> Observable<Void> {
        return MagicalRecord.rx.save(block: { context in
            if let context = context {
                EntityType.mr_truncateAll(in: context)
            }
        })
    }
    
    func itemCount(with predicate: NSPredicate? = nil) -> Observable<Int> {
        return Observable.create { observer in
            let context = NSManagedObjectContext.mr_()
            let count = EntityType.mr_countOfEntities(with: predicate, in: context)
            observer.onNext(Int(count))
            return Disposables.create()
        }
    }
}
