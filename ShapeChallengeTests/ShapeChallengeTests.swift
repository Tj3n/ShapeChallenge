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
    
    func testMockFailure() throws {
        let serverErrorEndpointClosure = { (target: ColorTarget) -> Endpoint in
          return Endpoint(url: URL(target: target).absoluteString,
                          sampleResponseClosure: { .networkResponse(500 , Data()) },
                          method: target.method,
                          task: target.task,
                          httpHeaderFields: target.headers)
        }
        provider = MoyaProvider<ColorTarget>(endpointClosure: serverErrorEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let client = ColorClient(provider: provider)
        client.getRandomColor(failedUsingColor: .red) { (color) in
            XCTAssertEqual(color, UIColor.red)
        }
    }
    
//MARK: - Test ViewModel
    func testViewModel() {
        provider = MoyaProvider<ColorTarget>(stubClosure: MoyaProvider.immediatelyStub)
        let client = ColorClient(provider: provider)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        
        let viewModel = ShapeViewModel(colorClient: client, type: .square)
        let shape = viewModel.createShape(in: view, at: view.center)
        XCTAssertEqual(shape.center, view.center)
        XCTAssertLessThanOrEqual(shape.width, view.width*0.45)
        XCTAssertGreaterThanOrEqual(shape.width, view.width*0.1)
        
        viewModel.getBackgroundColor { (color) in
            XCTAssertEqual(color, UIColor.hex("63945F"))
        }
        
        viewModel.handleMotionBegan(.motionShake) { (shape) in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                // Shape got removed correctly
                XCTAssertEqual(viewModel.shapes.count, 0)
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
