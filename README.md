# Ruby on Rails チュートリアルのサンプルアプリケーション

これは、次の教材で作られたサンプルアプリケーションです。   
[*Ruby on Rails チュートリアル*](https://railstutorial.jp/)
[Michael Hartl](http://www.michaelhartl.com/) 著

## ライセンス

[Ruby on Rails チュートリアル](https://railstutorial.jp/)内にある
ソースコードはMITライセンスとBeerwareライセンスのもとで公開されています。
詳細は [LICENSE.md](LICENSE.md) をご覧ください。

## 使い方

このアプリケーションを動かす場合は、まずはリポジトリを手元にクローンしてください。
その後、次のコマンドで必要になる RubyGems をインストールします。

```
$ bundle install --without production
```

その後、データベースへのマイグレーションを実行します。

```
$ rails db:migrate
```

最後に、テストを実行してうまく動いているかどうか確認してください。

```
$ rails test
```

テストが無事に通ったら、Railsサーバーを立ち上げる準備が整っているはずです。

```
$ rails server
```

詳しくは、[*Ruby on Rails チュートリアル*](https://railstutorial.jp/)
を参考にしてください。  
  
## リトライ
3章から挑戦。前回は10章でよくわからなくなったので、もう一度チャレンジ。  
このREADMEにわからないことや書き留めたいことをとりあえず書き込んでいく  
ブランチを章ごとに切っていこうと思う(途中で変わる可能性あり)。  
3章であれば、"3_***" と頭に章番号を付けてブランチを切る。  
環境は、cloud 9 を利用して開発していく。では、始める。  

## 3章
gemはtutorialの通りにした。gemのバージョンが異なると途中でエラーを発生してしまうかもしれないからだ。  
一回目はあまりそこの部分を意識しなかったのもエラーで躓いた１つなのではと考えた。  
  
### heroku セットアップ
デプロイにherokuを使うが、使い方は一章を参考にするとよい。  
```
# environmentへ移動
$ cd ~/environment

# クラウドIDE上でHerokuをインストールするコマンド
$ source <(curl -sL https://cdn.learnenough.com/heroku_install)

# herokuが使用できるか確認
$ cd rails_tutorial_app/
$ heroku -v
heroku/7.42.5 linux-x64 node-v12.16.2

# heroku ログイン
$ heroku login --interactive

# mail / passwordを入力し、ログインをする

# 新しいアプリケーションの作成
$ heroku create

# masterブランチへmerge
$ git checkout master
$ git merge <マージするブランチ名>

# herokuへデプロイ
$ git push heroku master

```
### staticpages_controller.rb の作成
```
# コントローラーの作成
$ rails g StaticPages home help
Running via Spring preloader in process 6709
      create  app/controllers/static_pages_controller.rb
       route  get 'static_pages/help'
       route  get 'static_pages/home'
      invoke  erb
      create    app/views/static_pages
      create    app/views/static_pages/home.html.erb
      create    app/views/static_pages/help.html.erb
      invoke  test_unit
      create    test/controllers/static_pages_controller_test.rb
      invoke  helper
      create    app/helpers/static_pages_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/static_pages.coffee
      invoke    scss
      create      app/assets/stylesheets/static_pages.scss
```
コントローラを作成するとき  
rails g controller <コントローラ名> <アクション名>  
と入力する  
コントローラ名は複数形で入力。これはRailsのルール。  
のちに出てくるmodelは単数形で入力。  
アクション名を入れると  
* ルート
* viewファイル

が作成される。そして作成されたコントローラーのメソッド名に定義される。  
つまりコントローラをジェネレートしたら、ルート、コントローラのメソッド、viewの3つが作成されるので、  
root_path/アクション にアクセスすれば、ブラウザでデフォルトページがみられる状態になっている。  
  
もう一つ作成されるものがTest。  
何らかの変更を行う際には、常に「自動化テスト」を作成して、機能が正しく実装されたことを確認する習慣を身に着ける。  
  
テストを書くタイミング  
* アプリケーションのコードよりも明らかにテストコードの方が短くシンプルになる (=簡単に書ける) のであれば、「先に」書く
* 動作の仕様がまだ固まりきっていない場合、アプリケーションのコードを先に書き、期待する動作を「後で」書く
* セキュリティが重要な課題またはセキュリティ周りのエラーが発生した場合、テストを「先に」書く
* バグを見つけたら、そのバグを再現するテストを「先に」書き、回帰バグを防ぐ体制を整えてから修正に取りかかる
* すぐにまた変更しそうなコード (HTML構造の細部など) に対するテストは「後で」書く
* リファクタリングするときは「先に」テストを書く。特に、エラーを起こしそうなコードや止まってしまいそうなコードを集中的にテストする
  

### 初めてのテスト
test/controllers/static_pages_controller_test.rb　　
```
class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_pages_home_url
    assert_response :success
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
  end

  # 追記
  test "should get about" do
    get static_pages_about_url
    assert_response :success
  end
end
```
上述のように追記するとエラーになる。  
about のルートもアクションも未定義のため、以下のようなエラーが発生。  
```
1) Error:
StaticPagesControllerTest#test_should_get_about:
NameError: undefined local variable or method `static_pages_about_url' for #<StaticPagesControllerTest:0x000000000462b7f0>
```
ルートの設定、コントローラでアクションの設定、viewの設定をしてあげれば、エラー回避でます。  
  
app/views/layouts/application.html.erb  
```
<!DOCTYPE html>
<html>
  <head>
    <title><%= yield :title %> | Mutter App</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>
```
レイアウトを使う際に、/static_pages/homeにアクセスするとhome.html.erbの内容がHTMLに変換され、<%= yield %>の位置に挿入される  
```
<%= csrf_meta_tags %>
<%= stylesheet_link_tag ... %>
<%= javascript_include_tag "application", ... %>
```
上の3つのERBは、それぞれスタイルシート、JavaScript、csrf_meta_tagsメソッドをページ内で展開するためのものです。スタイルシートとJavaScriptは、Asset Pipeline (5.2.1) の一部です。csrf_meta_tagsは、Web攻撃手法の１つであるクロスサイトリクエストフォージェリー (Cross-Site Request Forgery: CSRF)を防ぐために使われるRailsのメソッドです。  



