# 56K — 4주 출시 로드맵

데드라인: 작업 시작일 기준 **+28일**. 이 안에 ship 안 되면 프로젝트 중단.

각 주차 끝에 *반드시* "Definition of Done" 통과해야 다음 주로 넘어감.

-----

## Week 1: 토대 (Foundation)

### 목표

실제 Apple 캘린더 데이터를 PC통신 풍 월 뷰에 띄운다. 디자인 시스템 완성.

### 작업

#### Day 1-2: 프로젝트 셋업

- [x] Xcode 프로젝트 생성 (App, iOS 17.0+, SwiftUI)
- [x] Git 초기화, `.gitignore` (Xcode 표준)
- [x] `CLAUDE.md`, `DESIGN.md`, `ROADMAP.md` 루트 배치
- [x] 폴더 구조 생성 (CLAUDE.md 참조)
- [x] `Info.plist`: 강제 다크모드, EventKit 권한 카피, 앱 한국어 기본

#### Day 2-3: 디자인 시스템

- [x] Galmuri 폰트 다운로드 → `Resources/Fonts/` 배치 → `Info.plist`에 등록
- [x] `Core/DesignSystem/Colors.swift` — DESIGN.md 토큰 9개
- [x] `Core/DesignSystem/Fonts.swift` — pixel7/11/14
- [x] `Core/DesignSystem/ASCII.swift` — 박스 드로잉, 마커 상수
- [x] `Core/DesignSystem/Copy.swift` — 카피 사전 enum
- [x] `ASCIIBox` 컴포넌트 (제목 옵션, content 슬롯)

#### Day 4-5: EventKit

- [x] `Core/EventKit/EventStore.swift` — `EKEventStore` 싱글톤 wrapper
- [x] 권한 요청 플로우 (iOS 17의 `requestFullAccessToEvents`)
- [x] 권한 거절 시 폴백 화면 (PC통신풍, 설정 딥링크)
- [x] 월 범위로 이벤트 조회 함수
- [x] EventKit 변경 알림 구독 (`.EKEventStoreChanged`)

#### Day 5-7: 월 뷰

- [x] `Features/Calendar/MonthView.swift`
- [x] 7×6 그리드, ASCII 박스로 감쌈
- [x] 요일 헤더, 날짜 셀, 이전/다음 달 네비
- [x] 오늘 날짜 `▶DD◀` 강조 + 점멸
- [x] 일정 있는 날 점(·) 또는 막대
- [x] 월 스와이프 (좌우 제스처)
- [ ] 60fps 유지 확인

### W1 Definition of Done

- ✅ 실기기(아이폰)에서 권한 받고 실제 Apple 캘린더 이벤트가 PC통신풍 월 뷰에 표시됨
- ✅ 월 스와이프 끊김 없음
- ✅ 컬러/폰트/ASCII 토큰만으로 렌더링됨 (직접 hex/문자열 박은 곳 없음)
- ✅ 권한 거절 시 PC통신풍 안내 화면 정상

-----

## Week 2: 캘린더 핵심 UX

### 목표

이벤트 CRUD가 EventKit과 양방향으로 작동. 일 상세 뷰 완성.

### 작업

#### Day 8-9: 일 상세 뷰

- [x] `Features/Calendar/DayDetailView.swift`
- [x] 날짜 헤더, 이벤트 리스트 (게시물 헤더 스타일)
- [x] 자동 번호 부여 (`[0001]`, `[0002]`)
- [x] 카테고리 색상 (EKCalendar 색상 매핑)
- [ ] 종일 이벤트 표시 분리
- [ ] 빈 상태 카피 (Copy.Empty.noEventsToday)

#### Day 9-11: 이벤트 생성

- [x] `Features/Event/EventEditView.swift`
- [x] 제목/날짜/시간/장소/메모/캘린더 선택
- [x] EventKit 쓰기 (`EKEvent`, `save(_:span:)`)
- [ ] 저장 완료 시 시스템 메시지 ("정상 등록되었습니다. [ENTER]")
- [ ] 날짜/시간 picker는 시스템 기본 사용 (PC통신풍 wrapper로 감싸기)

#### Day 11-12: 이벤트 수정/삭제

- [x] 일 상세에서 이벤트 탭 → 수정 뷰
- [x] 삭제 확인 다이얼로그 ("님하 정말 삭제하실?" / "ㄱㄱ" / "ㄴㄴ")
- [ ] 반복 이벤트 처리: 단일 / 이후 모두 / 전체

#### Day 12-14: 종일/반복 이벤트

- [ ] 종일 이벤트 토글
- [ ] 반복 규칙 (매일/매주/매월/매년)
- [ ] 시간대 처리 (사용자 로컬 시간대)

### W2 Definition of Done

- ✅ 앱에서 이벤트 만들면 Apple 캘린더 앱에도 즉시 보임 (반대도 성립)
- ✅ 종일/반복/시간대 이벤트 정확히 처리
- ✅ 모든 사용자 노출 텍스트가 `Copy.swift`에서 옴
- ✅ minical로 만든 이벤트, 56K로 수정 → minical에서도 변경 반영됨

-----

## Week 3: PC통신 테마 (= 진짜 차별화)

### 목표

시그니처 부팅 시퀀스 + 위젯 + 카피/사운드 완성. *이게 마케팅의 전부*.

### 작업

#### Day 15-16: 부팅 시퀀스

