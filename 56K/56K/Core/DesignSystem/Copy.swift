import Foundation

enum Copy {
    enum System {
        static let saved = "정상 등록되었습니다. [ENTER]"
        static let deleted = "삭제 완료. [ENTER]"
        static let updated = "수정 완료. [ENTER]"
        static let loading = "잠시만 기다려 주세요..."
        static let error = "오류가 발생하였습니다."
        static let connecting = "KORNET 접속 중..."
        static let connected = "[연결 성공]"
        static let permDenied = "캘린더 접근 권한이 없삼. 설정에서 허용해주세요."
        static let goToSettings = "설정으로 이동"
        static let requestPerm = "권한 요청"
        static let permNeeded = "일정 동기화를 위해 캘린더 접근이 필요함다.\n님하 허용 부탁드림."
    }

    enum Action {
        static let newEvent = "[F] 새 글쓰기"
        static let edit = "[E] 수정"
        static let delete = "[D] 삭제"
        static let save = "[S] 등록"
        static let cancel = "[ESC] 취소"
        static let back = "[←] 뒤로"
    }

    enum Confirm {
        static let deleteEvent = "님하 정말 삭제하실?"
        static let yes = "ㄱㄱ"
        static let no = "ㄴㄴ"
    }

    enum Empty {
        static let noEvents = "님하 아직 일정이 없삼"
        static let noEventsHint = "[F] 새 글쓰기로 첫 일정 등록"
        static let noEventsToday = "오늘은 일정 없음. 즐기삼."
    }

    enum Notification {
        static func before(minutes: Int) -> String {
            "[공지] \(minutes)분 후 일정이 있삼"
        }
        static let start = "[알림] 지금 시작이용 ㄱㄱ"
        static let end = "[공지] 일정 종료. 수고하셨음다"
    }

    enum Boot {
        static let banner = "KAL.COM v1.0"
        static let port = "COM1: 56000 baud"
        static let dialing = "ATDT..."
        static let connect = "CONNECT 33600/V42BIS"
        static let welcome = "님하 어서오삼"
        static let skip = "탭하면 건너뛰기"
    }

    enum Field {
        static let title = "제목 >> "
        static let time = "시간 >> "
        static let date = "날짜 >> "
        static let memo = "내용 >> "
        static let location = "장소 >> "
    }

    enum Settings {
        static let title = "[ 환경 설정 ]"
        static let sound = "사운드"
        static let bootAnimation = "접속 애니메이션"
        static let about = "정보"
        static let purchase = "PC통신팩 구매"
        static let restore = "구매 복원"
        static let version = "v1.0"
    }

    enum Calendar {
        static func monthTitle(year: Int, month: Int) -> String {
            String(format: "%d / %02d", year, month)
        }
        static let today = "오늘"
        static let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        static let allDay = "종일"
    }

    enum IAP {
        static let title = "PC통신팩"
        static let description = "모든 기능 잠금 해제"
        static let purchase = "구매하기 [₩4,900]"
        static let purchased = "구매 완료 ★"
        static let restoring = "복원 중..."
        static let purchaseError = "구매 중 오류 발생!"
    }
}
