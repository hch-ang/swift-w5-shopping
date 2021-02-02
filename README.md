# swift-w5-shopping
모바일 5주차 쇼핑 저장소



### 초기 세팅 0201 11:30

- 프로젝트 clone
- .gitignore 생성
- 프로젝트 생성

### 네비게이션 컨트롤러 생성 0201 11:35

- 네비게이션 컨트롤러 생성

![image-20210201113643546](README.assets/image-20210201113643546.png)

### Model, View, Controller, Util 그룹 생성 0201 11:48

- 각 그룹 생성
- 컨트롤러 이름 변경 ViewController -> MainViewController
- 네비게이션아이템 title 추가

![image-20210201114850409](README.assets/image-20210201114850409.png)

### CollectionView 생성 0201 13:25

- colletionView의 layout 설정(item, group, section 설정)
- shoppingListView에 오토레이아웃 적용

![image-20210201132333021](README.assets/image-20210201132333021.png)

### JsonModels 생성 0201 17:05

- StoreItem 구조체 생성

### CollectionView layout 설정 및 header 추가 0201 17:55

- supplementary view로 header 추가

![image-20210201175252653](README.assets/image-20210201175252653.png)

### HTTP 요청 받기 : 0201 1000

- http요청을 받는 loadData 메소드 구현

### HTTPRequestManager 생성 0201 1020

- 네트워크 관리 객체(HTTPRequestManager 클래스) 생성
- ItemManager 클래스에 getItems, getCount, subscript메소드 추가

### 타입 이름 변경 0202 1030

- jsonPath -> ItemType

