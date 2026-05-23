# 56K Design Dictionary

PC통신 (Korean BBS) visual, copy, and sound reference for the 56K calendar app.

---

## Color Palette

CRT monitor aesthetic. No pure whites, no modern gradients.

| Token | Hex | Usage |
|---|---|---|
| `background` | `#0D1117` | Deep navy/black. Main screen background, CRT off-tone. |
| `primaryText` | `#00CCCC` | Cyan. Default body text, labels, most UI copy. |
| `secondaryText` | `#33CC33` | Green. Terminal-style secondary info, timestamps, metadata. |
| `highlight` | `#CCCC00` | Yellow. Selected day, active item, focused state. |
| `warning` | `#CC00CC` | Magenta. Alerts, destructive action labels, important badges. |
| `systemText` | `#CCCCCC` | Dim CRT white. System messages, disabled text, subtle labels. |
| `cursor` | `#00FFFF` | Bright cyan. Cursor blink, active indicator, today marker. |
| `border` | `#008888` | Dim cyan. ASCII box borders, dividers, separators. |
| `error` | `#CC3333` | Red. Validation errors, connection failure text. |

### Usage Notes

- Background should feel like a CRT that is on but showing a dark screen, not a modern dark mode.
- Text colors should look slightly phosphor-burned, not LED-crisp.
- Never use pure black (`#000000`) for backgrounds or pure white (`#FFFFFF`) for text.

---

## Typography

### Font Families

| Context | Font | Fallback |
|---|---|---|
| Headers, boot sequence, ASCII boxes, widget | **Galmuri11** (갈무리) | `Menlo`, monospace system font |
| Body text, event details, daily schedule | SF Pro (system font) | default system |

Galmuri is a Korean pixel font that recreates the bitmap feel of 90s PC통신 terminals. Use it for anything that should feel "system-level" or decorative. Use the system font for anything the user needs to read at length.

### Size Tokens

| Token | Points | Usage |
|---|---|---|
| `caption` | 11 | Timestamps, metadata, status bar |
| `body` | 14 | Event titles, list items, general copy |
| `header` | 17 | Section headers, day view title |
| `title` | 22 | Month/year display, screen titles |
| `boot` | 13 | Boot sequence monospaced lines |

### Rules

- Boot sequence and ASCII art always use Galmuri at `boot` size, monospaced.
- Calendar day numbers use Galmuri at `body` size.
- Event descriptions and multi-line text use system font at `body` size.
- Widget uses Galmuri exclusively.

---

## ASCII Art Components

### Box Drawing

Double-line boxes for primary panels and modals:

```
╔══════════════════════════╗
║  56K CALENDAR v1.0       ║
╠══════════════════════════╣
║                          ║
╚══════════════════════════╝
```

Single-line boxes for secondary panels, list containers, day cells:

```
┌──────────────────────────┐
│  2026년 05월 게시판       │
├──────────────────────────┤
│                          │
└──────────────────────────┘
```

### Characters Reference

| Type | Characters |
|---|---|
| Double box | `╔ ═ ╗ ║ ╚ ╝ ╠ ╣ ╬` |
| Single box | `┌ ─ ┐ │ └ ┘ ├ ┤` |
| Heavy divider | `━━━━━━━━━━━━━━━━` |
| Double divider | `════════════════` |
| Light divider | `────────────────` |
| Nav arrows | `◀ ▶ ▲ ▼` |
| Decorative | `★ ● ◆ ■` |
| Progress bar | `[■■■■□□□□□□]` |
| Status online | `●` |
| Status offline | `○` |

### Calendar Day Cell

```
┌────┐
│ 23 │
│ ●● │  <- event dots
└────┘
```

Selected state uses `highlight` color for the border or background:

```
╔════╗
║ 23 ║
║ ●● ║
╚════╝
```

### Navigation Bar

```
╔══════════════════════════════╗
║  ◀  2026년 05월 게시판  ▶   ║
╚══════════════════════════════╝
```

### Modal Overlay

```
╔══════════════════════════╗
║      새 글 쓰기          ║
╠══════════════════════════╣
║                          ║
║  제목: _                 ║
║  시간: _                 ║
║                          ║
║  [저장 F10]  [취소 ESC]  ║
╚══════════════════════════╝
```

### Empty State

```
┌──────────────────────────┐
│                          │
│  등록된 일정이 없습니다   │
│                          │
└──────────────────────────┘
```

---

## Copy Dictionary

All user-facing text uses 90s Korean BBS (PC통신) tone. Casual, slightly playful, uses period-appropriate slang like "님하".

### Core UI

