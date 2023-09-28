# flutter 간단한 WebView app 만들기

### 개발 목표

- [x] 자주 방문하는 WebUrl목록을 만들어 바로 접속하기
- [x] home widget 만들어서 즐겨찾기 처럼 사용하기

  > url최상위 url 링크로 접속하는 위젯을 만들었습니다.

- [ ] ios App Widget은 apple developer 등록 후 구현

---

### 기능별 포스팅

#### [url_list_screen](https://kimjunho97.tistory.com/35)

1. local에 url주소를 저장하고 불러온다.
2. 불러온 주소를 리스트로 보여준다.
3. 리스트는 삭제 및 추가만 할 수 있다. (수정을 제공할 필요 없는것 같음)

#### [web_view_screen](https://kimjunho97.tistory.com/37)

1. [webview_flutter library](https://pub.dev/documentation/webview_flutter/latest/webview_flutter/webview_flutter-library.html)

#### [flutter 간단한 WebView app 만들기 (home_widget 전편)](https://kimjunho97.tistory.com/38)

- home_widget 하나 띄워보기

#### [flutter 간단한 WebView app 만들기 (home_widget 후편)](https://kimjunho97.tistory.com/39)

---

### android settings 이슈

- #### android/app/src/AndroidManifest.xml에 android:usesCleartextTraffic="true" 추가

원인은 안드로이드에서 Http접근을 허용하지 않는다는 의미로 Https로 접근하면
문제 될 것이 없지만 해당 서버가 Https를 지원하지 않는다면 Http로 접근을 해야 합니다.
이런 문제가 발생하는 원인은 Android 진영에서 안드로이드 Pie(API28) 이상부터는
Cleartext HTTP를 비활성화하는 것으로 정책이 변경이 되었기 때문입니다.

웹서버가 https로 접근해도 url이 일치하지않아 redirect처리 할때 http로 접근하면 Err가 뜹니다.

```xml
    <application
        android:label="hybrid_app"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">
```
