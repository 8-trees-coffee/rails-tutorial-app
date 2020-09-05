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
### annotate インストール (⇒ これは今やらないほうがいい)
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
⇒ この先、進むとrails db:migrate ができなくなるので、 lib/tasks/auto_annotate_models.rake を削除した。  
   折を見て、もう一度annotateを使用してみようと思う  
   
### 5章まとめ
* HTML5を使ってheaderやfooter、logoやbodyといったコンテンツのレイアウトを定義しました
* Railsのパーシャルは効率化のために使われ、別ファイルにマークアップを切り出すことができます
* CSSは、CSSクラスとidを使ってレイアウトやデザインを調整します
* Bootstrapフレームワークを使うと、いい感じのデザインを素早く実装できる
* SassとAsset Pipelineは、(開発効率のために切り分けられた) CSSの冗長な部分を圧縮し、本番環境に最適化した結果を出力する
* Railsのルーティングでは自由にルールを定義することができ、また、その際に名前付きルートも使えるようになる
* 統合テストは、ブラウザによるページ間の遷移を効率的にシミュレートする

## 6章
ユーザーモデルを作成していく。6章、7章、8章、9章、10章と完成させていく。9章から難しくなるから、じっくり取り組んでいく。  
Railsでは、データを永続化するデフォルトの解決策として、データベースを使ってデータを長期間保存する。
また、データベースとやりとりをするデフォルトのRailsライブラリはActive Recordと呼ばれる。
Active Recordは、データオブジェクトの作成/保存/検索のためのメソッドを持っている。  
Users  
|id|name|email|  
|1|Michael Hartl|mhartl@example.com|  
|2|Sterling Archer|archer@example.gov|  
  
という形でデータコラムがname, emailとある場合は以下のようにジェネレートする
```
$ rails g model User name:string email:string
```
modelを作成するときは、単数形にするので、Userとなる。(ちなみにControllerの時は複数形であった)  
こうすると、db/migrate/にマイグレーションファイルが作成される。  
db/migrate/[timestamp]_create_users.rb  
```
class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
```
マイグレーション自体は、データベースに与える変更を定義したchangeメソッドの集まり。
changeメソッドはcreate_tableというRailsのメソッドを呼び、ユーザーを保存するためのテーブルをデータベースに作成する。
create_tableメソッドはtオブジェクトを使って、nameとemailカラムをデータベースに作る。
モデル名は単数形 (User) ですが、テーブル名は複数形 (users)。
これはRailsで用いられる言葉の慣習を反映している。
モデルはひとりのユーザーを表すのに対し、データベースのテーブルは複数のユーザーから構成される。
ブロックの最後の行t.timestampsは特別なコマンドで、created_atとupdated_atという２つの「マジックカラム (Magic Columns)」を作成する。
これらは、あるユーザーが作成または更新されたときに、その時刻を自動的に記録するタイムスタンプ。  
マイグレーションは以下の通り  
```
$ rails db:migrate
```
そうすると、db/schema.rbが以下のように変わる  
```
ActiveRecord::Schema.define(version: 20200829214124) do

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
```
ちなみに、
```
$ rails db:rollback
```
をすると、マイグレーション前に戻る。schema.rbは以下になっている。  
db/schema.rb  
```
ActiveRecord::Schema.define(version: 0) do

end
```
何もなくなった。マイグレーションして戻しておきましょう。  
  
データベースができたので色々調べていくが、この時にコンソールをサンドボックスモードで起動させて、データベースの挙動を見ていくとよい。  
```
$ rails console -s
```
"Any modifications you make will be rolled back on exit" 
(ここで行ったすべての変更は終了時にロールバックされます) というメッセージにわかりやすく示されているように、
コンソールをサンドボックスで起動すると、
そのセッションで行ったデータベースへの変更をコンソールの終了時にすべて “ロールバック” (取り消し) してくれる。
  
チュートリアルを見ながら、色々調べていくが、ポイントなのは使用されているメソッド。あとのコードを組む際にたくさん使用されるので、整理しておくといい。  
  