- [x] `Features/Boot/BootSequenceView.swift`
- [x] DESIGN.md 5.1 타이밍대로 구현 (4초 풀버전)
- [x] 타이핑 효과 (글자당 30~50ms)
- [ ] 모뎀 핸드셰이크 사운드 (옵션 ON일 때만)
- [x] "님하 어서오삼" → 메인 화면 전환
- [x] 첫 실행 후 자동 OFF, 설정에서 ON 가능
- [ ] 매번 실행 시 1초 단축 버전 (옵션)

#### Day 16-17: 사운드

- [ ] freesound.org에서 모뎀 사운드 CC0 라이선스 확보 → `Resources/Sounds/`
- [x] `Core/Audio/SoundPlayer.swift` — AVAudioPlayer wrapper
- [x] 기본 OFF, 설정에서 ON
- [x] 시스템 음량 따름

#### Day 18-20: 위젯

- [x] `56KWidget` 타겟 추가
- [x] Small 위젯: 오늘 + 다음 일정 2개 (DESIGN.md 5.5)
- [ ] Medium 위젯: 주간 뷰 (선택, 시간 남으면)
- [x] Galmuri7/11로 렌더링
- [ ] EventKit 변경 시 `WidgetCenter.shared.reloadAllTimelines()`
- [ ] 잠금화면 위젯도 1개

#### Day 20-21: 알림

- [ ] 이벤트 알림 (EventKit alarm 사용, 직접 UNNotification 만들지 마)
- [x] 푸시 알림 카피 (Copy.Notification)
- [ ] 알림 사운드 옵션

### W3 Definition of Done

- ✅ 부팅 시퀀스가 영상으로 찍어 트위터에 올릴 만큼 그럴듯함 (← 마케팅 자산)
- ✅ 위젯이 EventKit 데이터를 PC통신 스타일로 표시
- ✅ 알림이 푸시될 때도 카피가 PC통신체
- ✅ 사운드 ON/OFF 정상 작동

-----

## Week 4: 출시

### 목표

IAP, App Store 심사 제출, 베타 사용자 모집.

### 작업

#### Day 22-23: IAP

- [x] `Core/IAP/Purchase.swift` — StoreKit 2 wrapper
- [ ] Product ID: `com.csparkzxc.56k.pctelpack`
- [ ] 가격: ₩4,900 (Tier 5)
- [x] 단일 non-consumable
- [ ] 구매 전: 부팅 시퀀스/위젯 워터마크 (또는 부팅만 잠금)
- [x] 구매 후 복원 기능
- [ ] 영수증 검증은 StoreKit 2 자동
- [ ] 무료 부분이 너무 빈약하면 부팅 시퀀스는 무료, 위젯 PC통신 스킨은 유료로 가르기

#### Day 23-24: 설정 화면

- [x] `Features/Settings/SettingsView.swift`
- [x] 사운드 ON/OFF
- [x] 부팅 애니메이션 ON/OFF/짧게
- [x] PC통신팩 구매 / 복원
- [ ] 정보 (버전, 라이선스, 개인정보처리방침 링크)

#### Day 25-26: App Store 준비

- [ ] 앱 아이콘 (1024x1024) — PC통신 로고 풍
- [ ] 스크린샷 6.7"/6.5"/5.5" 각각 5장 (한국어)
  - 1: 부팅 시퀀스 캡처 (이게 후크)
  - 2: 월 뷰
  - 3: 일 상세
  - 4: 위젯
  - 5: 가격/구매 화면
- [ ] 앱 설명 (한국어, PC통신 향수 강조)
- [ ] 키워드: 캘린더, 일정, 다이어리, PC통신, 하이텔, 천리안, 레트로, 미니멀
- [ ] 개인정보처리방침 URL
- [ ] 카테고리: 생산성 (Productivity)

#### Day 27-28: 베타 + 제출

- [ ] TestFlight 빌드 업로드
- [ ] 베타 5-10명 모집 (Threads/X, 35+ 타겟)
- [ ] 24시간 피드백 수집
- [ ] 크리티컬 버그만 패치
- [ ] App Store 심사 제출

### W4 Definition of Done

- ✅ 빌드가 TestFlight에 올라가 있음
- ✅ 베타 사용자 최소 5명 피드백 수령
- ✅ App Store 심사 제출 완료
- ✅ 부팅 시퀀스 영상이 SNS에 올라가 있음 (런칭 페이로드)

-----

## 데일리 체크 리스트 (Cc에게)

매일 작업 시작 시:

1. 어제 한 일이 W*의 어떤 작업인지 ROADMAP.md에 체크
1. 오늘 할 일 1~3개로 좁힘
1. CLAUDE.md의 "절대 하지 말 것" 다시 읽기
1. 새 한국어 문자열 만들지 말고 Copy.swift에서 가져옴
1. 새 색상/폰트/ASCII 직접 박지 말고 토큰에서 가져옴

## 위험 신호 (즉시 사용자에게 보고)

- ⚠️ 어떤 작업이 예상 시간의 2배 넘게 걸림
- ⚠️ EventKit이 예상과 다르게 동작 (특히 권한, 반복 이벤트)
- ⚠️ 갈무리 폰트가 ASCII 박스에서 정렬 안 됨
- ⚠️ "이 기능 하나만 더 추가하면…" 같은 충동 — *바로 멈춰서 보고*

## Scope creep 방지

만약 추가하고 싶은 게 떠오르면:

1. ROADMAP.md 맨 아래 "v2 백로그" 섹션에 적기
1. v1에는 절대 넣지 않기
1. cs에게 묻기 전에 본인이 판단해서 v2 백로그 행

-----

## v2 백로그 (W1 시작 후 떠오르는 거 여기 누적)

- (비어있음 — Cc가 추가하기)
