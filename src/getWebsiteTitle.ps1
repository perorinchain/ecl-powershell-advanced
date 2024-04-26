# 引数としてサイトURLを受け取る
Param(
 [String]$WebSiteUrl
)

# サイト情報を取得
$WebSiteRes = Invoke-WebRequest -Uri $WebSiteUrl
# サイト情報からタイトルを取得
$WebSiteTitle = $WebSiteRes.ParsedHtml.getElementsByTagName('title')[0].innerText

# 取得したタイトルをコンソールに表示
Write-Host $WebSiteTitle
# 取得したタイトルをテキストファイルに書き出し
Write-Output $WebSiteTitle > .\websitetitle.txt
