//
//  MagicalRecordUtil.swift
//  DataPlatform
//
//  Created by siva lingam on 16/5/21.
//

import Foundation
import MagicalRecord

public class MagicalRecordUtil {
    
    public static func setupCoreData() {
        
        MagicalRecord.enableShorthandMethods()
        guard let frameworkBundle = Bundle.init(identifier: "cartrack.DataPlatform") else { return }
        MagicalRecord.setShouldAutoCreateManagedObjectModel(false)
        NSManagedObjectModel.mr_setDefaultManagedObjectModel(NSManagedObjectModel.mergedModel(from: [frameworkBundle,Bundle.main]))
        MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: "Model")
        MagicalRecord.setLoggingLevel(MagicalRecordLoggingLevel.error)
    }

    public static func cleanUp() {
        MagicalRecord.cleanUp()
    }
}
