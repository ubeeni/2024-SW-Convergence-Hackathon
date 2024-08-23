### Prefix 정리

- design: 뷰 그리기
- feat: 기능 구현
- docs: Readme 파일 같은 문서 파일을 만들거나 수정했을 때
- fix: 버그나 오류를 고쳤을 때
- setting: 세팅
- merge: 머지
- chore: 이외에 모든 것.

### 1. 이슈 작성
    
    prefix: 이슈 설명
    
    ex) feat: 회원가입 기능 구현
    
### 2. 브랜치 생성
    
    prefix/이슈 번호
    
    ex) feat/#1
    
### 3. 커밋 규칙
    
    prefix: #이슈번호 - 이슈 내용
    
    ex) git commit -m “feat: #1 - 회원가입 기능 구현”
    
### 4. PR 규칙
    1. 깃에 있는 main 브랜치를 pull 한다. → git pull main
    2. 내 브랜치에서 main과 머지 한다. → git merge main
    3. 내 로컬에서 충돌이 발생했다면 해당 충돌을 해결한다.
    4. 깃 상의 내 브랜치에 push 한다.
    5. PR을 보낸다.