| Key | Korean | Context |
|---|---|---|
| `greeting` | 접속을 환영합니다 | General welcome |
| `monthTitle` | XXXX년 XX월 게시판 | Month view header (replace XXXX/XX with year/month) |
| `noEvents` | 등록된 일정이 없습니다 | Empty day/month state |
| `addEvent` | 새 글 쓰기 | Create event button |
| `editEvent` | 글 수정 | Edit event action |
| `deleteEvent` | 글 삭제 | Delete event action |
| `save` | 저장 [F10] | Save/confirm button |
| `cancel` | 취소 [ESC] | Cancel/dismiss button |
| `settings` | 환경 설정 | Settings screen title |
| `today` | 오늘 | Today button |
| `back` | 이전 | Back navigation |

### Boot Sequence

| Key | Korean |
|---|---|
| `bootGreeting` | 56K 캘린더 v1.0 접속 중... |
| `bootComplete` | 접속 완료! 즐거운 하루 되세요, 님하~ |

### System Messages

| Key | Korean |
|---|---|
| `loading` | 로딩중... |
| `error` | 에러 발생! 다시 시도해 주세요 |
| `permissionDenied` | 권한이 필요합니다, 님하 |

### IAP (In-App Purchase)

| Key | Korean |
|---|---|
| `iapTitle` | 프리미엄 서비스 |
| `iapDescription` | 모든 기능 잠금 해제 |
| `purchaseButton` | 구매하기 [₩4,900] |
| `purchased` | 구매 완료 ★ |
| `restore` | 구매 복원 |

### Settings

| Key | Korean |
|---|---|
| `soundOn` | 사운드 ON |
| `soundOff` | 사운드 OFF |
| `bootSkip` | 부팅 건너뛰기 |

### Calendar / Weekdays

| Key | Korean |
|---|---|
| `weekdays` | 일 / 월 / 화 / 수 / 목 / 금 / 토 |

### Permissions

| Key | Korean |
|---|---|
| `calendarPermissionAsk` | 일정 동기화를 위해 캘린더 접근이 필요함다. 님하 허용 부탁드림. |
| `permissionDeniedFallback` | 캘린더 접근 권한이 없습니다.\n설정에서 허용해 주세요, 님하. |
| `goToSettings` | 설정으로 이동 |

---

## Sound Design

All sounds should feel lo-fi and period-appropriate. Think 8-bit, PCM, early WAV files.

| Sound | Trigger | Duration | Description |
|---|---|---|---|
| Modem handshake | Boot sequence | ~3s | Classic 56K modem connection sound (baud negotiation screech). Plays during boot animation. |
| Beep | Navigation, button press | ~100ms | Short CRT terminal beep. Single frequency, square wave feel. |
| Key click | Typing in event creation | ~50ms | Mechanical keyboard click. Subtle, not aggressive. |
| Error buzzer | Validation error | ~300ms | Low-pitched buzz. Two short pulses. |
| Success chime | Event saved | ~200ms | Rising two-tone chime. Feels like "task complete". |

### Implementation Notes

- All sounds respect the `soundOn`/`soundOff` user preference.
- Use short audio files (CAF or WAV), not system sounds.
- Modem sound should be a compressed version of a real 56K handshake recording, trimmed to ~3 seconds.
- Haptic feedback can accompany beep and click on devices that support it.

---

## Boot Sequence

Plays on first launch only (or until user enables "부팅 건너뛰기"). Skippable by tap.

### Flow

1. **Black screen** -- 0.5s. Screen is `background` color. A single cursor block (`█`) blinks in the top-left corner using `cursor` color.

2. **ASCII title** -- appears character by character (typewriter effect, ~30ms per char):
   ```
   ╔═══════════════════════════╗
   ║   56K CALENDAR v1.0       ║
   ╚═══════════════════════════╝
   ```

3. **Modem sound** -- starts playing as the title finishes rendering.

4. **System check lines** -- appear one by one, each with a ~400ms delay:
   ```
   메모리 검사 중... OK
   캘린더 데이터 로딩... OK
   모뎀 연결 중... 56000 bps
   ```
   Each line prints left-to-right. "OK" and "56000 bps" appear after a brief pause (~200ms) in `secondaryText` (green).

5. **Connection complete** -- final line in `highlight` (yellow):
   ```
   접속 완료!
   ```

6. **Fade to calendar** -- 0.3s crossfade to MonthView.

### Timing

Total boot duration: approximately 4-5 seconds (including modem sound). If the user taps the screen at any point, skip immediately to MonthView.

---

## UI Component Patterns

### List Items

Default state -- prefixed with `>` or `●`:
```
● 팀 미팅 14:00
● 점심 약속 12:30
> 코드 리뷰 16:00
```

Selected state -- `▶` prefix, text color changes to `highlight`:
```
▶ 팀 미팅 14:00
```

### Buttons

Always wrapped in square brackets:
```
[저장 F10]  [취소 ESC]  [삭제]
```

Active/pressed state inverts colors (text becomes `background`, background becomes `primaryText`).

### Progress / Loading

```
모뎀 연결 중 [■■■■■□□□□□] 50%
```

### Status Bar (Bottom)

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 56K CAL v1.0  │  2026.05.23  │  ●
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

`●` is green when calendar access is granted, red when denied.
