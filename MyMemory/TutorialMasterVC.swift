//
//  TutorialMasterVC.swift
//  MyMemory
//
//  Created by 김성진 on 2021/10/26.
//

import UIKit
class TutorialMasterVC: UIViewController, UIPageViewControllerDataSource {
    
    var pageVC: UIPageViewController!
    
    // 콘텐츠 뷰 컨트롤러에 들어갈 타이틀과 이미지
    var contentTitles = ["STEP 1", "STEP 2", "STEP 3", "STEP 4"]
    var contenImages = ["Page0", "Page1", "Page2", "Page3"]
    
    override func viewDidLoad() {
        
        // 1. 페이지 뷰 컨트롤러 객체 생성하기
        self.pageVC = self.instanceTutorialVC(name: "PageVC") as? UIPageViewController
        self.pageVC.dataSource = self
        
        // 2. 페이지 뷰 컨트롤러의 기본 페이지 지정
        let startContentVC = self.getContentVC(atIndex: 0)! // 최초 노출될 콘테츠 뷰 컨트롤러
        self.pageVC.setViewControllers([startContentVC], direction: .forward, animated: true)
        
        // 3. 페이지 뷰 컨트롤러의 출력 영역 지정
        self.pageVC.view.frame.origin = CGPoint(x: 0, y: 0)
    }
    
    
    
    func getContentVC(atIndex idx: Int) -> UIViewController? {
        // 인덱스가 데이터배열 크기 범위를 벗어나면 nil 반환
        guard self.contentTitles.count >= idx && self.contentTitles.count > 0 else {
            return nil
        }
        
        // "ContentsVC"라는 StoryBoard ID를 가진 뷰 컨트롤러의 인스턴스를 생성하고 캐스팅
        guard let cvc = self.instanceTutorialVC(name: "ContentsVC") as? TutorialContensVC else {
            return nil
        }
        
        // 콘텐츠 뷰 컨트롤러의 내용을 구성
        cvc.titleText = self.contentTitles[idx]
        cvc.imageFile = self.contenImages[idx]
        cvc.pageIndex = idx
        return cvc
    }
    
    // 현재의 콘텐츠 뷰 컨트롤러보다 뒤쪽에 올 콘텐츠 뷰 컨트롤러 객체
    // 즉, 현재의 상태에서 앞쪽으로 스와이프했을 때 보여줄 콘텔츠 뷰 컨트롤러 객체
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 현재의 페이지 인덱스
        guard var index = (viewController as! TutorialContensVC).pageIndex else {
            return nil
        }
        
        // 현재의 인덱스가 맨 앞이라면 nil을 반환하고 종료
        guard index > 0 else {
            return nil
        }
        
        index -= 1 // 현재의 인덱스에서 하나 뺌(즉, 이전 페이지 인덱스)
        return self.getContentVC(atIndex: index)
    }
    
    // 현재의 콘텐츠 뷰 컨트롤러보다 뒤쪽에 올 콘텐츠 뷰 컨트롤러 객체
    // 즉, 현재의 상태에서 뒤쪽으로 스와이프했을 때 보여줄 콘텐츠 뷰 컨트롤러 객체
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // 현재의 페이지 인덱스
        guard var index = (viewController as! TutorialContensVC).pageIndex else {
            return nil
        }
        
        index += 1 // 현재의 인덱스에 하나를 더함(즉, 다음 페이지 인덱스)
        
        // 인덱스는 항상 배열 데이터의 크기보다 작아야한다.
        guard index < self.contentTitles.count else {
            return nil
        }
        
        return self.getContentVC(atIndex: index)
    }
}
