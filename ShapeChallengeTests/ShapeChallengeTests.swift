//
//  ShapeChallengeTests.swift
//  ShapeChallengeTests
//
//  Created by Vũ Tiến on 11/12/20.
//

import XCTest
import Moya
@testable import ShapeChallenge

class ShapeChallengeTests: XCTestCase {
    
    var provider = MoyaProvider<ColorTarget>(stubClosure: MoyaProvider.immediatelyStub)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Check parser
    func testMockColor() throws {
        let expectation = self.expectation(description: "Success")
        
        provider = MoyaProvider<ColorTarget>(stubClosure: MoyaProvider.immediatelyStub)
        provider.request(.fetchRandomColor) { (result) in
            switch result {
            case .success(let response):
                do {
                    let _ = try response.map([ColorModel].self)
                    expectation.fulfill()
                } catch {
                    print(error)
                    XCTFail(error.localizedDescription)
                }
            case .failure(_):
                XCTFail("Error parsing")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testMockPattern() throws {
        let expectation = self.expectation(description: "Success")
        
        provider = MoyaProvider<ColorTarget>(stubClosure: MoyaProvider.immediatelyStub)
        provider.request(.fetchRandomPattern) { (result) in
            switch result {
            case .success(let response):
                do {
                    let _ = try response.map([PatternModel].self)
                    expectation.fulfill()
                } catch {
                    print(error)
                    XCTFail(error.localizedDescription)
                }
            case .failure(_):
                XCTFail("Error parsing")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
