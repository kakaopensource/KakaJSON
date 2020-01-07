import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(JTM_01_Basic.allTests),
        testCase(JTM_02_DataType.allTests),
        testCase(JTM_03_NestedModel.allTests),
        testCase(JTM_04_ModelArray.allTests),
        testCase(JTM_05_KeyMapping.allTests),
        testCase(JTM_06_CustomValue.allTests),
        testCase(JTM_07_DynamicModel.allTests),
        testCase(MTJ_01_Basic.allTests),
        testCase(MTJ_02_NestedModel.allTests),
        testCase(MTJ_03_ModelArray.allTests),
        testCase(MTJ_04_KeyMapping.allTests),
        testCase(MTJ_05_CustomValue.allTests),
        testCase(TestCoding.allTests),
        testCase(TestGlobal.allTests),
        testCase(TestBugs.allTests)
    ]
}
#endif