**ユーザ情報の作成と保存、削除のメソッド**  
* 作成：new  
* 保存: save  
* 作成と保存一緒にやる: create  
* 削除: destroy(createの逆)
 

newはsing up機能になる。この時、createは使わない。なぜなら、不適切な情報でユーザー情報をsign upされてしまう可能性があるため。
createを使用すると、作成~保存まで一気に処理をしてしまうが、newとsaveに分けることにより、newされてsaveをしようとした時に登録情報が適切かどうかの判断ができる。
その場合は、saveができないように制御するようにすれば、データベースに不適切なユーザ情報を保存せず済む
(この機能をvalidationというが、この後勉強する)  
  
**ユーザ情報検索**
* find(:id)
* find_by(key: value)
* first 
* all

findメソッドの引数はid番号。id番号が存在しなければ、例外が発生する。  
find_byメソッドは、引数に例えば email: "mhartl@example.com" と入れて使うと、そのemailを持っているユーザを検索することができる。　　
firstメソッドは最初のユーザを検索することができ、allは全員を調べることができる。all.lengthとやると、登録ユーザ数が返ってくる。  
  
**ユーザ情報更新**
* 個別代入 (saveメソッドでsaveをしないと保存されない)
* update_attributes (成功時には変更と保存を同時に行う。検証に失敗するとこのメソッドの呼び出しに失敗する)
* update_attribute (特定の属性のみを更新したい場合に使用。このメソッドは検証回避できる)
 

()に詳細を記載したが、一週目の時はupdate_attributesとupdate_attributeの違いに気付かず、混乱した。
また、保存や更新が一気にされるメソッドとそうではないメソッドがあるのでそこもポイントだと思う。
そこも今思えば、混乱ポイントになっていたと思う。全然わかっていなかった。  
  
### 検証
このチュートリアルではよく使われる以下の検証について説明してくれるようだ。  
* 存在性 (presence)の検証
* 長さ (length)の検証
* フォーマット (format)の検証
* 一意性 (uniqueness)の検証
* 確認(confirmation)
 

これだけ説明してくれれば十分だと思う。  
  
まずはテストケースの作成。  
まず有効なモデルのオブジェクトを作成し、その属性のうちの1つを有効でない属性に意図的に変更する。
そして、バリデーションで失敗するかどうかをテストする。
以上のような方針でテストケースの作成をする。
念のため、最初に作成時の状態に対してもテストを書いておき、最初のモデルが有効であるかどうかも確認してく。
このようにテストすることで、バリデーションのテストが失敗したとき、バリデーションの実装に問題があったのか、
オブジェクトそのものに問題があったのかを確認することができる。  
  
Validationのテストは、test/models/のファイルで行う。  
test/models/user_test.rb  
```
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

    assert @user.valid?
  end
end
```
### 存在性
ユーザー登録する際に名前を空欄にして登録しようとすると大概エラーが出る。  
それを設定する。  
まずはテストから。名前が空欄の場合、valid? で falseがでることをテスト。  
test/models/user_test.rb  
```
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end
  
+ test "name should be present" do
+   @user.name = "   "
+   assert_not @user.valid?
+ end
end
```
この時点でrails test:model をやるとエラーになる。名前を空欄で入力しても登録できる状態のため。では空欄の場合、はじく設定をモデルで行う。  
app/models/user.rb  
```
class User < ApplicationRecord
  validates :name, presence: true
end
```
これで設定ができました。再びrails test:model をやるとテストがパスすると思います。同じように、メールも設定しちゃいましょう。  

**失敗したときに作られるerrorsオブジェクト**
もし、falseだったらerrorsオブジェクトが作成されます。@user.errors.full_messagesのように使用すると、エラーメッセージ全文を取得できます。  
このあと、@user.valid? でfalseの場合、view上でユーザにエラー内容を知らせるためにerrorsオブジェクトを使用しますので覚えておきましょう。  
  
