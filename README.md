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
ルートの設定、コントローラでアクションの設定、viewの設定をしてあげれば、エラー回避できる。  
  
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
上の3つのERBは、それぞれスタイルシート、JavaScript、csrf_meta_tagsメソッドをページ内で展開するためのもの。スタイルシートとJavaScriptは、Asset Pipeline (5.2.1) の一部。csrf_meta_tagsは、Web攻撃手法の１つであるクロスサイトリクエストフォージェリー (Cross-Site Request Forgery: CSRF)を防ぐために使われるRailsのメソッド。  

※ブランチ 3_static-pageにこの3章のまとめの内容を盛り込み漏れたので3_static-pageをcloneする際は以下の内容をコードにも盛り込んでないので気を付けること  
### 3章のまとめ
* 新しいRailsアプリケーションをゼロから作成したのはこれで3度目。今回も必要なgemのインストール、リモートリポジトリへのプッシュ、production環境まで行った
* コントローラを新規作成するためのrailsコマンドはrails generate controller ControllerName アクション名 (省略可)。
* 新しいルーティングはconfig/routes.rbファイルで定義する
* Railsのビューでは、静的HTMLの他にERB (埋め込みRuby: Embedded RuBy) が使える
* 常に自動化テストを使って新機能開発を進めることで、自信を持ってリファクタリングできるようになり、回帰バグも素早くキャッチできるようになる
* テスト駆動開発では「red ・ green ・REFACTOR」サイクルを繰り返す
* Railsのレイアウトでは、アプリケーションのページの共通部分をテンプレートに置くことでコードの重複を解決することができる

### minitest reporters
RailsのデフォルトのテストでREDやGREENを表示するためにminitest-reporters gemを使用する  
使い方は以下ファイルに以下の通りコードを追加する。  
test/test_helper.rb に以下2行追加  
```
 ENV['RAILS_ENV'] ||= 'test'
 require File.expand_path('../../config/environment', __FILE__)
 require 'rails/test_help'
+require "minitest/reporters"
+Minitest::Reporters.use!
 
 class ActiveSupport::TestCase
   # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
```
  
### Guardによるテスト自動化
Guardは、ファイルシステムの変更を監視し、例えばstatic_pages_test.rbファイルなどを変更すると自動的にテストを実行してくれるツール。  
gem ファイルにすでに取り込んでいるので、あとは初期化だけ。  
```
$ bundle exec guard init
13:19:17 - INFO - Writing new Guardfile to /home/ec2-user/environment/rails_tutorial_app/Guardfile

# Cloud9を使っている場合は、Guardの通知を有効にするためにtmuxをインストールする必要があり
$ sudo yum install -y tmux    # Cloud9を使っている場合に必要
```
  
Guardfile  
```
# Guardのマッチング規則を定義
guard :minitest, spring: "bin/rails test", all_on_start: false do
  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch('test/test_helper.rb') { 'test' }
  watch('config/routes.rb')    { integration_tests }
  watch(%r{^app/models/(.*?)\.rb$}) do |matches|
    "test/models/#{matches[1]}_test.rb"
  end
  watch(%r{^app/controllers/(.*?)_controller\.rb$}) do |matches|
    resource_tests(matches[1])
  end
  watch(%r{^app/views/([^/]*?)/.*\.html\.erb$}) do |matches|
    ["test/controllers/#{matches[1]}_controller_test.rb"] +
    integration_tests(matches[1])
  end
  watch(%r{^app/helpers/(.*?)_helper\.rb$}) do |matches|
    integration_tests(matches[1])
  end
  watch('app/views/layouts/application.html.erb') do
    'test/integration/site_layout_test.rb'
  end
  watch('app/helpers/sessions_helper.rb') do
    integration_tests << 'test/helpers/sessions_helper_test.rb'
  end
  watch('app/controllers/sessions_controller.rb') do
    ['test/controllers/sessions_controller_test.rb',
     'test/integration/users_login_test.rb']
  end
  watch('app/controllers/account_activations_controller.rb') do
    'test/integration/users_signup_test.rb'
  end
  watch(%r{app/views/users/*}) do
    resource_tests('users') +
    ['test/integration/microposts_interface_test.rb']
  end
end

# 与えられたリソースに対応する統合テストを返す
def integration_tests(resource = :all)
  if resource == :all
    Dir["test/integration/*"]  else
    Dir["test/integration/#{resource}_*.rb"]
  end
end

# 与えられたリソースに対応するコントローラのテストを返す
def controller_test(resource)
  "test/controllers/#{resource}_controller_test.rb"
end

# 与えられたリソースに対応するすべてのテストを返す
def resource_tests(resource)
  integration_tests(resource) << controller_test(resource)
end
```
上記の通りに編集。  

.gitignoreにSpringを追加
```
# Ignore Spring files.
/spring/*.pid
```
  
