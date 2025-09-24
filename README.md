# FolderUploader

  macOS용 폴더 내 파일 일괄 선택 및 드래그 업로드 도구

  ## 개요

  폴더를 선택하면 그 안의 모든 파일(하위 폴더 포함)을 재귀적으로 탐색해서 한
   번에 선택할 수 있게 해주는 macOS 네이티브 앱입니다. 여러 폴더에 흩어진
  파일들을 일일이 찾아서 선택할 필요 없이, 드래그 앤 드롭으로 간편하게
  업로드할 수 있습니다. 클로드 코드를 사용하지 않고, 클로드만 사용 할 시
  파일 업로드를 간편하게 사용하기 위해 제작하였습니다.

  ## 주요 기능

  - 폴더 선택 시 하위 폴더까지 모든 파일 자동 탐색
  - 파일 목록에서 드래그 앤 드롭으로 직접 업로드
  - 단일 파일 또는 다중 파일 선택 지원
  - 빠르고 가벼운 Swift 네이티브 앱
  - macOS 11.0 이상 지원
  
<img width="912" height="560" alt="스크린샷 2025-09-24 오후 1 42 47" src="https://github.com/user-attachments/assets/a15cde2b-28de-4b42-8839-db140241c758" />
<img width="712" height="544" alt="스크린샷 2025-09-24 오후 1 42 42" src="https://github.com/user-attachments/assets/0f0e7dbd-c78f-4acb-851e-1d109df8a36a" />


  ## 설치 방법

  1. 최신 릴리스에서 `FolderUploader.app` 다운로드
  2. Applications 폴더로 이동
  3. 더블클릭으로 실행

  ## 사용법

  1. "폴더 선택" 버튼 클릭
  2. 업로드하려는 파일들이 있는 폴더 선택
  3. 파일 목록에서 원하는 파일들을 선택 (기본적으로 모든 파일 선택됨)
  4. 선택된 파일들을 드래그해서 웹사이트나 다른 앱에 업로드

  ## 개발 환경

  - Swift 6.2+
  - Xcode
  - macOS 11.0+

  ## 빌드 방법

  ```bash
  # 개발용 빌드
  swift build

  # 개발용 실행
  swift run

  # 릴리스용 앱 생성
  ./create_app.sh

  라이센스

  MIT License