### 長さ
ここは文字数制限ですね。○○文字までしか入力できません、などというやつですね。  
```
validates :name, length: { maximum: 50 }
```
という感じで、長さ指定していくのです。  
[※参考URL](https://guides.rubyonrails.org/active_record_validations.html#length)  
  
### フォーマット
正規表現が出てきます。ここはもう一度勉強しなおさないといけない。  
【TODO】正規表現の勉強  
ここでは、メールアドレスの正しいフォーマットかどうかを検証。たとえば"@"がちゃんとあるとか、"/"などの無効な文字が使用されていないかなど。  
では、早速テスト。有効なメールパターンと無効なメールパターン色々設定してのテスト。 
まずは有効なパターン。  
test/models/user_test.rb  
```
  ...
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

```
上述のようにassertメソッドの第2引数にエラーメッセージを追加すると、どのメールアドレスでテストが失敗したのかを特定できるようになる。  
  
**inspectメソッド**
これは要求されたオブジェクトを表現する文字列を返す。  
  
そして無効なパターン。  
test/models/user_test.rb  
```
  ...
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
end
```
  
そして、フォーマットを検証する。  
```
  validates :email, format: { with: /<regular expression>/ }
```
上記の <regular expression> に正規表現を入れますが、そこには定数を定義して使用するのがよい。  
```
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }
```  
  
### 一意性
メールアドレス、ダブってないよねってのを確認。  
:uniquenessを使用して、ダブり検証をします。
  
では、まずテスト。  
test/models/user_test.rb
```
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
```
dupメソッドで@userをもう一個作成(duplicate_user)。@userをセーブした後に、duplicate_userは重複するため、valid?でfalseを返すはず。  
では次に、user/models/user.rbで:uniquenessを使おう。  
app/models/user.rb  
```
  validates :email, uniqueness: true
```
これを追記すればOK!!  
ただ、テストのduplicate_user のメールアドレスを大文字にしたら、これは重複したってことにならない。よって、uniquenessをパスしてしまう。  
テストしてみればわかる。  
test/models/user_test.rb
```
  test "email addresses should be unique" do
    duplicate_user = @user.dup
+   duplicate_user.email.upcase!
    @user.save
    assert_not duplicate_user.valid?
  end
```
上記一行追加して、rails test:models を行うと、エラーとなる。  
これを解決するには、以下のようにモデルの検証設定を行えばよい。  
app/models/user.rb  
```
  validates :email, uniqueness: { case_sensitive: false }
```
case_sensitive: false にすることにより、大文字・小文字の区別を無効とする  
  
これで終了…と思いきや、まだ終わりではない。  
Active Recordはデータベースのレベルでは一意性を保証できていない。  
具体的事例を挙げると、ユーザーが会員登録する際、登録申請ボタンを素早く2回クリックしたら、リクエストが二つ連続で送信され、
同一のメールアドレスを持つユーザーレコードが（一意性の検証を行なっているにも関わらず）作成されてしまう。  
**RailsのWebサイトでは、トラフィックが多い時にこのような問題が発生する。**  
そのため、以下の取り組みが必要となる。  
データベース上のemailのカラムにインデックス(index)を追加し、そのインデックスが一意であるようにする。  
データベース上のユーザー探索で、findメソッドを使って探す場合、
今のままでは先頭から順にユーザーを一人ずつ探していくことになる。
そうなると、例えばユーザーが1000人登録されている場合、1000番目のユーザーを探し当てるには1000回もサーチしなければならない。
これはデータベースの世界では全表スキャン(Full-table Scan)として知られており、
DBへの負担やリクエストの回数など考えても極めてよくない。  
その点からもemailのカラムにインデックスを追加すれば、
割り当てたインデックスを管理する表の中から探し当てればいい訳で、
アルゴリズムの計算量が比較的少なくて済む。  
emailカラムにインデックスを追加するためには、migrationジェネレーターを使ってマイグレーションを直接作成する必要がある。  
```
$ rails g migration add_index_to_user_email
      invoke  active_record
      create    db/migrate/20200905110035_add_index_to_user_email.rb
```
  
生成されたファイルに、[add_indexというメソッド](https://railsdoc.com/migration#add_index)を使ってusersテーブルのemailカラムに、一意性を強制する為のunique: trueオプションを渡す。  
db/migrate/20200905110035_add_index_to_user_email.rb  
```
class AddIndexToUserEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true
  end
end
```
設定したらDBへ反映  
```
$ rails db:migrate
```
db/schema.rb  
```
   create_table "users", force: :cascade do |t|
     t.string "name"
     t.string "email"
     t.datetime "created_at", null: false
     t.datetime "updated_at", null: false
+    t.index ["email"], name: "index_users_on_email", unique: true
   end
```
create_tableにt.indexが追加された  
  
この時点ではテストDB用のサンプルデータが含まれているfixtures内で一意性の制限が保たれていないため、テスとは失敗する。  
  
今まではgenerateコマンドでfixtureが自動的に生成されていたが、
今回はmigrationコマンドを使用した為生成されていない。  
  
test/fixtures/users.ymlをとりあえず全部クリアーにしておく。また8章で使用するらしい。  
  

あともう一つ。いくつかのデータベースのアダプタが、常に大文字小文字を区別するインデックス を使っているとは限らない問題への対処。  
例えばFoo@ExAMPle.Comとfoo@example.comが別々の文字列と解釈してしまうケースがある。
これらの文字列は同一であると解釈されるべきなので、
今回はデータベースに保存される直前に全ての文字列を小文字に変換する
  
これを実装するために、Active Recordのcallbackメソッドを利用する。
  
これはある特定の時点で呼び出されるメソッド。今回はオブジェクトが保存される前に実行したいため
before_saveというコールバックを使う。以下の通り、追記する。
  
app/models/user.rb
```
class User < ApplicationRecord
+ before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
end
```
befre_saveコールバックに{}内のブロックを渡してユーザーのメールアドレスを設定している。
現在の値をStringクラスのdowncaseメソッドを使って、小文字にしたメールアドレスに変換しているため、
大文字小文字が混同する心配がなくなる。  
ちなみに{}内の書き方は以下でもよいとのこと。  
```
# {}内のブロックの書き方
# その１
before_save { self.email = self.email.downcase }

# その２
before_save { self.email = email.downcase }
```
これで、素早く2回登録ボタンクリックした場合登録できてしまう問題が解決。    
* 二度目のレコード保存のリクエストは一意性の制約によって拒否
* emailにインデックス属性を追加したことで、サーチ効率の向上
* 大文字小文字混同のメールアドレスをDBsave前に小文字に変換し一意性を保証

### セキュアなパスワードを追加する
セキュアなパスワードとは各ユーザーにパスワードとパスワードの確認を入力させ、それを (そのままではなく) ハッシュ化したものをデータベースに保存。
ユーザーの認証は、パスワードの送信、ハッシュ化、データベース内のハッシュ化された値との比較、という手順で進んでいく。
比較の結果が一致すれば、送信されたパスワードは正しいと認識され、そのユーザーは認証される。
この『ハッシュ化された値との比較』というのがポイント。生のパスワードをデータベースに保存しなくても、認証することができる。
仮にデータベースの内容が盗まれたとしてもパスワードの安全性は確保される。  
  
#### ハッシュ化されたパスワード
**has_secure_password**  
セキュアなパスワードを設定するには、このメソッドを使えばよい。
このメソッドは以下の機能を使える。  
* セキュアにハッシュ化したパスワードを、データベース内のpassword_digestという属性に保存できるようになる。
* 2つのペアの仮想的な属性 (passwordとpassword_confirmation) が使えるようになる。また、存在性と値が一致するかどうかのバリデーションも追加される18 。
* authenticateメソッドが使えるようになる (引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返すメソッド) 。

これを使うための条件が１つある。それは『password_digestという属性が含まれていること。』  
  
users
* id
* name
* email
* created_at
* updated_at
* password_digest

したがって、usersモデルにpassword_digestのカラムを追加する。  
```
$ rails g migration add_password_digest_to_users password_digest:string
      invoke  active_record
      create    db/migrate/20200905212601_add_password_digest_to_users.rb
```
  
db/migrate/20200905212601_add_password_digest_to_users.rb  
```
class AddPasswordDigestToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_digest, :string
  end
end
```
上述のようにチェンジメソッドに、usersテーブルにpassword_digestコラムをstring型として追加されるように自動的に記載される。  
  
**混乱するところ**  
さきほど、emailカラムにindexを追加したが、それは手動でadd_indexメソッドを記載したなと思う。あのときはなぜ同じように自動的に追記されなかったの？  
今回のpassword_digestはusersテーブルにカラムを追加したが、indexはemailカラムにindexを追加した。つまり、追加した階層が異なる。  
テーブルにカラムを追加する場合とカラムにデータを追加する場合では違うため、混乱しないよう注意。  
users
* id
* name
* email ---- email  
          ┗- index_users_on_email
* created_at
* updated_at
* password_digest

こんな感じだと思う。index_users_on_emailって名前は、おそらくadd_indexメソッドの仕業だと思う。  
これを適用するために、データベースでマイグレートを実行する  
```
rails db:migrate
```
  
db/schema.rb  
```
ActiveRecord::Schema.define(version: 20200905212601) do

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
+   t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
```
password_digestコラムが追加された。  
has_secure_passwordを使ってパスワードをハッシュ化するためには、最先端のハッシュ関数であるbcryptが必要になる。
パスワードを適切にハッシュ化することで、たとえ攻撃者によってデータベースからパスワードが漏れてしまった場合でも、
Webサイトにログインされないようにできる。  
Gemfileにbcryptを追加し、インストールをする。  
Gemfile  
```
...

gem 'bcrypt',         '3.1.12'

...
```
```
$ bundle install
```
これで、Userモデルにpassword_digest属性を追加し、Gemfileにbcryptを追加したことで、ようやくUserモデル内でhas_secure_passwordが使えるようになる。  
今、テストを行うと失敗する。理由はhas_secure_passwordは仮想的にpassword属性とpassword_confirmation属性に対してバリデーションをする機能も(強制的に)追加されているから。
そのため、テストのsetupメソッドでpassword属性とpassword_confirmation属性の設定をしてあげる。  
test/models/user_test.rb  
```
class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

...

```
そうすると、テストはパスできる。  
#### パスワードの最小文字数
パスワードを簡単に当てられないようにするために、パスワードの最小文字数を設定しておくことは一般に実用的。
Railsでパスワードの長さを設定する方法はたくさんあるが、今回は簡潔にパスワードが『空でないこと』と『最小文字数 (6文字)』 の2つを設定する。  
まずは、テストケースから作成。  
test/models/user_test.rb  
```
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
```
ちなみに、rubyのテクを紹介している。『@user.password = @user.password_confirmation = " " * 6 』多重代入を行っている。  

では、validationを書く。  
app/model/user.rb  
```
  validates :password, presence: true, length: { minimum: 6 }
```
上記を追記してあげる。  
テストがパスするはず。  
  
### 6章のまとめ
* マイグレーションを使うことで、アプリケーションのデータモデルを修正することができる
* Active Recordを使うと、データモデルを作成したり操作したりするための多数のメソッドが使えるようになる
* Active Recordのバリデーションを使うと、モデルに対して制限を追加することができる
* よくあるバリデーションには、存在性・長さ・フォーマットなどがある
* 正規表現は謎めいて見えるが非常に強力である
* データベースにインデックスを追加することで検索効率が向上する。また、データベースレベルでの一意性を保証するためにも使われる
* has_secure_passwordメソッドを使うことで、モデルに対してセキュアなパスワードを追加することができる