## 4章
### カスタムヘルパー
新しく作ったメソッドはカスタムヘルパー と呼ばれる。  
**full_titileヘルパー**  
yieldにあるタイトルが何もない場合、" | Mutter App"と "|"が余計。  
なので、タイトルが何もない場合、"Mutter App" にする。  
app/helpers/application_helper.rb  
```
 module ApplicationHelper
+
+  # ページごとの完全なタイトルを返します。
+  def full_title(page_title = '')
+    base_title = "Mutter App"
+    if page_title.empty?
+      base_title
+    else
+      page_title + " | " + base_title
+    end
+  end
 end
```
full_titileメソッドを定義したので、早速使ってみる。  
app/views/layouts/application.html.erb  
```
 <!DOCTYPE html>
 <html>
   <head>
-    <title><%= yield :title %> | Mutter App</title>
+    <title><%= full_title(yield :title) %></title>
     <%= csrf_meta_tags %>
 
     <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
```
とすれば、:title が空でも "|"が付かずに表示することができる。
  
※module ApplicationHelper  
モジュールは、関連したメソッドをまとめる方法の１つで、includeメソッドを使ってモジュールを読み込むことができる(ミックスイン (mixed in) とも呼ぶ)。
単なるRubyのコードを書くのであれば、モジュールを作成するたびに明示的に読み込んで使うのが普通だが、Railsでは自動的にヘルパーモジュールを読み込んでくれるので、include行をわざわざ書く必要がない。
つまり、このfull_titleメソッドは自動的にすべてのビューで利用できるようになっている、ということ。  
  
### 4章まとめ
* Rubyは文字列を扱うためのメソッドを多数持っている
* Rubyの世界では、すべてがオブジェクトである
* Rubyではdefというキーワードを使ってメソッドを定義する
* Rubyではclassというキーワードを使ってクラスを定義する
* Railsのビューでは、静的HTMLの他にERB (埋め込みRuby: Embedded RuBy) も使える
* Rubyの組み込みクラスには配列、範囲、ハッシュなどがある
* Rubyのブロックは (他の似た機能と比べ) 柔軟な機能で、添え字を使ったデータ構造よりも自然にイテレーションができる
* シンボルとはラベルである。追加的な構造を持たない (代入などができない) 文字列みたいなもの
* Rubyではクラスを継承できる
* Rubyでは組み込みクラスですら内部を見たり修正したりできる
* 「deified」という単語は回文である

 
## 5章
### annotate インストール
modelを触る前から少し気が早いかもしれないが、思い出したので先にインストールしておく。  
annotate。  
モデルの構造をモデルファイルにコメントとして記載してくれる。  
各スキーマの情報をファイルの先頭にコメント追記してくれるgem。  
例えば、あるテーブルのカラムって何があったか知りたいときに一々DBへアクセスしてなどがなくなる。  
  
Gemfile  
```
group :development do
   gem 'listen',                '3.1.5'
   gem 'spring',                '2.0.2'
   gem 'spring-watcher-listen', '2.0.1'
+  gem 'annotate'
 end
```
```
$ bundle install --without development

# annotateの設定ファイルを作成
$ rails g annotate:install
```
lib/tasks/auto_annotate_models.rake  
```
    # 以下を true から false へ変更する
    'show_indexes'  => 'true'

    'show_indexes'  => 'false'
```
これでコメントが自動につくはず。modelの作成までのお楽しみ。  
  
### Webサイトのレイアウト navタグ
app/views/layouts/application.html.erb  
```
    <!--[if lt IE 9]>
      <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/r29/html5.min.js">
      </script>
    <![endif]-->
```
条件付きコメントと呼ばれるもので、今回のような状況のためにInternet Explorerで特別にサポートされている。これにより、Firefox、Chrome、Safariなどの他のブラウザに影響を与えずに、IEのバージョンが9未満の場合にのみHTML5 shimを読み込めるため、非常に好都合。  
  
Homeページを作成していく。  
app/views/static_pages/home.html.erb  
```
<div class="center jumbotron">
  <h1>Welcome to the Sample App</h1>

  <h2>
    This is the home page for the
    <a href="https://railstutorial.jp/">Ruby on Rails Tutorial</a>
    sample application.
  </h2>

  <%= link_to "Sign up now!", '#', class: "btn btn-lg btn-primary" %>
</div>

<%= link_to image_tag("rails.png", alt: "Rails logo"),
            'http://rubyonrails.org/' %>
```
  
**link_to**  
第1引数はリンクテキスト、第2引数はURL。このURLは5.3.3で名前付きルート (Named Routes) に置き換えますが、今はWebデザインで一般に使われるスタブ用の (とりあえずのダミーとして使われる) URL「'#'」を置いておく。第3引数はオプションハッシュで、この場合はサンプルアプリのリンクでCSS id logoを指定している。  
**image_tag**  
Railsは該当する画像ファイルを、アセットパイプラインを通してapp/assets/images/ディレクトリの中から探してくれる。  
第一引数にimageファイル名。第二引数にalt属性。  
  
画像をダウンロードする  
```
$ curl -o app/assets/images/rails.png -OL railstutorial.jp/rails.png  
```
Railsは該当する画像ファイルを、アセットパイプラインを通してapp/assets/images/ディレクトリの中から探してくれる。  
  
