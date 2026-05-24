# 56K — PC통신 감성 캘린더

> 작명 임시. 확정 전이면 사용자에게 물어봐서 일괄 변경할 것.

## 프로젝트 정의

iOS 네이티브 캘린더 앱. 시각/카피/사운드를 PC통신(하이텔/천리안) 감성으로 통일한 단일 테마 제품. 색깔 테마 시스템 아님 — PC통신 하드코딩.

**한 줄 포지셔닝:** "minical이 못 따라하는 캘린더"

## Stack

- **언어/UI:** Swift 5.9+, SwiftUI
- **타겟:** iOS 17.0+
- **캘린더 동기화:** EventKit (Apple/Google/Outlook 자동 처리, 직접 구현 금지)
- **저장:** EventKit이 메인. 앱 자체 데이터는 UserDefaults + SwiftData (테마 설정, 사운드 ON/OFF 등 가벼운 것만)
- **결제:** StoreKit 2, single non-consumable IAP (₩4,900)
- **위젯:** WidgetKit
- **사운드:** AVFoundation
- **테스트:** XCTest (핵심 도메인만, UI 테스트 X)

## 폴더 구조

```
56K/
├── 56K/
│   ├── App/                # @main, AppDelegate, RootView
│   ├── Features/
│   │   ├── Calendar/       # 월 뷰, 일 뷰
│   │   ├── Event/          # 이벤트 생성/수정/상세
│   │   ├── Boot/           # 부팅 시퀀스
│   │   └── Settings/       # 사운드 ON/OFF, 부팅 스킵
│   ├── Core/
│   │   ├── EventKit/       # EKEventStore wrapper
│   │   ├── DesignSystem/   # Colors, Fonts, ASCII, Copy
│   │   ├── Audio/          # 모뎀 사운드, 비프
│   │   └── IAP/            # StoreKit 2 wrapper
│   ├── Resources/
│   │   ├── Fonts/          # Galmuri 폰트 파일
│   │   ├── Sounds/         # .caf 또는 .m4a
│   │   └── Assets.xcassets
│   └── Info.plist
├── 56KWidget/              # WidgetKit extension
└── 56KTests/
```

## 디자인 원칙 (Cc가 따라야 할 것)

### 절대 직접 박지 마라

- ❌ `.foregroundColor(Color(hex: "00CCCC"))`
- ✅ `.foregroundColor(.kalCyan)` — Core/DesignSystem/Colors.swift에 정의된 토큰만 사용

### 카피 사전 우선

- 임의 한국어 작성 금지
- 모든 사용자 노출 문자열은 `Core/DesignSystem/Copy.swift`의 enum/상수에서 가져옴
- 없으면 추가하고 DESIGN.md의 카피 사전도 업데이트

### ASCII 컴포넌트는 라이브러리에서

- 박스 드로잉(╔═╗║╚╝), 구분선(━━━), 화살표(◀▶) 등은 `Core/DesignSystem/ASCII.swift`의 상수 사용
- 직접 문자열 박지 마라

### 가독성 > 시각 통일성

- 본문은 시스템 폰트 (가독성 우선)
- 픽셀 폰트(갈무리)는 헤더, 부팅, ASCII 박스, 위젯에만
- 매일 쓰는 앱임. 눈 아프면 안 됨.

## 절대 하지 말 것 (v1 범위)

- ❌ 색상 테마 시스템 만들기 (PC통신만 하드코딩, 단 토큰은 일관 유지 — 아래 참조)
- ❌ 다른 PC통신 외 테마 (외계인/생존은 v2)
- ❌ Apple Watch 컴플리케이션 (v2)
- ❌ Live Activity / Dynamic Island (v2)
- ❌ 자체 동기화 구현 (EventKit이 다 해줌)
- ❌ 회원 시스템, 로그인 (PC통신 *흉내*만, 실제 계정 없음)
- ❌ 백엔드 (서버 0, 로컬 + EventKit + StoreKit만)

## 향후 테마 확장 대비 (중요)

v1은 PC통신 단일 테마 하드코딩. **단, v2에 외계인/생존 등 테마 추가 가능성은 열어둔다.** 각 테마팩은 별도 IAP로 판매 예정.

핵심: **토큰 *사용*은 v1부터 일관되게, 토큰 *추상화*는 v2에서.**

### v1에서 반드시 지킬 것

- ✅ 모든 색상은 `Color.kalCyan` 같은 토큰으로만 접근. hex 직접 박지 마라
- ✅ 모든 폰트는 `Font.pixel11` 토큰으로만 접근
- ✅ 모든 사용자 노출 카피는 `Copy.swift` enum에서만
- ✅ 모든 ASCII 문자(╔═╗ 등)는 `ASCII.swift` 상수에서만
- ✅ 모든 사운드는 `SoundPlayer` 통해서만 재생

### v1에서 만들지 말 것

- ❌ `Theme` 프로토콜
- ❌ `Theme.current.primaryColor` 같은 추상화 레이어
- ❌ `ThemeManager`, `ThemeProvider` 매니저 클래스
- ❌ 테마 선택 UI / 설정 화면 토글

토큰 추상화 엔진을 v1에 만들면 4주가 6주로 늘어남. **v2에서 1주일이면 리팩토링 가능**하므로 미리 만들지 않는다.

### v2 리팩토링 청사진 (참고용, 지금 구현 X)

v1 뷰가 토큰만 쓰고 있으면 v2 변경은 토큰 정의부만 바꿔도 됨:

```swift
// v2에서 이렇게 변할 것 (지금은 만들지 마라)
protocol Theme {
    var cyan: Color { get }
    var pixel11: Font { get }
    var bootBanner: String { get }
    // ...
}

struct PCTelTheme: Theme { ... }   // v1 콘텐츠
struct AlienTheme: Theme { ... }   // v2 추가
struct SurvivalTheme: Theme { ... } // v2 추가

// 뷰는 거의 변경 없음 — Color.kalCyan → theme.cyan 정도의 리네임만
```

**즉, v1에서 토큰만 잘 발라두면 v2는 콘텐츠 작업 + 가벼운 리팩토링.**

## 성능 기준 (minical 약점 공격)

- 월 뷰 첫 렌더링 200ms 이내
- 월 스와이프 60fps 유지
- 콜드 부트 1.5초 이내 (부팅 시퀀스는 별도, 첫 실행에만)
- 위젯 갱신 EventKit 트리거 즉시 반영

## EventKit 권한 카피 (Info.plist)

```xml
<key>NSCalendarsFullAccessUsageDescription</key>
<string>일정 동기화를 위해 캘린더 접근이 필요함다. 님하 허용 부탁드림.</string>
```

권한 거절시 폴백: PC통신풍 안내 화면 → 설정 앱 딥링크

## 코드 스타일

- SwiftUI 우선, UIKit은 EventKit ↔ SwiftUI 브릿지에만
- 비동기는 async/await, Combine 금지
- 상태 관리: @Observable (iOS 17+ 활용), TCA 같은 무거운 거 도입 X
- 한 파일 300줄 이내 권장
- ViewModel 이름은 `~ViewModel`이 아니라 `~State` 또는 `~Store` (Observable 매크로 친화)

## 참고 문서

- `DESIGN.md` — PC통신 시각/카피/사운드 디테일 사전
- `ROADMAP.md` — 4주 작업 마일스톤

## 출시 데드라인

**4주 후.** 이 안에 ship 안 되면 프로젝트 중단. 기능 추가 금지. PC통신 테마 하드코딩으로 코어 캘린더 + 부팅 + 위젯 1개 + IAP까지만.
