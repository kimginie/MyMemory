//
//  MemoListVC.swift
//  MyMemory
//
//  Created by 김성진 on 2021/04/26.
//

import UIKit

class MemoListVC: UITableViewController {
    // 앱 델리게이트 객체의 참조 정보를 읽어온다
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // 화면이 나타날 때마다 호출되는 메소드
    override func viewWillAppear(_ animated: Bool) {
        // 테이블 데이터를 다시 ㅇ릭어들인다. 이에 따라 행을 구성하는 로직이 다시 실행될 것이다.
        self.tableView.reloadData()
    }
    // 테이블 행의 개수를 결정하는 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.appDelegate.memolist.count
        return count
    }
    // 테이블 행을 구성하는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    // 1. memolist 배열 데이터에서 주어진 행에 맞는 데이터를 꺼낸다
        let row = self.appDelegate.memolist[indexPath.row]
        
    // 2. 이미지 속성이 비어 있을 경우 "memoCell", 아니면 "memoCellWithImage"
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        
    // 3. 재사용 큐로부터 프로토타입 셀의 인스턴스를 전달받는다
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
    
    // 4. memoCell의 내용을 구성한다
        cell.subject?.text = row.title
        cell.contents?.text = row.contents
        cell.img?.image = row.image
        
    // 5. Date 타입의 날짜를 yyyy-MM-dd HH:mm:ss 포맷에 맞게 변경한다
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate?.text = formatter.string(from: row.regdate!)
        
    // 6. cell 객체를 리턴한다
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // memolist 배열에서 선택된 행에 맞는 데이터를 꺼낸다.
        let row = self.appDelegate.memolist[indexPath.row]
        
        // 상세 화면의 인스턴스를 생성한다.
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadVC else {
            return
        }
        
        // 값을 전달한 다음, 상세 화면으로 이동한다
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SWRevealViewController 라이브러리의 revealViewController 객체를 읽어온다
        if let revealVC = self.revealViewController() {
            
            // 바 버튼 아이템 객체를 정의
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu.png")
            btn.target = revealVC // 버튼 클릭 시 호출할 메소드가 정의된 객체를 지정
            btn.action = #selector(revealVC.revealToggle(_:)) // 버튼 클릭 시 revealToggle(_:) 호출
            // 정의된 바 버튼을 내비게이션 바의 왼쪽 아이템으로 등록
            self.navigationItem.leftBarButtonItem = btn
            
            // 제스처 객체를 뷰에 추가
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }

    }
}
