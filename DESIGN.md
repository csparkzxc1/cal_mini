# 56K — Design System

PC통신 미학을 캘린더로 옮기는 디테일 사전. Cc가 코드 짤 때 참조.

-----

## 1. 색상 토큰

### Core/DesignSystem/Colors.swift 에 정의

|토큰|Hex|용도|
|---|---|---|
|`kalBlack`|`#000000`|배경 (메인)|
|`kalDarkBlue`|`#000080`|보조 배경 (헤더, 카드 베이스)|
|`kalCyan`|`#00CCCC`|본문 텍스트, 기본 정보|
|`kalCyanBright`|`#00FFFF`|강조 텍스트, 오늘 날짜|
|`kalMagenta`|`#FF00FF`|액션 (버튼, 링크)|
|`kalYellow`|`#FFFF33`|알림, 중요|
|`kalRed`|`#FF3333`|위험, 삭제, 휴일|
|`kalGreen`|`#00FF00`|성공, 완료|
|`kalDim`|`#006666`|비활성, 다른 달 날짜|

**원칙:** 9개 토큰으로 끝. 추가 금지. 회색조 필요하면 `kalDim` 또는 `kalCyan.opacity()` 사용.

-----

## 2. 폰트

### 갈무리 (Galmuri)

- 라이선스: OFL (Open Font License), 상업 사용 가능
- 출처: https://github.com/quiple/galmuri
- 사용 폰트:
  - **Galmuri11** (11pt 픽셀, 일반 텍스트)
  - **Galmuri14** (14pt 픽셀, 헤더)
  - **Galmuri7** (7pt 픽셀, 위젯 작은 글자)

### 적용 규칙

|위치|폰트|
|---|---|
|부팅 시퀀스 전체|Galmuri11/14|
|월 뷰 헤더 ("2026 / 05")|Galmuri14|
|요일 이름 (일월화수목금토)|Galmuri11|
|날짜 숫자|Galmuri11|
|ASCII 박스 보더|Galmuri11|
|**이벤트 제목 (본문)**|**시스템 폰트 (가독성 우선)**|
|**이벤트 시간/메모**|**시스템 폰트**|
|위젯|Galmuri7/11|

### Core/DesignSystem/Fonts.swift

```swift
extension Font {
    static let pixel11 = Font.custom("Galmuri11", size: 11)
    static let pixel14 = Font.custom("Galmuri14", size: 14)
    static let pixel7  = Font.custom("Galmuri7", size: 7)
}
```

-----

## 3. ASCII 컴포넌트 라이브러리

### Core/DesignSystem/ASCII.swift

```swift
enum ASCII {
    static let boxTL = "╔"
    static let boxTR = "╗"
    static let boxBL = "╚"
    static let boxBR = "╝"
    static let boxH  = "═"
    static let boxV  = "║"
    static let boxML = "╠"
    static let boxMR = "╣"
    static let boxMT = "╦"
    static let boxMB = "╩"
    static let boxX  = "╬"
    
    static let lineTL = "┌"
    static let lineTR = "┐"
    static let lineBL = "└"
    static let lineBR = "┘"
    static let lineH  = "─"
    static let lineV  = "│"
    
    static let arrowL = "◀"
    static let arrowR = "▶"
    static let bullet = "●"
    static let star   = "★"
    static let diamond = "◆"
    
    static func hLine(_ width: Int) -> String {
        String(repeating: boxH, count: width)
    }
}
```

### 박스 컴포넌트 예시

```swift
struct ASCIIBox<Content: View>: View {
    let title: String?
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            // ╔══════ TITLE ══════╗
            // ║   content         ║
            // ╚═══════════════════╝
        }
    }
}
```

-----

## 4. 카피 사전

### Core/DesignSystem/Copy.swift

원칙:

- 시스템 메시지: 격식 ("정상 등록되었습니다")
- 사용자 액션: 통신체 ("새 글쓰기", "님하")
- ㅎㅎ/ㅋㅋ 남발 금지. 향수가 향수로 남도록.

