# 56K — PC통신 감성 캘린더

> "minical이 못 따라하는 캘린더"

하이텔/천리안 PC통신 감성을 입힌 iOS 네이티브 캘린더 앱.

## Stack

- Swift 5.9+ / SwiftUI / iOS 17.0+
- EventKit (캘린더 동기화)
- StoreKit 2 (IAP)
- WidgetKit
- AVFoundation (사운드)

## 프로젝트 셋업

```bash
# XcodeGen 설치 (없다면)
brew install xcodegen

# Xcode 프로젝트 생성
cd 56K
xcodegen generate

# Xcode에서 열기
open 56K.xcodeproj
```

### Galmuri 폰트 설치

1. [Galmuri](https://github.com/quiple/galmuri)에서 Galmuri11.ttf 다운로드
2. `56K/56K/Resources/Fonts/`에 복사
3. Xcode에서 Info.plist에 폰트 등록:
   ```xml
   <key>UIAppFonts</key>
   <array>
       <string>Galmuri11.ttf</string>
   </array>
   ```

### 사운드 파일

`56K/56K/Resources/Sounds/`에 다음 파일 추가:
- `modem.caf` — 56K 모뎀 핸드셰이크
- `beep.caf` — CRT 비프
- `key_click.caf` — 키 입력
- `error_buzz.caf` — 에러
- `success.caf` — 저장 완료

## 문서

- [DESIGN.md](DESIGN.md) — PC통신 시각/카피/사운드 사전
- [ROADMAP.md](ROADMAP.md) — 4주 마일스톤
