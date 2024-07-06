# PowerShellでスクレイピングしてみよう！（……by brute force……ｗ）

ここでは「基本的に環境構築しない！」をモットーに頑張ってみます。静的コンテンツはPowerShellのみで完結できそうですが、HTML要素とかが非常に見づらい。。

※ **スクレイピングするサイトの利用規約、データの著作権等は十分ご注意ください。** たとえば、[Google検索結果をスクレイピングするのは規約違反](https://support.google.com/adspolicy/answer/6169371?hl=ja) なもよう。。（代わりに提供されているAPIを使いなさいとのこと）<br>
※APIが提供されていない動的コンテンツは、Selenium等を使わないと取得できなさそう。。


## 準備：PowerShellのバージョンを確認しよう！
PowerShellコンソールを開いて作業用フォルダに移動後、 `$PSVersionTable` をたたいてバージョン確認をしておきます。ヘルプを参照する際は、使っている `PSVersion` のものを確認する必要があります。
```
PS C:\work> $PSVersionTable

Name                           Value
----                           -----
PSVersion                      5.1.19041.4291
PSEdition                      Desktop
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
BuildVersion                   10.0.19041.4291
CLRVersion                     4.0.30319.42000
WSManStackVersion              3.0
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
```


## おためし１：株式会社サイノウのHPをスクレイピングしてみる
エンジニアカフェのHPだとコンテンツが動的に生成されていて難しいので、運営会社である [株式会社サイノウのHP](http://saino.co/) を題材にしてみます。

### ステップ１：URLを変数に設定する
```
PS C:\work> $SainoUrl = 'http://saino.co/'
```
※読みやすいように変数に格納しているだけで、 `Invoke-WebRequest` のときに直接URLを書いてもOKです。


### ステップ２： `Invoke-WebRequest` でクエリを投げて結果を取得する
```
PS C:\work> $SainoRes = Invoke-WebRequest -Uri $SainoUrl
```
※ `$SainoRes` をたたくと、どんな情報を取得したかが見えます。

### ステップ３：ブラウザの開発者ツールか `.Content` で内容を見てアタリを付ける
```
PS C:\work> $SainoRes.Content
```
※`Invoke-WebRequest` だと、ブラウザの開発者ツールで見た結果と内容がちょいちょい違うようで、DOM操作するときは `.Content` を最終的に見ることになりそう……

### ステップ４：テキストを取得してみる
```
PS C:\work> $SainoRes.ParsedHtml.getElementsByClassName('sectionWrapper')[0].childNodes[1].innerText
```
※ `ParsedHtml` で、DOM操作ができる内容にしてくれる。IEのエンジンが動いてパースするらしいです。<br>
※ `ParsedHtml` で使えるメソッドなどは、以下のように  `Get-Member` へパイプしてやると分かります。
```
PS C:\work> $SainoRes.ParsedHtml | Get-Member
```


## おためし２：スクレイピングするPowerShellスクリプトを作ってみよう！
以下の動きをするPowerShellスクリプトを作成してみてください！
1. ps1ファイル実行時の引数を、リクエスト先URLとして保存する
2.  `Invoke-WebRequest` を使って、サイト情報を取得する
3. 取得したサイト情報からウェブサイトのタイトルを取得する
4. 取得したタイトルをコンソール表示する
5. 取得したタイトルをテキストファイルに出力する

※スクレイピングを試すさいは、「スクレイピング　練習サイト」などでググって、 **「スクレイピングしても良い」と明確に記載されているサイトを** スクレイピング対象にお使いください！！


## おためし３：作ったPowerShellスクリプトをカスタマイズしてみよう！
おためしで作ったPowerShellスクリプトの不便なところを改善したり、機能を追加したり改造してみましょう！

ここに出てこなかったコマンドレットやオプションもぜひ試してみてください！作り方もググると結構出てきます！


## おためし４：WikipediaのAPIを使ってみよう！（スクレイピングじゃないけど）
スクレイピングよりも提供されているAPIを使いなさい、というような流れがあるので、APIを使った情報取得もやってみましょう！ `Invoke-WebRequest` でもやれそうですが、今回は `Invoke-RestMethod` を使ってWikipediaの特定ページから要約を取得してみましょう。
```
# 記事のタイトル
$articleTitle = "Linux"

# APIエンドポイントの設定
$uri = "https://ja.wikipedia.org/w/api.php"

# APIリクエストのパラメータ
$params = @{
    action = "query"
    format = "json"
    prop = "extracts"
    exintro = $true
    explaintext = $true
    titles = $articleTitle
    redirects = $true
}

# APIからデータを取得
$response = Invoke-RestMethod -Uri $uri -Method Get -Body $params

# レスポンスから要約を抽出
$page = $response.query.pages.PSObject.Properties.Value
$summary = $page.extract

# 要約の表示
Write-Output "要約: $summary"
```
※参考：[MediaWiki](https://www.mediawiki.org/wiki/API:Main_page/ja)

