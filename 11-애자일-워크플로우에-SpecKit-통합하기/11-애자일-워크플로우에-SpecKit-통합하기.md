# 11강: 애자일(Agile) 워크플로우에 SpecKit 통합하기

## 개요
SpecKit을 실무의 애자일(Agile) 스프린트 구조에 맞물려 사용하는 단계입니다. Jira나 Linear 같은 티켓 넘버를 바탕으로 명세(Spec)부터 구현(Implement)까지 이어지는 매끄러운 사이클을 경험합니다.

## 학습목표
- 티켓 기반 명세서 작성을 통한 작업 범위 통제
- 스프린트 주기에 맞춘 릴리즈 단위의 Tasks 분할
- 팀의 개발 사이클과 SpecKit 명령어의 결합 이해

## 사용형식 / 메뉴얼

```mermaid
flowchart LR
    A[티켓 발급: TICKET-101] --> B(AI: 101 spec 생성)
    B --> C[tasks.md 작성]
    C --> D[코드 구현 및 PR]
    D --> E[QA 및 스프린트 종료]
```

## 직접해보기

**Step 1. 브랜치와 티켓 연결**
`git checkout -b feature/TICKET-101` 명령어로 브랜치를 딴 뒤, AI에게 "TICKET-101 요구사항(본문 복붙)을 바탕으로 spec.md를 새로 생성해줄래?"라고 지시합니다.

**Step 2. 전용 명세서 분리**
프로젝트 루트가 아닌 `specs/ticket-101/spec.md` 형태로 폴더를 나누어 작성하게 함으로써 단일 티켓 단위로 SDD를 수행합니다.

## 실전 예제

**예제 1. 티켓 기반 독립 명세 환경 생성**
특정 지라 티켓(JIRA-402)을 위한 독립적인 폴더와 초기 파일을 세팅합니다.
```bash
specify init --ticket JIRA-402 --dir specs/JIRA-402
```

**예제 2. 스프린트 에픽(Epic) 쪼개기**
거대한 에픽 문서를 여러 개의 티켓 단위 Spec 파일로 분할합니다.
```bash
specify split --input specs/epic-payment.md --strategy ticket
```

**예제 3. 작업 브랜치와 명세서 동기화(Sync)**
형상 관리와 연동하여 현재 브랜치 이름으로 명세서를 자동 매핑합니다.
```bash
git checkout -b feature/JIRA-402
specify sync --branch
```

## Tips 
- **주의사항**: 여러 티켓을 하나의 `spec.md`에 섞어 쓰지 마세요.
- **다이나믹한 활용법**: "내일부터 시작될 스프린트의 에픽(Epic) 문서를 줄 테니, 이를 5개의 티켓 사이즈 spec 문서로 쪼개줘" 처럼 활용할 수 있습니다.
- **다음강좌 소개**: 팀의 언어와 프레임워크에 맞게 AI를 조련하는 **[12강: 커스텀 템플릿(Templates) 고도화]** 입니다.