```swift
enum Copy {
    // === 시스템 메시지 ===
    enum System {
        static let saved = "정상 등록되었습니다. [ENTER]"
        static let deleted = "삭제 완료. [ENTER]"
        static let updated = "수정 완료. [ENTER]"
        static let loading = "잠시만 기다려 주세요..."
        static let error = "오류가 발생하였습니다."
        static let connecting = "KORNET 접속 중..."
        static let connected = "[연결 성공]"
        static let permDenied = "캘린더 접근 권한이 없삼. 설정에서 허용해주세요."
    }
    
    // === 액션 ===
    enum Action {
        static let newEvent = "[F] 새 글쓰기"
        static let edit = "[E] 수정"
        static let delete = "[D] 삭제"
        static let save = "[S] 등록"
        static let cancel = "[ESC] 취소"
        static let back = "[←] 뒤로"
    }
    
    // === 확인 다이얼로그 ===
    enum Confirm {
        static let deleteEvent = "님하 정말 삭제하실?"
        static let yes = "ㄱㄱ"
        static let no = "ㄴㄴ"
    }
    
    // === 빈 상태 ===
    enum Empty {
        static let noEvents = "님하 아직 일정이 없삼"
        static let noEventsHint = "[F] 새 글쓰기로 첫 일정 등록"
        static let noEventsToday = "오늘은 일정 없음. 즐기삼."
    }
    
    // === 알림 푸시 ===
    enum Notification {
        static func before(minutes: Int) -> String {
            "[공지] \(minutes)분 후 일정이 있삼"
        }
        static let start = "[알림] 지금 시작이용 ㄱㄱ"
        static let end = "[공지] 일정 종료. 수고하셨음다"
    }
    
    // === 부팅 ===
    enum Boot {
        static let banner = "KAL.COM v1.0"
        static let port = "COM1: 56000 baud"
        static let dialing = "ATDT..."
        static let connect = "CONNECT 33600/V42BIS"
        static let welcome = "님하 어서오삼"
    }
    
    // === 입력 라벨 ===
    enum Field {
        static let title = "제목 >> "
        static let time = "시간 >> "
        static let date = "날짜 >> "
        static let memo = "내용 >> "
        static let location = "장소 >> "
    }
    
    // === 설정 ===
    enum Settings {
        static let title = "[ 환경 설정 ]"
        static let sound = "사운드"
        static let bootAnimation = "접속 애니메이션"
        static let about = "정보"
        static let purchase = "PC통신팩 구매"
        static let restore = "구매 복원"
    }
}
```

-----

## 5. 뷰별 레이아웃 사양

### 5.1 부팅 시퀀스 (첫 실행 또는 사용자 ON)

타이밍:
- 0.0s: 화면 검정
- 0.3s: "KAL.COM v1.0" 페이드인
- 0.8s: "COM1: 56000 baud" 페이드인
- 1.2s: "ATDT…" 텍스트, 모뎀 다이얼링 사운드 시작
- 2.0s: "CONNECT 33600/V42BIS" 표시
- 2.4s: "KORNET 접속 중…" 텍스트
- 3.0s: "[연결 성공]" 마젠타로 표시
- 3.4s: ASCII 박스 안에 로고 등장
- 4.0s: "님하 어서오삼" + 메인 화면 전환

총 4초. 두 번째 실행부터는 스킵 또는 1초 단축.

### 5.2 월 뷰

```
╔══════════════════════════════╗
║   2026 / 05   ◀     ▶     ⚙ ║
╠══════════════════════════════╣
║  일  월  화  수  목  금  토  ║
║                              ║
║   .   .   .   .   1   2   3  ║
║   4   5   6   7   8   9  10  ║
║  11  12  13  14  15  16  17  ║
║  18  19  20  21  22  23 ▶24◀ ║
║  25  26  27  28  29  30  31  ║
╚══════════════════════════════╝
```

### 5.3 일 상세 뷰

```
╔══ 2026-05-24 (일) ════════════╗
║ [0001] [업무] 14:00            ║
║         주간회의               ║
║ [0002] [개인] 18:00            ║
║         저녁약속               ║
║ [F] 새 글쓰기                  ║
╚════════════════════════════════╝
```

### 5.4 이벤트 생성/수정 뷰

```
╔══ 새 글쓰기 ══════════════════╗
║ 제목 >> [_______________]      ║
║ 날짜 >> 2026-05-24             ║
║ 시간 >> 14:00 ~ 15:00          ║
║ 장소 >> [_______________]      ║
║ 내용 >> [_______________]      ║
║         [S] 등록  [ESC] 취소   ║
╚════════════════════════════════╝
```

### 5.5 위젯 (Small)

```
┌─ 2026/05 ─────┐
│ 24 (일)       │
│ ─────────     │
│ 14:00 회의    │
│ 18:00 약속    │
└───────────────┘
```

-----

## 6. 사운드 설계

|파일명|용도|길이|
|---|---|---|
|`modem_handshake.m4a`|부팅 시퀀스|~3s|
|`beep_short.m4a`|일반 시스템 비프|0.2s|
|`beep_error.m4a`|오류|0.4s|
|`key_press.m4a`|키보드 타이핑 (옵션)|0.05s|

기본값: **사운드 OFF**. 첫 실행 부팅 시퀀스에서만 자동 ON. 시스템 음량 따름.

-----

## 7. 점멸/애니메이션

- 오늘 날짜 ▶24◀ 화살표만 점멸 (0.6s 주기)
- 부팅 커서 █ 점멸
- 부팅 텍스트: 타이핑 효과 (글자당 30~50ms)
- 화면 전환: 페이드. 슬라이드 금지.

-----

## 8. 다크모드 / 라이트모드

라이트모드 지원 안 함. 강제 다크. `UIUserInterfaceStyle: Dark`

-----

## 9. 한국어 처리

- 갈무리: 한글 완전 지원
- 이모지: 시스템 폰트 폴백
- 사용자 이벤트 내용: 시스템 폰트 (가독성)

-----

## 10. v2 이후 (지금은 무시)

외계인 테마, 생존 테마, Watch, Live Activity, Mac Catalyst, 추가 폰트. v1 = PC통신 단일 테마. 변주 금지.
