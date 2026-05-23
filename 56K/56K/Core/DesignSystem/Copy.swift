import Foundation

enum Copy {
    enum Boot {
        static let title = "56K 캘린더 v1.0"
        static let connecting = "접속 중..."
        static let memoryCheck = "메모리 검사 중... OK"
        static let dataLoading = "캘린더 데이터 로딩... OK"
        static let modemConnect = "모뎀 연결 중... 56000 bps"
        static let connected = "접속 완료!"
        static let welcome = "즐거운 하루 되세요, 님하~"
        static let skip = "아무 키나 누르면 건너뛰기"
    }

    enum Calendar {
        static func monthTitle(year: Int, month: Int) -> String {
            "\(year)년 \(month)월 게시판"
        }
        static let today = "오늘"
        static let noEvents = "등록된 일정이 없습니다"
        static let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        static let allDay = "종일"
    }

    enum Event {
        static let newEvent = "새 글 쓰기"
        static let editEvent = "글 수정"
        static let deleteEvent = "글 삭제"
        static let deleteConfirm = "정말 삭제하시겠습니까?"
        static let save = "저장 [F10]"
        static let cancel = "취소 [ESC]"
        static let title = "제목"
        static let titlePlaceholder = "일정 제목을 입력하세요"
        static let location = "장소"
        static let locationPlaceholder = "장소를 입력하세요"
        static let startDate = "시작"
        static let endDate = "종료"
        static let allDay = "종일"
        static let notes = "메모"
        static let notesPlaceholder = "메모를 입력하세요"
        static let saved = "저장 완료!"
        static let deleted = "삭제 완료!"
    }

    enum Settings {
        static let title = "환경 설정"
        static let soundOn = "사운드 ON"
        static let soundOff = "사운드 OFF"
        static let sound = "효과음"
        static let bootSkip = "부팅 건너뛰기"
        static let bootAnimation = "부팅 애니메이션"
        static let about = "정보"
        static let version = "v1.0"
        static let premium = "프리미엄 서비스"
    }

    enum Permission {
        static let calendarNeeded = "일정 동기화를 위해 캘린더 접근이 필요함다.\n님하 허용 부탁드림."
        static let denied = "캘린더 접근 권한이 없습니다.\n설정에서 허용해 주세요, 님하."
        static let goToSettings = "설정으로 이동"
        static let request = "권한 요청"
    }

    enum IAP {
        static let title = "프리미엄 서비스"
        static let description = "모든 기능 잠금 해제"
        static let purchase = "구매하기 [₩4,900]"
        static let purchased = "구매 완료 ★"
        static let restore = "구매 복원"
        static let restoring = "복원 중..."
        static let purchaseError = "구매 중 에러 발생!"
    }

    enum Common {
        static let loading = "로딩중..."
        static let error = "에러 발생! 다시 시도해 주세요"
        static let confirm = "확인"
        static let back = "이전"
        static let close = "닫기"
        static let welcome = "접속을 환영합니다"
    }
}
