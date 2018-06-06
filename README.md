# Ruby on Rails 튜토리얼의 샘플 애플리케이션

이것은 다음 자료에서 만들어진 샘플 응용 프로그램입니다.   
[* Ruby on Rails 튜토리얼 * (https://railstutorial.jp/)
[Michael Hartl (http://www.michaelhartl.com/)의

## 라이센스

[Ruby on Rails 튜토리얼 (https://railstutorial.jp/) 내에있는
소스 코드는 MIT 라이센스와 Beerware 라이센스하에 공개되고 있습니다.
자세한 내용은 [LICENSE.md (LICENSE.md)를 참조하십시오.

## 사용법

이 애플리케이션을 실행하면 먼저 저장소를 수중에 복제합니다.
그런 다음 명령에 필요한 RubyGems를 설치합니다.

```
$ bundle install --without production
```

다음 데이터베이스로 마이그레이션을 수행합니다.

```
$ rails db : migrate
```

마지막으로 테스트를 실행하고 잘 작동하고 있는지 확인하십시오.

```
$ rails test
```

테스트가 성공적으로 통과하면, Rails 서버를 시작할 준비가 되었습니다.

```
$ rails server
```

자세한 내용은 [* Ruby on Rails 튜토리얼 * (https://railstutorial.jp/)
를 참고하십시오.