### bootstrap
Gemfile  
```
 gem 'rails',        '5.1.6'
+gem 'bootstrap-sass', '3.3.7'
 gem 'puma',         '3.9.1'
 gem 'sass-rails',   '5.0.6'
 gem 'uglifier',     '3.2.0'
```
```
$ bundle install --without development
```
このチュートリアルでは (簡潔のために) すべてのCSSを1つにまとめる方針を採っている。カスタムCSSを動かすための最初の一歩は、カスタムCSSファイルを作ること。  
```
$ touch app/assets/stylesheets/custom.scss
```
app/assets/stylesheets/custom.scss  
```
@import "bootstrap-sprockets";
@import "bootstrap";
```
  
こうすることで、bootstrapが適用され、Home pageのレイアウトに変化がみられる。  
※ちなみにb[ootstrap4 勉強しました](https://github.com/8-trees-coffee/rails5.0_boards_app/tree/97_boundary-value-and-mock#bootstrap%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)。  
  
TODO CSSのお勉強、Bootstrapの使い方
  
### Partial
パーシャルはviewファイルに記載している一部をパーツ化するイメージ。  
_XXXX.html.erb とアンダーバーを入れて、パーシャルにする。パーシャルを使いたいときはrenderメソッドを使用する。  
/app/views/layouts/application.html.erb  
```
     <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
     <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
-    <!--[if lt IE 9]>
-      <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/r29/html5.min.js">
-      </script>
-    <![endif]-->
+    <%= render partial: 'layouts/shim' %>
   </head>
   <body>
-    <header class="navbar navbar-fixed-top navbar-inverse">
-      <div class="container">
-        <%= link_to "Mutter app", '#', id<: "logo" %>
-        <nav>
-          <ul class="nav navbar-nav navbar-right">
-            <li><%= link_to "Home",   '#' %></li>
-            <li><%= link_to "Help",   '#' %></li>
-            <li><%= link_to "Log in", '#' %></li>
-          </ul>
-        </nav>
-      </div>
-    </header>
+    <%= render partial: 'layouts/header' %>
     <div class="container">
```
render partial: 'layouts/shim' のように、partialのkeyにlayouts から記載しないといけないのはどうしてだろうと考えた。
実際、render partial: 'shim' と書いて、アクセスするとエラーになる。
static_pages/_shim はないですよとなるのだ。これはstatic_pages_controllerが呼び出され、例えばhomeアクションが指定されたら、views/static_pages/home.html.erbを見に行くので
partialで呼び出すときもstatic_pagesフォルダを見に行くのだと思う。  
これはあくまで私の推測。だから、partialのkeyに layouts/ を入れるのが必要だと思った。  
  
shim, header, footer とrails_default, 演習でhead を作成していく  

### アセットパイプライン
チュートリアルを読むこと!!(そんなこと言ったら全部そうなる)  
scssファイルはネストできる  

### レイアウトのリンク
aタブを使うのではなく、link_to メソッドを使うのがrails流。  
link_toの引数であるリンク先のパスの記載の仕方がroutes.rbの書き方で分かりやすくなる  
  
root_pathやroot_urlといったメソッドを通してURLを参照することができる。
ちなみに前者はルートURL以下の文字列を、後者は完全なURLの文字列を返す。  
```
root_path -> '/'
root_url  -> 'http://www.example.com/'
```
基本的には_path書式を使い、リダイレクトの場合のみ_url書式を使うようにする。
これはHTTPの標準としては、リダイレクトのときに完全なURLが要求されるため。
ただしほとんどのブラウザでは、どちらの方法でも動作する。  

### リンクのテスト
統合テストを使うと、アプリケーションの動作を端から端まで (end-to-end) シミュレートしてテストすることができる。  
assert_select は柔軟でパワフルな機能。自分で調べてみるといいかも。  
Applicationヘルパーで使っているfull_titleヘルパーを、test環境でも使えるようにすると便利。
なので、test/test_helper.rb でApplicationHelper モジュールをインクルードしてやる。
ApplicationHelperモジュールはapplication_helper.rbで作成している。4章で作りましたよ~。忘れたら4章へ戻りましょ。  
自作のモジュールはカスタムヘルパーと呼ぶ!!  
app/helpers/application_helper.rb  
```
module ApplicationHelper

  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "Mutter App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
```
こいつをtest環境でも使えるようにするには、以下のようにする  
test/test_helper.rb  
```
Minitest::Reporters.use!
 class ActiveSupport::TestCase
   # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
   fixtures :all
+  include ApplicationHelper
 
   # Add more helper methods to be used by all tests here...
 end
```
そして、full_title自体を評価するテストケースを作成することができる  
test/helpers/application_helper_test.rbを作成  
```
require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Mutter App"
    assert_equal full_title("Help"), "Help | Mutter App"
  end
end
```
  
### Usersコントローラの作成
Usersコントローラを作成し、newアクションを生成する。このnewアクションはサインアップのアクションとなる。  
pathをsignup_pathを使えるように、config/routes.rbを変えて、users_controller_test.rbの getするpathを更新しておく。  
このときにroutesを調べようと、rails routesを実行したらエラーになった。  
どうやら、annotateが悪さをしているようだ…。余計なことをやってしまった。  
とりあえず、先に進もう。  